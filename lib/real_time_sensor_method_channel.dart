import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:real_time_sensor/sensor_delay.dart';
import 'package:real_time_sensor/sensor_type.dart';

import 'real_time_sensor_platform_interface.dart';

/// An implementation of [RealTimeSensorPlatform] that uses method channels.
class MethodChannelRealTimeSensor extends RealTimeSensorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('real_time_sensor');

  final EventChannel _eventChannel =
      const EventChannel('high_frequency_sensor_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<Map<String, dynamic>> sensorStream({
    int sensorDelay = SensorDelay.SENSOR_DELAY_NORMAL,
    int sensorType = SensorType.ACCELEROMETER,
  }) {
    return _eventChannel.receiveBroadcastStream(sensorDelay).map((event) {
      return Map<String, dynamic>.from(event);
    });
  }
}
