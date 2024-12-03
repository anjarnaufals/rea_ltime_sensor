import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'real_time_sensor_method_channel.dart';
import 'sensor_delay.dart';
import 'sensor_type.dart';

abstract class RealTimeSensorPlatform extends PlatformInterface {
  /// Constructs a RealTimeSensorPlatform.
  RealTimeSensorPlatform() : super(token: _token);

  static final Object _token = Object();

  static RealTimeSensorPlatform _instance = MethodChannelRealTimeSensor();

  /// The default instance of [RealTimeSensorPlatform] to use.
  ///
  /// Defaults to [MethodChannelRealTimeSensor].
  static RealTimeSensorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RealTimeSensorPlatform] when
  /// they register themselves.
  static set instance(RealTimeSensorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Stream<Map<String, dynamic>> sensorStream({
    int sensorDelay = SensorDelay.SENSOR_DELAY_NORMAL,
    int sensorType = SensorType.ACCELEROMETER,
  });
}
