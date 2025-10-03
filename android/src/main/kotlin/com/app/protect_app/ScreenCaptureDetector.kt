package com.app.protect_app

import android.app.Activity
import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import io.flutter.plugin.common.EventChannel

/**
 * Detects screenshot and screen recording attempts on Android
 */
class ScreenCaptureDetector(
    private val context: Context,
    private var activity: Activity?
) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var screenshotObserver: ContentObserver? = null
    private var isMonitoring = false

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        startMonitoring()
    }

    override fun onCancel(arguments: Any?) {
        stopMonitoring()
        eventSink = null
    }

    /**
     * Start monitoring for screenshot events
     */
    private fun startMonitoring() {
        if (isMonitoring) return
        isMonitoring = true

        // Monitor screenshot detection
        screenshotObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                uri?.let {
                    if (it.toString().contains(MediaStore.Images.Media.EXTERNAL_CONTENT_URI.toString())) {
                        // Check if the recent image is a screenshot
                        if (isScreenshot(it)) {
                            eventSink?.success("screenshot")
                        }
                    }
                }
            }
        }

        // Register observer for external images
        context.contentResolver.registerContentObserver(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            true,
            screenshotObserver!!
        )
    }

    /**
     * Stop monitoring for screenshot events
     */
    private fun stopMonitoring() {
        if (!isMonitoring) return
        isMonitoring = false

        screenshotObserver?.let {
            context.contentResolver.unregisterContentObserver(it)
        }
        screenshotObserver = null
    }

    /**
     * Check if the captured image is a screenshot
     */
    private fun isScreenshot(uri: Uri): Boolean {
        try {
            val projection = arrayOf(
                MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.DATA,
                MediaStore.Images.Media.DATE_ADDED
            )

            context.contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val displayNameIndex = cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)
                    val dataIndex = cursor.getColumnIndex(MediaStore.Images.Media.DATA)
                    val dateAddedIndex = cursor.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)

                    if (displayNameIndex >= 0 && dataIndex >= 0 && dateAddedIndex >= 0) {
                        val displayName = cursor.getString(displayNameIndex)?.toLowerCase() ?: ""
                        val data = cursor.getString(dataIndex)?.toLowerCase() ?: ""
                        val dateAdded = cursor.getLong(dateAddedIndex)

                        // Check if the image was added recently (within last 2 seconds)
                        val currentTime = System.currentTimeMillis() / 1000
                        if (currentTime - dateAdded > 2) {
                            return false
                        }

                        // Check if the path or filename contains screenshot-related keywords
                        val screenshotKeywords = listOf(
                            "screenshot",
                            "screen_shot",
                            "screen-shot",
                            "screencap",
                            "screen_capture",
                            "screen-capture",
                            "/screenshots/",
                            "/screencapture/"
                        )

                        return screenshotKeywords.any { keyword ->
                            displayName.contains(keyword) || data.contains(keyword)
                        }
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return false
    }

    /**
     * Update activity reference
     */
    fun updateActivity(activity: Activity?) {
        this.activity = activity
    }

    /**
     * Clean up resources
     */
    fun dispose() {
        stopMonitoring()
        activity = null
    }
}
