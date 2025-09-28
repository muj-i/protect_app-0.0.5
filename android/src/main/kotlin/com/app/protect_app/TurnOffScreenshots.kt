package com.app.protect_app
import android.view.WindowManager
import android.app.Activity

class TurnOffScreenshots(private val activity: Activity) {
    fun turnOff() {
        activity.window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
    }
}
