package com.example.real_time_sensor

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** RealTimeSensorPlugin */
class RealTimeSensorPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

  private val TAG: String = "RealTimeSensorPlugin"
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel

  private lateinit var context: Context
  private lateinit var sensorManager: SensorManager
  private var sensor: Sensor? = null
  private var listener: SensorEventListener? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "real_time_sensor")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(binding.binaryMessenger, "high_frequency_sensor_plugin")
    eventChannel.setStreamHandler(this)
    Log.d(TAG, "Attached To Engine")
    Log.d(TAG, "Event Channel Stream has been set")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    var sensorDelay = SensorManager.SENSOR_DELAY_FASTEST
    var sensorType = Sensor.TYPE_GYROSCOPE

    if (arguments is Map<*, *>) {
      // Set the delay based on the passed argument
      sensorDelay = when (arguments["sensorDelay"]) {
        1 -> SensorManager.SENSOR_DELAY_GAME
        2 -> SensorManager.SENSOR_DELAY_UI
        3 -> SensorManager.SENSOR_DELAY_NORMAL
        else -> SensorManager.SENSOR_DELAY_FASTEST
      }

      sensorType = when (arguments["sensorType"]) {
        1 -> Sensor.TYPE_ACCELEROMETER
        2 -> Sensor.TYPE_MAGNETIC_FIELD
        4 -> Sensor.TYPE_GYROSCOPE
        5 -> Sensor.TYPE_LIGHT
        6 -> Sensor.TYPE_PRESSURE
        8 -> Sensor.TYPE_PROXIMITY
        9 -> Sensor.TYPE_GRAVITY
        10 -> Sensor.TYPE_LINEAR_ACCELERATION
        11 -> Sensor.TYPE_ROTATION_VECTOR
        12 -> Sensor.TYPE_RELATIVE_HUMIDITY
        13 -> Sensor.TYPE_AMBIENT_TEMPERATURE

        else -> Sensor.TYPE_GYROSCOPE
      }
    }

    sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    sensor = sensorManager.getDefaultSensor(sensorType)
    
    // TODO : implement get value base on type sensor
    // https://developer.android.com/reference/android/hardware/SensorEvent#values

    listener = object : SensorEventListener {
      override fun onSensorChanged(event: SensorEvent) {
        val data = mapOf(
          "x" to event.values[0],
          "y" to event.values[1],
          "z" to event.values[2],
          "timestamp" to event.timestamp
        )
        events?.success(data)
      }

      override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}


    }

    sensor?.let {
      sensorManager.registerListener(listener, it, sensorDelay)
    }
  }

  override fun onCancel(arguments: Any?) {
    listener?.let { sensorManager.unregisterListener(it) }
  }
}
