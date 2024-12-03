import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_time_sensor/real_time_sensor_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelRealTimeSensor platform = MethodChannelRealTimeSensor();
  const MethodChannel channel = MethodChannel('real_time_sensor');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
