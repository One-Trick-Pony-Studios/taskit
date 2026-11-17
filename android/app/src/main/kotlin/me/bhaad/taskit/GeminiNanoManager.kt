package me.bhaad.taskit

import android.content.Context
import android.util.Log
import com.google.mlkit.genai.common.DownloadStatus
import com.google.mlkit.genai.common.FeatureStatus
import com.google.mlkit.genai.prompt.GenerateContentRequest
import com.google.mlkit.genai.prompt.Generation
import com.google.mlkit.genai.prompt.GenerativeModel
import com.google.mlkit.genai.prompt.PromptPrefix
import com.google.mlkit.genai.prompt.TextPart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

object GeminiNanoManager {
    private const val TAG = "GeminiNanoManager"

    // Static system instruction to leverage AICore prefix caching
    private const val SYSTEM_INSTRUCTION =
        "You are a calendar event extractor. Extract event details based on the provided current date and time anchor. " +
        "Output ONLY a single JSON object with keys: \"title\" (concise string), \"isoDate\" (YYYY-MM-DD or null), \"time24h\" (HH:mm in 24h format or null). " +
        "Do not include markdown format or extra text."

    private var client: GenerativeModel? = null

    @Synchronized
    fun getModel(): GenerativeModel {
        if (client == null) {
            client = Generation.getClient()
        }
        return client!!
    }

    suspend fun checkStatus(context: Context): String = withContext(Dispatchers.IO) {
        try {
            val model = getModel()
            val status = model.checkStatus()
            Log.d(TAG, "Gemini Nano checkStatus code: $status")
            val isCapable = status != FeatureStatus.UNAVAILABLE
            AiPreferences.setDeviceAiCapable(context, isCapable)
            when (status) {
                FeatureStatus.AVAILABLE -> "available"
                FeatureStatus.DOWNLOADABLE -> "downloadable"
                FeatureStatus.DOWNLOADING -> "downloading"
                else -> "unavailable"
            }
        } catch (e: Throwable) {
            Log.w(TAG, "checkStatus error: ${e.message}")
            AiPreferences.setDeviceAiCapable(context, false)
            "unavailable"
        }
    }

    suspend fun warmup(context: Context) = withContext(Dispatchers.IO) {
        if (!AiPreferences.isAiParsingEnabled(context) || !AiPreferences.isDeviceAiCapable(context)) {
            return@withContext
        }
        try {
            Log.d(TAG, "Triggering Gemini Nano warmup...")
            getModel().warmup()
            Log.d(TAG, "Gemini Nano warmup completed.")
        } catch (e: Throwable) {
            Log.w(TAG, "Gemini Nano warmup failed or busy: ${e.message}")
        }
    }

    fun download(): Flow<DownloadStatus> {
        return getModel().download()
    }

    suspend fun parseEventWithTimeout(
        context: Context,
        text: String,
        timeoutMillis: Long = 2500L
    ): Triple<String, Long?, Long?>? {
        return withTimeoutOrNull(timeoutMillis) {
            withContext(Dispatchers.IO) {
                parseEvent(text)
            }
        }
    }

    private suspend fun parseEvent(text: String): Triple<String, Long?, Long?>? {
        try {
            val model = getModel()
            val anchorFormat = SimpleDateFormat("EEE yyyy-MM-dd HH:mm", Locale.ENGLISH)
            val currentAnchor = anchorFormat.format(Calendar.getInstance().time)

            val promptText = "Now: $currentAnchor\nInput: $text"
            val request = GenerateContentRequest.Builder(TextPart(promptText)).apply {
                promptPrefix = PromptPrefix(SYSTEM_INSTRUCTION)
                maxOutputTokens = 120
                temperature = 0.0f
            }.build()

            val response = model.generateContent(request)
            val candidateText = response.candidates.firstOrNull()?.text ?: return null
            Log.d(TAG, "Gemini Nano candidate output: $candidateText")

            val cleanJson = candidateText.substringAfter("{", "").substringBeforeLast("}", "")
            if (cleanJson.isBlank()) return null
            val jsonObject = JSONObject("{$cleanJson}")

            val title = jsonObject.optString("title").trim().ifBlank { text.trim().take(50) }
            val isoDate = jsonObject.optString("isoDate").trim().takeIf { it.isNotBlank() && it != "null" }
            val time24h = jsonObject.optString("time24h").trim().takeIf { it.isNotBlank() && it != "null" }

            if (isoDate == null && time24h == null) {
                return null
            }

            val calendar = Calendar.getInstance()
            if (isoDate != null) {
                val dateParts = isoDate.split("-")
                if (dateParts.size == 3) {
                    val year = dateParts[0].toIntOrNull()
                    val month = dateParts[1].toIntOrNull()
                    val day = dateParts[2].toIntOrNull()
                    if (year != null && month != null && day != null) {
                        calendar.set(Calendar.YEAR, year)
                        calendar.set(Calendar.MONTH, month - 1)
                        calendar.set(Calendar.DAY_OF_MONTH, day)
                    }
                }
            }

            if (time24h != null) {
                val timeParts = time24h.split(":")
                if (timeParts.size >= 2) {
                    val hour = timeParts[0].trim().toIntOrNull()
                    val minute = timeParts[1].trim().toIntOrNull()
                    if (hour != null && minute != null) {
                        calendar.set(Calendar.HOUR_OF_DAY, hour)
                        calendar.set(Calendar.MINUTE, minute)
                        calendar.set(Calendar.SECOND, 0)
                        calendar.set(Calendar.MILLISECOND, 0)
                    }
                }
            } else {
                calendar.set(Calendar.HOUR_OF_DAY, 10)
                calendar.set(Calendar.MINUTE, 0)
                calendar.set(Calendar.SECOND, 0)
                calendar.set(Calendar.MILLISECOND, 0)
            }

            val startTime = calendar.timeInMillis
            val endTime = startTime + 3600000L
            return Triple(title, startTime, endTime)
        } catch (e: Throwable) {
            Log.e(TAG, "Failed parsing with Gemini Nano: ${e.message}")
            return null
        }
    }
}
