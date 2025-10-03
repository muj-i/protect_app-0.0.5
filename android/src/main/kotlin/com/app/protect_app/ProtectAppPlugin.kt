package com.app.protect_app

import android.app.Activity
import android.content.Context
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class ProtectAppPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context
  private var activity: Activity? = null
  private var screenCaptureDetector: ScreenCaptureDetector? = null
  
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "protect_app")
    channel.setMethodCallHandler(this)
    
    // Register event channel for screen capture detection
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "protect_app/screen_capture")
    screenCaptureDetector = ScreenCaptureDetector(context, activity)
    eventChannel.setStreamHandler(screenCaptureDetector)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "isDeviceUseVPN" -> result.success(CheckVpn(context).isVpnActive())
      "dataOfCurrentProxy" -> result.success(CheckProxy(context).getProxyData())
      "checkIsTheDeveloperModeOn" -> result.success(CheckTheDeveloperMode(context).isDeveloperModeEnabled())
      "isItRealDevice" -> result.success(CheckTheDeveloperMode(context).isItRealDevice())
      "isUseJailBrokenOrRoot" -> result.success(CheckTheDeveloperMode(context).isRooted())
      "turnOffScreenshots" -> {
        activity?.let { TurnOffScreenshots(it).turnOff() }
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    screenCaptureDetector?.dispose()
    screenCaptureDetector = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    screenCaptureDetector?.updateActivity(activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
    screenCaptureDetector?.updateActivity(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    screenCaptureDetector?.updateActivity(activity)
  }

  override fun onDetachedFromActivity() {
    activity = null
    screenCaptureDetector?.updateActivity(null)
  }
}
