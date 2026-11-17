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
        var explicitEndCalendar: Calendar? = null
        var dateMatched = false
        var timeMatched = false
        val matchedSnippets = mutableListOf<String>()

        // ------------------------------------------------------------------
        // Pass 0: Full date-time block (e.g. "Sun Oct 05 2025 at 05:00 am")
        // ------------------------------------------------------------------
        val fullDateTimeFormats = listOf(
            "EEE MMM dd yyyy 'at' hh:mm a",
            "EEE MMM d yyyy 'at' hh:mm a",
            "dd MMM yyyy 'at' hh:mm a",
            "d MMM yyyy 'at' hh:mm a",
            "d MMMM yyyy 'at' hh:mm a",
            "dd-MM-yyyy 'at' HH:mm",
            "dd/MM/yyyy 'at' HH:mm",
            "yyyy-MM-dd 'at' HH:mm",
            "yyyy-MM-dd'T'HH:mm"
        )
        val fullDateTimeRegex = Regex(
            """\b(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)?\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2}\s+\d{4}\s+at\s+\d{1,2}[:.]\d{2}\s*(am|pm)?""",
            RegexOption.IGNORE_CASE
        )

        fullDateTimeRegex.findAll(text).forEach { match ->
            for (format in fullDateTimeFormats) {
                try {
                    val sdf = SimpleDateFormat(format, Locale.ENGLISH).apply { isLenient = false }
                    val parsed = sdf.parse(match.value)
                    if (parsed != null) {
                        calendar.time = parsed
                        dateMatched = true
                        timeMatched = true
                        matchedSnippets.add(match.value)
                        break
                    }
                } catch (_: Exception) {}
            }
            if (dateMatched && timeMatched) return@forEach
        }

        // ------------------------------------------------------------------
        // Pass 1: Time range & Time extraction
        // ------------------------------------------------------------------
        if (!timeMatched) {
            // A. Time range check (e.g. "2pm to 3:30pm", "2 - 4 pm", "from 10:00 to 11:30 am")
            val timeRangeRegex = Regex(
                """\b(?:from\s+)?(\d{1,2}(?:[:.]\d{2})?\s*(?:am|pm)?)\s*(?:-|to|until|till)\s*(\d{1,2}(?:[:.]\d{2})?\s*(am|pm))\b""",
                RegexOption.IGNORE_CASE
            )
            val rangeMatch = timeRangeRegex.find(lower)
            if (rangeMatch != null) {
                val startRaw = rangeMatch.groupValues[1].trim()
                val endRaw = rangeMatch.groupValues[2].trim()
                val endAmPm = rangeMatch.groupValues[3].trim().lowercase()

                val startParsed = parseTimeComponents(startRaw, defaultAmPm = endAmPm)
                val endParsed = parseTimeComponents(endRaw, defaultAmPm = endAmPm)

                if (startParsed != null && endParsed != null) {
                    calendar.set(Calendar.HOUR_OF_DAY, startParsed.first)
                    calendar.set(Calendar.MINUTE, startParsed.second)
                    calendar.set(Calendar.SECOND, 0)
                    calendar.set(Calendar.MILLISECOND, 0)
                    timeMatched = true

                    explicitEndCalendar = (calendar.clone() as Calendar).apply {
                        set(Calendar.HOUR_OF_DAY, endParsed.first)
                        set(Calendar.MINUTE, endParsed.second)
                        set(Calendar.SECOND, 0)
                        set(Calendar.MILLISECOND, 0)
                    }
                    matchedSnippets.add(rangeMatch.value)
                }
            }

            // B. Single explicit time (avoids false-matching lone numbers like "room 4")
            if (!timeMatched) {
                // Must have am/pm, OR explicit minutes (HH:mm), OR preceded by at/around/@/by
                val amPmTimeRegex = Regex("""\b(\d{1,2})(?:[:.](\d{2}))?\s*(am|pm)\b""", RegexOption.IGNORE_CASE)
                val minuteTimeRegex = Regex("""\b([01]?\d|2[0-3])[:.](\d{2})\b""")
                val prepTimeRegex = Regex("""\b(?:at|around|@|by)\s+(\d{1,2})(?:[:.](\d{2}))?\s*(am|pm)?\b""", RegexOption.IGNORE_CASE)

                val amPmMatch = amPmTimeRegex.find(lower)
                val minuteMatch = minuteTimeRegex.find(lower)
                val prepMatch = prepTimeRegex.find(lower)

                when {
                    amPmMatch != null -> {
                        val hour = amPmMatch.groupValues[1].toIntOrNull() ?: 10
                        val minute = amPmMatch.groupValues[2].ifEmpty { "0" }.toIntOrNull() ?: 0
                        val ampm = amPmMatch.groupValues[3].lowercase()
                        val resolvedHour = resolveHour(hour, ampm)
                        setTime(calendar, resolvedHour, minute)
                        timeMatched = true
                        matchedSnippets.add(amPmMatch.value)
                    }
                    prepMatch != null -> {
                        val hour = prepMatch.groupValues[1].toIntOrNull() ?: 10
                        val minute = prepMatch.groupValues[2].ifEmpty { "0" }.toIntOrNull() ?: 0
                        val ampm = prepMatch.groupValues[3].lowercase().ifEmpty { null }
                        val resolvedHour = resolveHour(hour, ampm)
                        setTime(calendar, resolvedHour, minute)
                        timeMatched = true
                        matchedSnippets.add(prepMatch.value)
                    }
                    minuteMatch != null -> {
                        val hour = minuteMatch.groupValues[1].toIntOrNull() ?: 10
                        val minute = minuteMatch.groupValues[2].toIntOrNull() ?: 0
                        setTime(calendar, hour, minute)
                        timeMatched = true
                        matchedSnippets.add(minuteMatch.value)
                    }
                }
            }

            // C. Time of day descriptive words (multilingual)
            if (!timeMatched) {
                val timeOfDayRegex = Regex(
                    """\b(morning|afternoon|evening|night|noon|midnight|mañana|tarde|noche|mediodía|morgens|nachmittag|abend|nacht|mittag|matin|après-midi|apres-midi|soir|nuit|midi|सुबह|दोपहर|शाम|रात)\b""",
                    RegexOption.IGNORE_CASE
                )
                timeOfDayRegex.find(lower)?.let { match ->
                    val word = match.groupValues[1].lowercase()
                    val defaultHour = when (word) {
                        "morning", "mañana", "morgens", "matin", "सुबह" -> 9
                        "afternoon", "tarde", "nachmittag", "après-midi", "apres-midi", "दोपहर" -> 14
                        "evening", "abend", "soir", "शाम" -> 18
                        "night", "noche", "nacht", "nuit", "रात" -> 21
                        "noon", "mediodía", "mittag", "midi" -> 12
                        "midnight" -> 0
                        else -> 10
                    }
                    setTime(calendar, defaultHour, 0)
                    timeMatched = true
                    matchedSnippets.add(match.value)
                }
            }
        }

        // ------------------------------------------------------------------
        // Pass 2: Relative offsets (e.g. "in 30 mins", "in 2 hours", "in 3 days")
        // ------------------------------------------------------------------
        if (!timeMatched || !dateMatched) {
            val offsetRegex = Regex("""\bin\s+(\d+)\s*(mins?|minutes?|hours?|hrs?|days?|weeks?)\b""", RegexOption.IGNORE_CASE)
            offsetRegex.find(lower)?.let { match ->
                val amount = match.groupValues[1].toIntOrNull() ?: 0
                val unit = match.groupValues[2].lowercase()
                when {
                    unit.startsWith("min") -> {
                        calendar.add(Calendar.MINUTE, amount)
                        timeMatched = true
                    }
                    unit.startsWith("hour") || unit.startsWith("hr") -> {
                        calendar.add(Calendar.HOUR_OF_DAY, amount)
                        timeMatched = true
                    }
                    unit.startsWith("day") -> {
                        calendar.add(Calendar.DAY_OF_YEAR, amount)
                        dateMatched = true
                    }
                    unit.startsWith("week") -> {
                        calendar.add(Calendar.WEEK_OF_YEAR, amount)
                        dateMatched = true
                    }
                }
                matchedSnippets.add(match.value)
            }
        }

        // ------------------------------------------------------------------
        // Pass 3: Relative days (Today, Tomorrow, Day after tomorrow, Weekdays)
        // ------------------------------------------------------------------
        if (!dateMatched) {
            val dayAfterTomorrowRegex = Regex("""\b(day after tomorrow|pasado mañana|übermorgen|uebermorgen|après-demain|apres-demain|परसों)\b""", RegexOption.IGNORE_CASE)
            val tomorrowRegex = Regex("""\b(tomorrow|mañana|morgen|demain|कल)\b""", RegexOption.IGNORE_CASE)
            val todayRegex = Regex("""\b(today|hoy|heute|aujourd'hui|आज)\b""", RegexOption.IGNORE_CASE)

            when {
                dayAfterTomorrowRegex.find(lower)?.let { match ->
                    calendar.add(Calendar.DAY_OF_YEAR, 2)
                    dateMatched = true
                    matchedSnippets.add(match.value)
                } != null -> Unit

                tomorrowRegex.find(lower)?.let { match ->
                    calendar.add(Calendar.DAY_OF_YEAR, 1)
                    dateMatched = true
                    matchedSnippets.add(match.value)
                } != null -> Unit

                todayRegex.find(lower)?.let { match ->
                    dateMatched = true
                    matchedSnippets.add(match.value)
                } != null -> Unit

                else -> {
                    // Weekday matching with optional "this" / "next" modifiers
                    val weekdayRegex = Regex(
                        """\b(this|next|coming)?\s*(monday|tuesday|wednesday|thursday|friday|saturday|sunday|lunes|martes|miércoles|miercoles|jueves|viernes|sábado|sabado|domingo|montag|dienstag|mittwoch|donnerstag|freitag|samstag|sonntag|lundi|mardi|mercredi|jeudi|vendredi|samedi|dimanche|सोमवार|मंगलवार|बुधवार|गुरुवार|शुक्रवार|शनिवार|रविवार)\b""",
                        RegexOption.IGNORE_CASE
                    )
                    weekdayRegex.find(lower)?.let { match ->
                        val modifier = match.groupValues[1].lowercase()
                        val rawDay = match.groupValues[2].lowercase()
                        val targetDayOfWeek = mapWeekdayToCalendarDay(rawDay)

                        if (targetDayOfWeek != null) {
                            val today = calendar.get(Calendar.DAY_OF_WEEK)
                            var delta = (targetDayOfWeek - today + 7) % 7
                            if (modifier == "next") {
                                delta = if (delta == 0) 7 else delta + 7
                            } else if (delta == 0) {
                                delta = 7 // Default to upcoming weekday if today
                            }
                            calendar.add(Calendar.DAY_OF_YEAR, delta)
                            dateMatched = true
                            matchedSnippets.add(match.value)
                        }
                    }
                }
            }
        }

        // ------------------------------------------------------------------
        // Pass 4: Fuzzy and numeric date formats
        // ------------------------------------------------------------------
        if (!dateMatched) {
            val dateFormats = listOf(
                "EEE MMM dd yyyy", "EEE MMM d yyyy",
                "dd MMM yyyy", "d MMM yyyy",
                "d MMMM yyyy", "dd-MM-yyyy", "d-M-yyyy",
                "dd/MM/yyyy", "d/M/yyyy", "dd.MM.yyyy",
                "yyyy-MM-dd",
                "MM/dd/yyyy", "M/d/yyyy",
                "MMM dd yyyy", "MMM d yyyy",
                "MMMM dd, yyyy", "MMMM d, yyyy",
                "MMMM d yyyy",
                "d'st' MMM yyyy", "d'nd' MMM yyyy", "d'rd' MMM yyyy", "d'th' MMM yyyy",
                "d'st' MMMM yyyy", "d'nd' MMMM yyyy", "d'rd' MMMM yyyy", "d'th' MMMM yyyy",
                "d MMM", "d MMMM", "MMM d", "MMMM d"
            )

            val fuzzyDateRegex = Regex("""\b\d{1,2}(st|nd|rd|th)?\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\b""", RegexOption.IGNORE_CASE)
            val monthFirstDateRegex = Regex("""\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{1,2}(st|nd|rd|th)?(?:\s*,\s*\d{4})?\b""", RegexOption.IGNORE_CASE)
            val weekdayDateRegex = Regex("""\b(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2}\s+\d{4}\b""", RegexOption.IGNORE_CASE)
            val numericDateRegex = Regex("""\b\d{1,4}[-/.]\d{1,2}[-/.]\d{2,4}\b""")

            val allDateMatches = fuzzyDateRegex.findAll(text).map { it.value } +
                    monthFirstDateRegex.findAll(text).map { it.value } +
                    weekdayDateRegex.findAll(text).map { it.value } +
                    numericDateRegex.findAll(text).map { it.value }

            for (rawDate in allDateMatches) {
                val normalizedRawDate = rawDate.replace(",", "")
                for (format in dateFormats) {
                    try {
                        val sdf = SimpleDateFormat(format, Locale.ENGLISH).apply { isLenient = false }
                        val parsedDate = sdf.parse(normalizedRawDate)
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
                            matchedSnippets.add(rawDate)
                            break
                        }
                    } catch (_: Exception) {}
                }
                if (dateMatched) break
            }
        }

        // ------------------------------------------------------------------
        // Start Time and End Time resolution
        // ------------------------------------------------------------------
        val startTime = if (dateMatched || timeMatched) calendar.timeInMillis else null
        val endTime = when {
            startTime == null -> null
            explicitEndCalendar != null -> {
                // If explicit end time is before start time, advance end by 1 day
                if (explicitEndCalendar.timeInMillis <= startTime) {
                    explicitEndCalendar.add(Calendar.DAY_OF_YEAR, 1)
                }
                explicitEndCalendar.timeInMillis
            }
            else -> startTime + 3600000L // default 1 hour duration
        }

        val cleanTitle = extractCleanTitle(text, matchedSnippets)
        return Triple(cleanTitle, startTime, endTime)
    }

    private fun setTime(calendar: Calendar, hour: Int, minute: Int) {
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)
        calendar.set(Calendar.MILLISECOND, 0)
    }

    private fun resolveHour(hour: Int, ampm: String?): Int {
        return when (ampm) {
            "pm" -> if (hour < 12) hour + 12 else hour
            "am" -> if (hour == 12) 0 else hour
            else -> hour
        }
    }

    private fun parseTimeComponents(raw: String, defaultAmPm: String? = null): Pair<Int, Int>? {
        val regex = Regex("""^(\d{1,2})(?:[:.](\d{2}))?\s*(am|pm)?$""", RegexOption.IGNORE_CASE)
        val match = regex.find(raw) ?: return null
        val hour = match.groupValues[1].toIntOrNull() ?: return null
        val minute = match.groupValues[2].ifEmpty { "0" }.toIntOrNull() ?: 0
        val ampm = match.groupValues[3].ifEmpty { defaultAmPm ?: "" }.lowercase()
        val resolvedHour = resolveHour(hour, ampm.ifEmpty { null })
        return Pair(resolvedHour, minute)
    }

    private fun mapWeekdayToCalendarDay(raw: String): Int? {
        return when (raw) {
            "sunday", "domingo", "sonntag", "dimanche", "रविवार" -> Calendar.SUNDAY
            "monday", "lunes", "montag", "lundi", "सोमवार" -> Calendar.MONDAY
            "tuesday", "martes", "dienstag", "mardi", "मंगलवार" -> Calendar.TUESDAY
            "wednesday", "miércoles", "miercoles", "mittwoch", "mercredi", "बुधवार" -> Calendar.WEDNESDAY
            "thursday", "jueves", "donnerstag", "jeudi", "गुरुवार" -> Calendar.THURSDAY
            "friday", "viernes", "freitag", "vendredi", "शुक्रवार" -> Calendar.FRIDAY
            "saturday", "sábado", "sabado", "samstag", "samedi", "शनिवार" -> Calendar.SATURDAY
            else -> null
        }
    }

    private fun extractCleanTitle(originalText: String, matchedSnippets: List<String>): String {
        val firstLine = originalText.lines().firstOrNull { it.isNotBlank() }?.trim() ?: originalText.trim()
        var cleaned = firstLine

        // Strip common prefix filler words
        val prefixRegex = Regex("""^(?:hey|hi|hello|reminder|don't forget to|remember to|task|todo)[:,\s]+""", RegexOption.IGNORE_CASE)
        cleaned = prefixRegex.replace(cleaned, "").trim()

        // Strip matched date/time phrases along with any preceding time prepositions
        for (snippet in matchedSnippets) {
            if (snippet.isNotBlank() && snippet.length >= 2) {
                val snippetRegex = Regex("""(?:\b(?:at|on|in|by|around|@|from|to)\s+)?\Q$snippet\E""", RegexOption.IGNORE_CASE)
                cleaned = snippetRegex.replace(cleaned, "")
            }
        }

        // Clean up remaining dangling prepositions before punctuation or line end
        cleaned = cleaned.replace(Regex("""\b(?:at|on|in|by|around|@|from|to)\s*([.,;?!]|$)""", RegexOption.IGNORE_CASE), "$1")
        cleaned = cleaned.replace(Regex("""\s+([.,;?!])"""), "$1")
        cleaned = cleaned.replace(Regex("""^[,\-–—:;?\s]+|[,\-–—:;?\s]+$"""), "").trim()
        cleaned = cleaned.replace(Regex("""\s+"""), " ")

        if (cleaned.length < 3) {
            cleaned = firstLine
        }
        if (cleaned.isBlank()) {
            cleaned = "TaskIt Task"
        }

        return if (cleaned.length > 60) {
            cleaned.take(57).trimEnd() + "..."
        } else {
            cleaned
        }
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
