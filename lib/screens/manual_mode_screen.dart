import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/manual_mode_service.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:a_flutter_app_tensor/widgets/data_input_form.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// ManualModeScreen provides a user interface for entering temperature
/// and humidity values manually. These values are plotted and sent
/// through the ManualModeService.
class ManualModeScreen extends StatefulWidget {
  /// Reference to the WebSocket client used across the app
  final ThingClient thingClient;

  const ManualModeScreen({super.key, required this.thingClient});

  @override
  State<ManualModeScreen> createState() => _ManualModeScreenState();
}

class _ManualModeScreenState extends State<ManualModeScreen> {
  /// List of all telemetry points entered manually
  List<TelemetryPoint> _points = [];

  /// Service to handle the logic of storing and updating telemetry points
  late ManualModeService _service;

  @override
  void initState() {
    super.initState();

    // Initialize service and register update callback
    _service = ManualModeService(onUpdate: (points) {
      setState(() {
        _points = points; // Update local state when service updates data
      });
    });
  }

  /// Handles user submission by delegating to the service
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

              // Chart displaying submitted telemetry data points
              Expanded(child: TelemetryChart(points: _points)),
            ],
          ),
        ),
      );
}
