package me.bhaad.taskit

import org.junit.Assert.*
import org.junit.Test
import java.util.Calendar

class CalendarHelperTest {

    @Test
    fun `does not treat standalone lone numbers as time`() {
        val (title1, start1, _) = CalendarHelper.parseTextForEventDetails("Meet in room 4")
        assertNull("Lone number without preposition or am/pm should not match time", start1)

        val (title2, start2, _) = CalendarHelper.parseTextForEventDetails("Buy 2 groceries")
        assertNull("Lone number should not match time", start2)
    }

    @Test
    fun `parses explicit prepositioned time and am pm time`() {
        val (_, start1, _) = CalendarHelper.parseTextForEventDetails("Meet at 4")
        assertNotNull("Prepositioned time 'at 4' should match", start1)
        val cal1 = Calendar.getInstance().apply { timeInMillis = start1!! }
        assertEquals(4, cal1.get(Calendar.HOUR_OF_DAY))

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Call client at 4pm")
        assertNotNull("'at 4pm' should match", start2)
        val cal2 = Calendar.getInstance().apply { timeInMillis = start2!! }
        assertEquals(16, cal2.get(Calendar.HOUR_OF_DAY))

        val (_, start3, _) = CalendarHelper.parseTextForEventDetails("Sync at 14:30")
        assertNotNull("24h time should match", start3)
        val cal3 = Calendar.getInstance().apply { timeInMillis = start3!! }
        assertEquals(14, cal3.get(Calendar.HOUR_OF_DAY))
        assertEquals(30, cal3.get(Calendar.MINUTE))
    }

    @Test
    fun `parses time ranges correctly`() {
        val (_, start, end) = CalendarHelper.parseTextForEventDetails("Design review 2 to 4 pm")
        assertNotNull(start)
        assertNotNull(end)

        val startCal = Calendar.getInstance().apply { timeInMillis = start!! }
        val endCal = Calendar.getInstance().apply { timeInMillis = end!! }

        assertEquals(14, startCal.get(Calendar.HOUR_OF_DAY))
        assertEquals(0, startCal.get(Calendar.MINUTE))
        assertEquals(16, endCal.get(Calendar.HOUR_OF_DAY))
        assertEquals(0, endCal.get(Calendar.MINUTE))
    }

    @Test
    fun `parses relative offsets like in 2 hours and in 30 mins`() {
        val now = System.currentTimeMillis()
        val (_, start1, _) = CalendarHelper.parseTextForEventDetails("Call doctor in 30 mins")
        assertNotNull(start1)
        assertTrue("Start time should be in future (~30m)", start1!! > now + 25 * 60 * 1000L)

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Review code in 2 hours")
        assertNotNull(start2)
        assertTrue("Start time should be in future (~2h)", start2!! > now + 100 * 60 * 1000L)
    }

    @Test
    fun `parses multilingual relative dates`() {
        val (_, startEs, _) = CalendarHelper.parseTextForEventDetails("Reunión mañana a las 3pm")
        assertNotNull(startEs)

        val (_, startDe, _) = CalendarHelper.parseTextForEventDetails("Meeting morgen um 14:00")
        assertNotNull(startDe)

        val (_, startFr, _) = CalendarHelper.parseTextForEventDetails("Rendez-vous demain à 10:00")
        assertNotNull(startFr)

        val (_, startHi, _) = CalendarHelper.parseTextForEventDetails("कल शाम 6pm पर मीटिंग")
        assertNotNull(startHi)
    }

    @Test
    fun `extracts clean title stripping filler and date snippets`() {
        val (title, _, _) = CalendarHelper.parseTextForEventDetails("Hey, let's have lunch tomorrow at 1pm. Let me know if that works.")
        assertEquals("let's have lunch. Let me know if that works.", title)
    }
}
