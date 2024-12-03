import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:real_time_sensor/real_time_sensor.dart';
import 'package:real_time_sensor/sensor_delay.dart';
import 'package:real_time_sensor/sensor_type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final ValueNotifier<String> _sensorData = ValueNotifier('No Data');
  final _realTimeSensorPlugin = RealTimeSensor();
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    streamSensor();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await _realTimeSensorPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> streamSensor() async {
    _subscription = _realTimeSensorPlugin
        .sensorStream(
            sensorDelay: SensorDelay.SENSOR_DELAY_NORMAL,
            sensorType: SensorType.TYPE_AMBIENT_TEMPERATURE)
        .listen((data) {
      _sensorData.value =
          'X: ${data['x']} \n Y: ${data['y']} \n Z: ${data['z']} \n timestamp: ${data['timestamp']} ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              const SizedBox(height: 30),
              const Text("Sensor Data"),
              ListenableBuilder(
                listenable: _sensorData,
                builder: (_, __) => Text(_sensorData.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
