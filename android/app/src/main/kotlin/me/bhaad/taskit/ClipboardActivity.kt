package me.bhaad.taskit

import android.Manifest
import android.app.Activity
import android.content.ClipboardManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.core.content.ContextCompat

class ClipboardActivity : Activity() {
    private var hasProcessed = false

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
                val (title, startTime, endTime) = CalendarHelper.parseTextForEventDetails(copiedText)
                val success = CalendarHelper.dispatchCalendarIntent(this, title, startTime, endTime, copiedText)
                if (!success) {
                    Toast.makeText(this, "Failed to launch calendar application.", Toast.LENGTH_LONG).show()
                }
            } else {
                Toast.makeText(this, "Clipboard is empty.", Toast.LENGTH_SHORT).show()
            }
        } else {
            Toast.makeText(this, "No text found in clipboard.", Toast.LENGTH_SHORT).show()
        }

        finish()
    }
}

