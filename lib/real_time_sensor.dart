import 'real_time_sensor_platform_interface.dart';
import 'sensor_delay.dart';
import 'sensor_type.dart';

class RealTimeSensor {
  Future<String?> getPlatformVersion() {
    return RealTimeSensorPlatform.instance.getPlatformVersion();
  }

  /// ============= [sensorDelay] =============
  ///
  /// /**  get sensor data as fast as possible  */
  ///
  /// SENSOR_DELAY_FASTEST = 0;
  ///
  /// /** rate suitable for games */
  ///
  /// SENSOR_DELAY_GAME = 1;
  ///
  /// /** rate suitable for the user interface  */
  ///
  /// SENSOR_DELAY_UI = 2;
  ///
  /// /** rate (default) suitable for screen orientation changes */
  ///
  /// SENSOR_DELAY_NORMAL = 3;
  ///
  /// ============= [sensorType] =============
  ///
  ///1 -> Sensor.TYPE_GYROSCOPE
  ///
  /// 2 -> Sensor.TYPE_MAGNETIC_FIELD
  ///
  /// 4 -> Sensor.TYPE_GYROSCOPE
  ///
  /// 5 -> Sensor.TYPE_LIGHT
  ///
  /// 6 -> Sensor.TYPE_PRESSURE
  ///
  /// 8 -> Sensor.TYPE_PROXIMITY
  ///
  /// 9 -> Sensor.TYPE_GRAVITY
  ///
  /// 10 -> Sensor.TYPE_LINEAR_ACCELERATION
  ///
  /// 11 -> Sensor.TYPE_ROTATION_VECTOR
  ///
  /// 12 -> Sensor.TYPE_RELATIVE_HUMIDITY
  ///
  /// 13 -> Sensor.TYPE_AMBIENT_TEMPERATURE
  ///
  Stream<Map<String, dynamic>> sensorStream({
    int sensorDelay = SensorDelay.SENSOR_DELAY_NORMAL,
    int sensorType = SensorType.ACCELEROMETER,
  }) {
    return RealTimeSensorPlatform.instance.sensorStream(
      sensorDelay: sensorDelay,
      sensorType: sensorType,
    );
  }
}
