package com.app.protect_app

import android.app.Activity
import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import io.flutter.plugin.common.EventChannel

/**
 * Detects screenshots by monitoring MediaStore for new images
 * Similar to iOS's UIScreen.capturedDidChangeNotification approach
 */
class ScreenCaptureDetector(
    private val context: Context,
    private var activity: Activity?
) : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var contentObserver: ContentObserver? = null
    private val handler = Handler(Looper.getMainLooper())
    private var lastEventTime = 0L
    
    companion object {
        private const val TAG = "ScreenCaptureDetector"
        private const val DEBOUNCE_MS = 500L
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "📸 Setting up screenshot detection")
        eventSink = events
        startMonitoring()
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "📸 Stopping screenshot detection")
        stopMonitoring()
        eventSink = null
    }

    private fun startMonitoring() {
        contentObserver = object : ContentObserver(handler) {
            override fun onChange(selfChange: Boolean, uri: Uri?) {
                super.onChange(selfChange, uri)
                
                val currentTime = System.currentTimeMillis()
                if (currentTime - lastEventTime < DEBOUNCE_MS) return
                
                lastEventTime = currentTime
                
                Log.d(TAG, "📸 Media change detected: $uri")
                
                uri?.let {
                    if (isScreenshotUri(it)) {
                        sendEvent("screenshot")
                    }
                }
            }
        }
        
        context.contentResolver.registerContentObserver(
            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
            true,
            contentObserver!!
        )
        
        Log.d(TAG, "✅ ContentObserver registered")
    }

    private fun stopMonitoring() {
        contentObserver?.let {
            context.contentResolver.unregisterContentObserver(it)
            Log.d(TAG, "✅ ContentObserver unregistered")
        }
        contentObserver = null
    }

    private fun isScreenshotUri(uri: Uri): Boolean {
        val path = uri.toString().lowercase()
        return path.contains("screenshot") || 
               path.contains("screen_shot") ||
               path.contains("screencap")
    }

    private fun sendEvent(event: String) {
        handler.post {
            try {
                eventSink?.success(event)
                Log.d(TAG, "✅ Event sent: $event")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error sending event", e)
            }
        }
    }

    fun updateActivity(activity: Activity?) {
        this.activity = activity
    }

    fun dispose() {
        stopMonitoring()
        activity = null
    }
}

