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
    fun `parses spelled out time words`() {
        val (title1, start1, _) = CalendarHelper.parseTextForEventDetails("Let's meet at five for coffee")
        assertNotNull("Spelled-out 'at five' should match", start1)
        assertEquals("Let's meet for coffee", title1)

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Call client at seven pm")
        assertNotNull("Spelled-out 'at seven pm' should match", start2)
        val cal2 = Calendar.getInstance().apply { timeInMillis = start2!! }
        assertEquals(19, cal2.get(Calendar.HOUR_OF_DAY))

        val (title3, start3, _) = CalendarHelper.parseTextForEventDetails("Coffee at 5 o'clock")
        assertNotNull("'5 o'clock' should match", start3)
        assertEquals("Coffee", title3)
    }

    @Test
    fun `parses colloquial half past and quarter past to`() {
        val (title1, start1, _) = CalendarHelper.parseTextForEventDetails("Sync at half past four")
        assertNotNull("Half past four should match", start1)
        val cal1 = Calendar.getInstance().apply { timeInMillis = start1!! }
        assertEquals(30, cal1.get(Calendar.MINUTE))
        assertEquals("Sync", title1)

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Project check at quarter to six pm")
        assertNotNull("Quarter to six should match", start2)
        val cal2 = Calendar.getInstance().apply { timeInMillis = start2!! }
        assertEquals(17, cal2.get(Calendar.HOUR_OF_DAY))
        assertEquals(45, cal2.get(Calendar.MINUTE))
    }

    @Test
    fun `parses conversational offsets like a couple of hours and half an hour`() {
        val now = System.currentTimeMillis()
        val (title1, start1, _) = CalendarHelper.parseTextForEventDetails("Call mom in a couple of hours")
        assertNotNull(start1)
        assertTrue("Should be ~2 hours in future", start1!! > now + 100 * 60 * 1000L)
        assertEquals("Call mom", title1)

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Follow up in half an hour")
        assertNotNull(start2)
        assertTrue("Should be ~30 mins in future", start2!! > now + 25 * 60 * 1000L)
    }

    @Test
    fun `parses standalone ordinals like on the 25th`() {
        val (title, start, _) = CalendarHelper.parseTextForEventDetails("Dentist appointment on the 25th")
        assertNotNull("Should match ordinal 'on the 25th'", start)
        val cal = Calendar.getInstance().apply { timeInMillis = start!! }
        assertEquals(25, cal.get(Calendar.DAY_OF_MONTH))
        assertEquals("Dentist appointment", title)
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
    fun `parses relative offsets like in 2 hours and in 30 mins and after 2 hours`() {
        val now = System.currentTimeMillis()
        val (_, start1, _) = CalendarHelper.parseTextForEventDetails("Call doctor in 30 mins")
        assertNotNull(start1)
        assertTrue("Start time should be in future (~30m)", start1!! > now + 25 * 60 * 1000L)

        val (_, start2, _) = CalendarHelper.parseTextForEventDetails("Review code in 2 hours")
        assertNotNull(start2)
        assertTrue("Start time should be in future (~2h)", start2!! > now + 100 * 60 * 1000L)

        val (_, startAfter, _) = CalendarHelper.parseTextForEventDetails("Team sync after 2 hours")
        assertNotNull("Should parse 'after 2 hours'", startAfter)
        assertTrue("Start time should be in future (~2h)", startAfter!! > now + 100 * 60 * 1000L)
    }

    @Test
    fun `parses multilingual relative dates and spelled out numbers`() {
        val (_, startEs, _) = CalendarHelper.parseTextForEventDetails("Reunión mañana a las 3pm")
        assertNotNull(startEs)

        val (_, startDe, _) = CalendarHelper.parseTextForEventDetails("Meeting morgen um 14:00")
        assertNotNull(startDe)

        val (_, startFr, _) = CalendarHelper.parseTextForEventDetails("Rendez-vous demain à 10:00")
        assertNotNull(startFr)

        val (_, startHi, _) = CalendarHelper.parseTextForEventDetails("कल शाम 6pm पर मीटिंग")
        assertNotNull(startHi)

        val (_, startHiWords, _) = CalendarHelper.parseTextForEventDetails("कल पांच बजे मीटिंग")
        assertNotNull(startHiWords)
    }

    @Test
    fun `parses user message without title truncation or trailing at`() {
        val (title, start, end) = CalendarHelper.parseTextForEventDetails("User1 User2 Come for status meeting @4.15 pm today")
        assertEquals("User1 User2 Come for status meeting", title)
        assertNotNull("Start time should be matched", start)
        assertNotNull("End time should be matched", end)
    }

    @Test
    fun `parses multi-line user message without discarding lines`() {
        val message = "User1 User2\nCome for status meeting @4.15 pm today"
        val (title, start, _) = CalendarHelper.parseTextForEventDetails(message)
        assertEquals("User1 User2 Come for status meeting", title)
        assertNotNull(start)
    }

    @Test
    fun `extracts clean title stripping filler and date snippets`() {
        val (title, _, _) = CalendarHelper.parseTextForEventDetails("Hey, let's have lunch tomorrow at 1pm. Let me know if that works.")
        assertEquals("let's have lunch. Let me know if that works.", title)
    }
}
