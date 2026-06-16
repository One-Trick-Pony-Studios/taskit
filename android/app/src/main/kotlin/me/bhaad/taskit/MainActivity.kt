package me.bhaad.taskit

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.StatusBarManager
import android.content.ComponentName
import android.graphics.drawable.Icon
import android.os.Build
import android.widget.Toast
import android.content.Context

class MainActivity : FlutterFragmentActivity() {
    private var calendarPermissionRequested = false
    private var sharedText: String? = null
    private val PROCESS_TEXT_CHANNEL = "app.channel.process.data"
    private val CALENDAR_CHANNEL = "app.channel.calendar"
    private val TAG = "MainActivity"

    private var pendingCalendarTitle: String? = null
    private var pendingStartTime: Long? = null
    private var pendingEndTime: Long? = null
    private var pendingFullText: String? = null

    private lateinit var calendarPermissionLauncher: ActivityResultLauncher<String>
    private var permissionResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        calendarPermissionLauncher = registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted ->
            if (isGranted) {
                Log.d(TAG, "Calendar permission granted via launcher")
                if (pendingCalendarTitle != null) {
                    redirectToCalendar(pendingCalendarTitle, pendingStartTime, pendingEndTime, pendingFullText)
                }
                permissionResult?.success(true)
            } else {
                Log.w(TAG, "Calendar permission denied via launcher")
                permissionResult?.success(false)
                if (pendingCalendarTitle != null) {
                    finish()
                }
            }
            permissionResult = null
            calendarPermissionRequested = false
        }

        WindowCompat.setDecorFitsSystemWindows(window, false)

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
            val (title, startTime, endTime) = CalendarHelper.parseTextForEventDetails(sharedText)
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
                    if (sharedText != null) {
                        val (title, startTime, endTime) = CalendarHelper.parseTextForEventDetails(sharedText)
                        val map = mapOf(
                            "text" to sharedText,
                            "title" to title,
                            "startTime" to startTime,
                            "endTime" to endTime
                        )
                        result.success(map)
                    } else {
                        result.success(null)
                    }
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
                    "requestAddTile" -> {
                        requestAddTileService()
                        result.success(true)
                    }
                    "checkAndRequestPermission" -> {
                        val granted = checkAndRequestCalendarPermission(result)
                        if (granted) {
                            result.success(true)
                        }
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
            if (!calendarPermissionRequested) {
                calendarPermissionRequested = true
                Log.w(TAG, "Calendar permission not granted, requesting...")
                pendingCalendarTitle = title
                pendingStartTime = startTime
                pendingEndTime = endTime
                pendingFullText = fullText
                calendarPermissionLauncher.launch(Manifest.permission.WRITE_CALENDAR)
            } else {
                Log.w(TAG, "Calendar permission request already in progress")
            }
            return
        }

        val success = CalendarHelper.dispatchCalendarIntent(this, title, startTime, endTime, fullText ?: pendingFullText ?: title)
        if (success) {
            pendingCalendarTitle = null
            pendingStartTime = null
            pendingEndTime = null
            pendingFullText = null
            finish()
        } else {
            Toast.makeText(this, "Failed to launch calendar application.", Toast.LENGTH_LONG).show()
            finish()
        }
    }

    private fun requestAddTileService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val statusBarManager = getSystemService(Context.STATUS_BAR_SERVICE) as StatusBarManager
            val componentName = ComponentName(this, TaskitTileService::class.java)
            statusBarManager.requestAddTileService(
                componentName,
                "TaskIt",
                Icon.createWithResource(this, R.mipmap.ic_launcher),
                mainExecutor
            ) { statusCode ->
                Log.d("TaskItTile", "Tile addition request status code: $statusCode")
            }
        }
    }

    private fun checkAndRequestCalendarPermission(result: MethodChannel.Result): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_CALENDAR)
            == PackageManager.PERMISSION_GRANTED) {
            return true
        }

        if (!calendarPermissionRequested) {
            calendarPermissionRequested = true
            permissionResult = result
            calendarPermissionLauncher.launch(Manifest.permission.WRITE_CALENDAR)
        } else {
            result.error("PERMISSION_REQUEST_IN_PROGRESS", "Calendar permission request already in progress", null)
        }
        return false
    }
}