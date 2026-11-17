package me.bhaad.taskit

import android.Manifest
import android.app.Activity
import android.content.ClipboardManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.core.content.ContextCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

class ClipboardActivity : Activity() {
    private var hasProcessed = false
    private val activityScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check write calendar permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_CALENDAR)
            != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "Calendar permission is required. Please open TaskIt first.", Toast.LENGTH_LONG).show()
            finish()
            return
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        activityScope.cancel()
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)

        if (hasFocus && !hasProcessed) {
            hasProcessed = true
            readFromClipboardAndInsertEvent()
        }
    }

    private fun readFromClipboardAndInsertEvent() {
        // Read clipboard text
        val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clipData = clipboard.primaryClip
        if (clipData != null && clipData.itemCount > 0) {
            val copiedText = clipData.getItemAt(0).text?.toString()
            if (!copiedText.isNullOrBlank()) {
                // 1. Always run existing regex parser first (<15ms)
                val (regexTitle, regexStart, regexEnd) = CalendarHelper.parseTextForEventDetails(copiedText)

                val isAiEnabled = AiPreferences.isAiParsingEnabled(this)
                val isAiCapable = AiPreferences.isDeviceAiCapable(this)

                // 2. Fast Path (0ms AI latency):
                // If regex extracted a clear date/time, OR if AI is disabled / device incapable
                if (regexStart != null || !isAiEnabled || !isAiCapable) {
                    val success = CalendarHelper.dispatchCalendarIntent(this, regexTitle, regexStart, regexEnd, copiedText)
                    if (!success) {
                        Toast.makeText(this, "Failed to launch calendar application.", Toast.LENGTH_LONG).show()
                    }
                    finish()
                    return
                }

                // 3. Slow Path (Ambiguous/Complex Text Fallback with Gemini Nano):
                Toast.makeText(this, "Parsing schedule...", Toast.LENGTH_SHORT).show()
                activityScope.launch {
                    val aiResult = GeminiNanoManager.parseEventWithTimeout(this@ClipboardActivity, copiedText, 2500L)
                    if (aiResult != null && aiResult.second != null) {
                        CalendarHelper.dispatchCalendarIntent(
                            this@ClipboardActivity,
                            aiResult.first,
                            aiResult.second,
                            aiResult.third,
                            copiedText
                        )
                    } else {
                        // Nano timed out or couldn't parse: fallback immediately to regex best-effort
                        CalendarHelper.dispatchCalendarIntent(
                            this@ClipboardActivity,
                            regexTitle,
                            null,
                            null,
                            copiedText
                        )
                    }
                    finish()
                }
                return
            } else {
                Toast.makeText(this, "Clipboard is empty.", Toast.LENGTH_SHORT).show()
            }
        } else {
            Toast.makeText(this, "No text found in clipboard.", Toast.LENGTH_SHORT).show()
        }

        finish()
    }
}

