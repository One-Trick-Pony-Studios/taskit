package me.bhaad.taskit

import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import android.util.Log
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterFragmentActivity() {
    private var sharedText: String? = null
    private val PROCESS_TEXT_CHANNEL = "app.channel.process.data"
    private val CALENDAR_CHANNEL = "app.channel.calendar"
    private val TAG = "MainActivity"

    private var pendingCalendarTitle: String? = null
    private var pendingStartTime: Long? = null
    private var pendingEndTime: Long? = null
    private var pendingFullText: String? = null

    private lateinit var calendarPermissionLauncher: ActivityResultLauncher<String>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        calendarPermissionLauncher = registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted ->
            if (isGranted) {
                Log.d(TAG, "Calendar permission granted via launcher")
                redirectToCalendar(pendingCalendarTitle, pendingStartTime, pendingEndTime, pendingFullText)
            } else {
                Log.w(TAG, "Calendar permission denied via launcher")
                finish()
            }
        }

        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val action = intent.action
        val type = intent.type
        when {
            Intent.ACTION_PROCESS_TEXT == action && type == "text/plain" -> {
                sharedText = intent.getStringExtra(Intent.EXTRA_PROCESS_TEXT)
                Log.d(TAG, "Received 'Create Task' text: $sharedText")
            }
            Intent.ACTION_SEND == action && type == "text/plain" -> {
                sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
                Log.d(TAG, "Received 'Share' text: $sharedText")
            }
        }
        if (!sharedText.isNullOrBlank()) {
            Log.d(TAG, "Scheduling redirect for text: $sharedText")
            val (title, startTime, endTime) = parseTextForEventDetails(sharedText!!)
            pendingCalendarTitle = title
            pendingStartTime = startTime
            pendingEndTime = endTime
            pendingFullText = sharedText
            window.decorView.post {
                redirectToCalendar(title, startTime, endTime, sharedText)
            }
        } else {
            Log.d(TAG, "No shared text to process, finishing activity")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PROCESS_TEXT_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getSharedText") {
                    Log.d(TAG, "getSharedText called, returning: $sharedText")
                    result.success(sharedText)
                    sharedText = null
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALENDAR_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "addCalendarEvent" -> {
                        val title = call.argument<String>("title")
                        val startTime = call.argument<Long>("startTime")
                        val endTime = call.argument<Long>("endTime")
                        redirectToCalendar(title, startTime, endTime, sharedText)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun redirectToCalendar(
        title: String?,
        startTime: Long? = null,
        endTime: Long? = null,
        fullText: String? = null
    ) {
        if (title.isNullOrBlank()) {
            Log.w(TAG, "Title is null or blank, skipping redirect")
            return
        }

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_CALENDAR)
            != PackageManager.PERMISSION_GRANTED) {
            Log.w(TAG, "Calendar permission not granted, requesting...")
            pendingCalendarTitle = title
            pendingStartTime = startTime
            pendingEndTime = endTime
            pendingFullText = fullText
            calendarPermissionLauncher.launch(Manifest.permission.WRITE_CALENDAR)
            return
        }

        val intent = Intent(Intent.ACTION_INSERT).apply {
            data = CalendarContract.Events.CONTENT_URI
            putExtra(CalendarContract.Events.TITLE, title.ifEmpty { "TaskIt Task" })
            putExtra(CalendarContract.Events.DESCRIPTION, "${fullText ?: title}\n\n(Shared via TaskIt)")
            putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime ?: System.currentTimeMillis())
            putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime ?: System.currentTimeMillis() + 3600000)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        try {
            startActivity(intent)
            Log.d(TAG, "Successfully launched calendar intent for title: $title")
            finish()
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch calendar intent: ${e.message}")
            finish()
        }
    }

    private fun parseTextForEventDetails(text: String?): Triple<String, Long?, Long?> {
        if (text.isNullOrBlank()) return Triple("TaskIt Task", null, null)

        val lower = text.lowercase()
        val calendar = Calendar.getInstance()
        var dateMatched = false
        var timeMatched = false

        // Pass 1: Time extraction
        val explicitTimeRegex = Regex("""\b(\d{1,2})([:.](\d{2}))?\s*(am|pm)?\b""")

        val timeOfDayRegex = Regex("""\b(morning|afternoon|evening|night|noon|midnight)\b""")

        explicitTimeRegex.find(lower)?.let { match ->
            val hour = match.groupValues[1].toIntOrNull() ?: return Triple(text.trim(), null, null)
            val minute = match.groupValues[2].ifEmpty { "0" }.toIntOrNull() ?: 0
            val ampm = match.groupValues[3]

            val resolvedHour = when (ampm) {
                "pm" -> if (hour < 12) hour + 12 else hour
                "am" -> if (hour == 12) 0 else hour
                else -> hour
            }

            calendar.set(Calendar.HOUR_OF_DAY, resolvedHour)
            calendar.set(Calendar.MINUTE, minute)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)
            timeMatched = true
        }

        if (!timeMatched) {
            timeOfDayRegex.find(lower)?.let { match ->
                val phrase = match.groupValues[1]
                val defaultHour = when (phrase) {
                    "morning" -> 9
                    "afternoon" -> 14
                    "evening" -> 18
                    "night" -> 21
                    "noon" -> 12
                    "midnight" -> 0
                    else -> 10
                }
                calendar.set(Calendar.HOUR_OF_DAY, defaultHour)
                calendar.set(Calendar.MINUTE, 0)
                calendar.set(Calendar.SECOND, 0)
                calendar.set(Calendar.MILLISECOND, 0)
                timeMatched = true
            }
        }

        // Pass 2: Date extraction
        when {
            "today" in lower -> {
                dateMatched = true
            }
            "tomorrow" in lower -> {
                calendar.add(Calendar.DAY_OF_YEAR, 1)
                dateMatched = true
            }
            "day after tomorrow" in lower -> {
                calendar.add(Calendar.DAY_OF_YEAR, 2)
                dateMatched = true
            }
            Regex("""\b(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b""").find(lower)?.let { match ->
                val targetDay = match.value.lowercase()
                val today = calendar.get(Calendar.DAY_OF_WEEK)
                val target = mapOf(
                    "sunday" to Calendar.SUNDAY,
                    "monday" to Calendar.MONDAY,
                    "tuesday" to Calendar.TUESDAY,
                    "wednesday" to Calendar.WEDNESDAY,
                    "thursday" to Calendar.THURSDAY,
                    "friday" to Calendar.FRIDAY,
                    "saturday" to Calendar.SATURDAY
                )[targetDay] ?: today
                val delta = (target - today + 7) % 7
                calendar.add(Calendar.DAY_OF_YEAR, delta)
                dateMatched = true
            } != null -> Unit
        }

        val startTime = if (dateMatched || timeMatched) calendar.timeInMillis else null
        val endTime = startTime?.plus(3600000)

        return Triple(text.trim(), startTime, endTime)
    }
}
