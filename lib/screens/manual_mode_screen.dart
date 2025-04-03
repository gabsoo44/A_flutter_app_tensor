import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/manual_mode_service.dart';
import 'package:a_flutter_app_tensor/widgets/data_input_form.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// Manual mode screen allowing the user to enter temperature and humidity data.
/// Uses ManualModeService to handle the logic and state updates.
class ManualModeScreen extends StatefulWidget {
  const ManualModeScreen({super.key});

  @override
  State<ManualModeScreen> createState() => _ManualModeScreenState();
}

class _ManualModeScreenState extends State<ManualModeScreen> {
  List<TelemetryPoint> _points = [];
  late ManualModeService _service;

  @override
  void initState() {
    super.initState();
    _service = ManualModeService(onUpdate: (points) {
      setState(() {
        _points = points;
      });
    });
  }

  /// Handles form submission and adds a new data point via the service
  void _addPoint(double temperature, double humidity) {
    _service.addPoint(temperature, humidity);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Manual Mode')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Form for temperature and humidity input
              DataInputForm(onSubmit: _addPoint),
              const SizedBox(height: 20),
              // Telemetry chart displaying all submitted data points
              Expanded(child: TelemetryChart(points: _points)),
            ],
          ),
        ),
      );
}
