// 📁 lib/screens/auto_mode_screen.dart

import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/auto_mode_service.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// AutoModeScreen simulates a sensor's automatic behavior.
/// It displays a real-time chart of telemetry data (temperature & humidity),
/// and allows switching between Active and Sleep modes, each with different update intervals.
class AutoModeScreen extends StatefulWidget {
  const AutoModeScreen({super.key});

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

class _AutoModeScreenState extends State<AutoModeScreen> {
  final List<TelemetryPoint> _points = [];
  String _unit = "°C";
  late AutoModeService _service;

  @override
  void initState() {
    super.initState();
    _service = AutoModeService(
      onNewPoint: _addPoint,
      onUnitChanged: _updateUnit,
    );
    _service.start();
  }

  /// Adds a new telemetry point to the chart
  void _addPoint(TelemetryPoint point) {
    setState(() {
      _points.add(point);
      if (_points.length > kMaxTelemetryPoints) {
        _points.removeAt(0);
      }
    });
  }

  /// Updates the temperature unit from the server
  void _updateUnit(String unit) {
    setState(() {
      _unit = unit;
    });
  }

  /// Toggles between active and sleep modes
  void _toggleMode(bool value) {
    setState(() {
      _service.toggleMode(value);
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Auto Mode')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Data updates every ${_service.isActiveMode ? "10/20" : "20/50"} seconds (T/H).'),
              Text('Temperature unit: $_unit'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Active Mode'),
                  Switch(
                    value: _service.isActiveMode,
                    onChanged: _toggleMode,
                  ),
                  const Text('Sleep Mode'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: TelemetryChart(points: _points, unit: _unit)),
            ],
          ),
        ),
      );
}
