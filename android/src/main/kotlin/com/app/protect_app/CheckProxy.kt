package com.app.protect_app

import android.content.Context

class CheckProxy(private val context: Context) {
    fun getProxyData(): Map<String, String?> {
        val proxyAddress = System.getProperty("http.proxyHost")
        val proxyPort = System.getProperty("http.proxyPort")
        val proxyType = System.getProperty("http.proxyType")
        return mapOf(
            "proxyHost" to proxyAddress,
            "proxyPort" to proxyPort,
            "proxyType" to proxyType
        )
    }
}