import 'package:flutter_test/flutter_test.dart';
import 'package:real_time_sensor/real_time_sensor.dart';
import 'package:real_time_sensor/real_time_sensor_platform_interface.dart';
import 'package:real_time_sensor/real_time_sensor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRealTimeSensorPlatform
    with MockPlatformInterfaceMixin
    implements RealTimeSensorPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<Map<String, dynamic>> sensorStream({
    int sensorDelay = 0,
    int sensorType = 1,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final RealTimeSensorPlatform initialPlatform =
      RealTimeSensorPlatform.instance;

  test('$MethodChannelRealTimeSensor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRealTimeSensor>());
  });

  test('getPlatformVersion', () async {
    RealTimeSensor realTimeSensorPlugin = RealTimeSensor();
    MockRealTimeSensorPlatform fakePlatform = MockRealTimeSensorPlatform();
    RealTimeSensorPlatform.instance = fakePlatform;

    expect(await realTimeSensorPlugin.getPlatformVersion(), '42');
  });
}
