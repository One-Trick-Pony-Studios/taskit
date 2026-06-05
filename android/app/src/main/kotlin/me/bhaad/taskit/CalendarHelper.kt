package me.bhaad.taskit

import android.content.Context
import android.content.Intent
import android.provider.CalendarContract
import android.util.Log
import java.text.SimpleDateFormat
import java.util.*

object CalendarHelper {
    private const val TAG = "CalendarHelper"

    fun parseTextForEventDetails(text: String?): Triple<String, Long?, Long?> {
        if (text.isNullOrBlank()) return Triple("TaskIt Task", null, null)

        val lower = text.lowercase(Locale.getDefault())
        val calendar = Calendar.getInstance()
        var dateMatched = false
        var timeMatched = false

        // Pass 0: Full date-time block (e.g. "Sun Oct 05 2025 at 05:00 am")
        val fullDateTimeFormats = listOf(
            "EEE MMM dd yyyy 'at' hh:mm a",
            "EEE MMM d yyyy 'at' hh:mm a",
            "dd MMM yyyy 'at' hh:mm a",
            "d MMM yyyy 'at' hh:mm a",
            "d MMMM yyyy 'at' hh:mm a",
            "dd-MM-yyyy 'at' HH:mm",
            "dd/MM/yyyy 'at' HH:mm",
            "yyyy-MM-dd 'at' HH:mm"
        )
        val fullDateTimeRegex = Regex("""\b(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)?\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2}\s+\d{4}\s+at\s+\d{1,2}[:.]\d{2}\s*(am|pm)?""", RegexOption.IGNORE_CASE)

        fullDateTimeRegex.findAll(text).forEach { match ->
            for (format in fullDateTimeFormats) {
                try {
                    val sdf = SimpleDateFormat(format, Locale.ENGLISH)
                    sdf.isLenient = false
                    val parsed = sdf.parse(match.value)
                    if (parsed != null) {
                        calendar.time = parsed
                        dateMatched = true
                        timeMatched = true
                        break
                    }
                } catch (_: Exception) {}
            }
            if (dateMatched && timeMatched) return@forEach
        }

        // Pass 1: Time extraction (if not already matched)
        if (!timeMatched) {
            val explicitTimeRegex = Regex("""\b(\d{1,2})([:.](\d{2}))?\s*(am|pm)?\b""")
            val timeOfDayRegex = Regex("""\b(morning|afternoon|evening|night|noon|midnight)\b""")

            explicitTimeRegex.find(lower)?.let { match ->
                val hour = match.groupValues[1].toIntOrNull() ?: return Triple(text.trim(), null, null)
                val minute = match.groupValues[3].ifEmpty { "0" }.toIntOrNull() ?: 0
                val ampm = match.groupValues[4]

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
        }

        // Pass 2: Relative date extraction
        if (!dateMatched) {
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
        }

        // Pass 3: Fuzzy and numeric date formats
        if (!dateMatched) {
            val dateFormats = listOf(
                "EEE MMM dd yyyy", "EEE MMM d yyyy",
                "dd MMM yyyy", "d MMM yyyy",
                "d MMMM yyyy", "dd-MM-yyyy", "d-M-yyyy",
                "dd/MM/yyyy", "d/M/yyyy", "dd.MM.yyyy",
                "yyyy-MM-dd",
                "d'st' MMM yyyy", "d'nd' MMM yyyy", "d'rd' MMM yyyy", "d'th' MMM yyyy",
                "d'st' MMMM yyyy", "d'nd' MMMM yyyy", "d'rd' MMMM yyyy", "d'th' MMMM yyyy",
                "d MMM", "d MMMM", "MMM d", "MMMM d"
            )

            val fuzzyDateRegex = Regex("""\b\d{1,2}(st|nd|rd|th)?\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\b""", RegexOption.IGNORE_CASE)
            val weekdayDateRegex = Regex("""\b(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2}\s+\d{4}\b""", RegexOption.IGNORE_CASE)
            val numericDateRegex = Regex("""\b\d{1,4}[-/.]\d{1,2}[-/.]\d{2,4}\b""")

            val allDateMatches = fuzzyDateRegex.findAll(text).map { it.value } +
                                weekdayDateRegex.findAll(text).map { it.value } +
                                numericDateRegex.findAll(text).map { it.value }

            for (rawDate in allDateMatches) {
                for (format in dateFormats) {
                    try {
                        val sdf = SimpleDateFormat(format, Locale.ENGLISH)
                        sdf.isLenient = false
                        val parsedDate = sdf.parse(rawDate)
                        if (parsedDate != null) {
                            val parsedCal = Calendar.getInstance().apply { time = parsedDate }

                            if (!format.contains("yyyy")) {
                                val now = Calendar.getInstance()
                                parsedCal.set(Calendar.YEAR, now.get(Calendar.YEAR))
                                if (parsedCal.before(now)) {
                                    parsedCal.add(Calendar.YEAR, 1)
                                }
                            }

                            calendar.set(Calendar.YEAR, parsedCal.get(Calendar.YEAR))
                            calendar.set(Calendar.MONTH, parsedCal.get(Calendar.MONTH))
                            calendar.set(Calendar.DAY_OF_MONTH, parsedCal.get(Calendar.DAY_OF_MONTH))
                            dateMatched = true
                            break
                        }
                    } catch (_: Exception) {}
                }
                if (dateMatched) break
            }
        }

        val startTime = if (dateMatched || timeMatched) calendar.timeInMillis else null
        val endTime = startTime?.plus(3600000)

        return Triple(text.trim(), startTime, endTime)
    }

    fun dispatchCalendarIntent(
        context: Context,
        title: String?,
        startTime: Long? = null,
        endTime: Long? = null,
        fullText: String? = null
    ): Boolean {
        val resolvedTitle = if (title.isNullOrBlank()) "TaskIt Task" else title
        val intent = Intent(Intent.ACTION_INSERT).apply {
            data = CalendarContract.Events.CONTENT_URI
            putExtra(CalendarContract.Events.TITLE, resolvedTitle)
            putExtra(CalendarContract.Events.DESCRIPTION, "${fullText ?: resolvedTitle}\n\n(Shared via TaskIt)")
            putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime ?: System.currentTimeMillis())
            putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime ?: (System.currentTimeMillis() + 3600000))
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        return try {
            context.startActivity(intent)
            Log.d(TAG, "Successfully launched calendar intent for title: $title")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch calendar intent: ${e.message}")
            false
        }
    }
}
