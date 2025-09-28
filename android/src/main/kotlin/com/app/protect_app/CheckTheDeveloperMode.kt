package com.app.protect_app

import android.content.Context
import android.os.Build
import android.provider.Settings
import java.io.File
import java.io.IOException

class CheckTheDeveloperMode(private val context: Context) {
     fun isDeveloperModeEnabled(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            Settings.Global.getInt(context.contentResolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
        } else {
            false
        }
    }
    fun isItRealDevice(): Boolean {
        val isRootedValue =  isRooted()
        if(isRootedValue){
            return  false
        }
        return !(Build.FINGERPRINT.startsWith("generic") ||
                Build.FINGERPRINT.lowercase().contains("vbox") ||
                Build.MODEL.contains("Emulator") ||
                Build.MODEL.contains("Android SDK built for x86") ||
                Build.MANUFACTURER.contains("Genymotion") ||
                Build.HARDWARE == "goldfish" ||
                Build.HARDWARE == "ranchu" ||
                Build.PRODUCT.contains("sdk") ||
                Build.PRODUCT.contains("google_sdk") ||
                Build.PRODUCT.contains("sdk_x86") ||
                Build.PRODUCT.contains("sdk_gphone64_x86_64") ||
                Build.BOARD.lowercase().contains("nox") || // NOX emulator
                Build.BRAND.startsWith("generic") &&
                Build.DEVICE.startsWith("generic"))
    }
    fun isRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su"
        )

        for (path in paths) {
            if (File(path).exists()) {
                return true
            }
        }

        try {
            val process = Runtime.getRuntime().exec("su")
            process.destroy()
            return true
        } catch (e: IOException) { }

        return false
    }
}