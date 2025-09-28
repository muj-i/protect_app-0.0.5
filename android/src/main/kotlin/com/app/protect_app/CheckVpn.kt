package com.app.protect_app

import android.content.Context
import android.content.Context.CONNECTIVITY_SERVICE
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import java.net.NetworkInterface

class CheckVpn(private val context: Context) {
    fun isVpnActive(): Boolean {
        val connectivityManager = context.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val activeNetwork = connectivityManager.activeNetwork ?: return false
            val networkCapabilities = connectivityManager.getNetworkCapabilities(activeNetwork) ?: return false
            networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
        } else {
            try {
                val networkInterfaces = NetworkInterface.getNetworkInterfaces()
                for (networkInterface in networkInterfaces) {
                    if (networkInterface.isUp && networkInterface.name.equals("tun0", ignoreCase = true)) {
                        return true
                    }
                }
                false
            } catch (e: Exception) {
                false
            }
        }
    }

}