package me.bhaad.taskit

import android.content.Intent
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.LargeTest
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.uiautomator.By
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.Until
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
@LargeTest
class MainActivityTest {

    private lateinit var device: UiDevice

    @Before
    fun setup() {
        device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation())
    }

    @Test
    fun testShareFlow() {
        val context = ApplicationProvider.getApplicationContext<android.content.Context>()
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_SEND
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, "Test Share Task")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)

        device.wait(Until.hasObject(By.pkg("com.google.android.calendar").depth(0)), 5000)
        device.pressBack()
        device.wait(Until.hasObject(By.pkg("me.bhaad.taskit").depth(0)), 5000)
    }

    @Test
    fun testCreateTaskFlow() {
        val context = ApplicationProvider.getApplicationContext<android.content.Context>()
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_PROCESS_TEXT
            type = "text/plain"
            putExtra(Intent.EXTRA_PROCESS_TEXT, "Test Create Task")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)

        device.wait(Until.hasObject(By.pkg("com.google.android.calendar").depth(0)), 5000)
        device.pressBack()
        device.wait(Until.hasObject(By.pkg("me.bhaad.taskit").depth(0)), 5000)
    }

    @Test
    fun testReturnToOriginalApp() {
        val context = ApplicationProvider.getApplicationContext<android.content.Context>()
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_SEND
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, "Return Test")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        context.startActivity(intent)

        device.wait(Until.hasObject(By.pkg("com.google.android.calendar").depth(0)), 5000)
        device.pressBack()
        device.wait(Until.hasObject(By.pkg("me.bhaad.taskit").depth(0)), 5000)
    }
}
