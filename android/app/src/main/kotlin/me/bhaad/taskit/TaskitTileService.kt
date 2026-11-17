package me.bhaad.taskit

import android.app.PendingIntent
import android.content.Intent
import android.service.quicksettings.TileService
import android.os.Build
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class TaskitTileService : TileService() {
    private val serviceScope = CoroutineScope(Dispatchers.IO)

    override fun onStartListening() {
        super.onStartListening()
        val tile = qsTile ?: return
        tile.label = "TaskIt"
        tile.state = android.service.quicksettings.Tile.STATE_ACTIVE
        tile.updateTile()

        // Pre-warm Gemini Nano if user enabled AI and hardware supports it
        if (AiPreferences.isAiParsingEnabled(this) && AiPreferences.isDeviceAiCapable(this)) {
            serviceScope.launch {
                GeminiNanoManager.warmup(this@TaskitTileService)
            }
        }
    }

    override fun onClick() {
        super.onClick()
        val intent = Intent(this, ClipboardActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            startActivityAndCollapse(pendingIntent)
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }
}

