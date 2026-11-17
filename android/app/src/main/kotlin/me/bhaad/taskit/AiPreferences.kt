package me.bhaad.taskit

import android.content.Context
import android.content.SharedPreferences

object AiPreferences {
    private const val PREFS_NAME = "taskit_ai_prefs"
    private const val KEY_AI_ENABLED = "is_ai_parsing_enabled"
    private const val KEY_DEVICE_CAPABLE = "is_device_ai_capable"

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    fun isAiParsingEnabled(context: Context): Boolean {
        return getPrefs(context).getBoolean(KEY_AI_ENABLED, false)
    }

    fun setAiParsingEnabled(context: Context, enabled: Boolean) {
        getPrefs(context).edit().putBoolean(KEY_AI_ENABLED, enabled).apply()
    }

    fun isDeviceAiCapable(context: Context): Boolean {
        return getPrefs(context).getBoolean(KEY_DEVICE_CAPABLE, false)
    }

    fun setDeviceAiCapable(context: Context, capable: Boolean) {
        getPrefs(context).edit().putBoolean(KEY_DEVICE_CAPABLE, capable).apply()
    }
}
