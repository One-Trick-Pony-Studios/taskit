package me.bhaad.taskit

import android.content.Intent
import android.os.Bundle
import android.provider.CalendarContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private var sharedText: String? = null
    private val PROCESS_TEXT_CHANNEL = "app.channel.process.data"
    private val CALENDAR_CHANNEL = "app.channel.calendar"
    private val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
        if (sharedText != null) {
            Log.d(TAG, "Scheduling redirect for text: $sharedText")
            window.decorView.post {
                redirectToCalendar(sharedText) // Use safe call, handle null inside
                finish() // Close activity after redirect
            }
        } else {
            Log.d(TAG, "No shared text to process, finishing activity")
            finish()
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PROCESS_TEXT_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getSharedText") {
                    Log.d(TAG, "getSharedText called, returning: $sharedText")
                    result.success(sharedText)
                    sharedText = null // Clear after sending to avoid reuse
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
                        redirectToCalendar(title, startTime, endTime)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun redirectToCalendar(
        title: String?,
        startTime: Long? = null,
        endTime: Long? = null
    ) {
        if (title == null) {
            Log.w(TAG, "Title is null, skipping redirect")
            return
        }
        val intent = Intent(Intent.ACTION_INSERT).apply {
            data = CalendarContract.Events.CONTENT_URI
            putExtra(CalendarContract.Events.TITLE, title.ifEmpty { "TaskIt Task" })
            putExtra(CalendarContract.Events.DESCRIPTION, "Created by TaskIt")
            putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startTime ?: System.currentTimeMillis())
            putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endTime ?: System.currentTimeMillis() + 3600000)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        try {
            startActivity(intent)
            Log.d(TAG, "Successfully launched calendar intent for title: $title")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to launch calendar intent: ${e.message}")
        }
    }
}