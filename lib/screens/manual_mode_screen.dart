// Import of the telemetry data model, input form widget, and telemetry chart widget
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/widgets/data_input_form.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// Screen allowing users to manually input telemetry data (temperature and humidity).
/// Used in manual mode to simulate sensor readings via user interaction.
class ManualModeScreen extends StatefulWidget {
  const ManualModeScreen({super.key});

  @override
  State<ManualModeScreen> createState() => _ManualModeScreenState();
}

/// State class for ManualModeScreen.
/// Manages manual telemetry point entry and chart updates.
class _ManualModeScreenState extends State<ManualModeScreen> {
  // List of telemetry points entered manually by the user
  final List<TelemetryPoint> _points = [];

  /// Called when the user submits the form with temperature and humidity values.
  /// Adds a new telemetry point with the current timestamp and maintains a limited history.
  void _addPoint(double temperature, double humidity) {
    setState(() {
      _points.add(TelemetryPoint(
        // Use the current time as timestamp for manual entry
        timestamp: DateTime.now(),
        temperature: temperature,
        humidity: humidity,
      ));

      // Keep a maximum of 20 points to avoid overloading the chart
      if (_points.length > 20) {
        _points.removeAt(0);
      }
    });
  }

  @override

  /// Builds the UI for the manual mode screen: includes input form and data chart.
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode Manuel')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Widget that provides input fields for temperature and humidity
              DataInputForm(onSubmit: _addPoint),

              const SizedBox(height: 20),

              // Chart widget that visualizes the manually entered telemetry data
              Expanded(child: TelemetryChart(points: _points)),
            ],
          ),
        ),
      );
}
