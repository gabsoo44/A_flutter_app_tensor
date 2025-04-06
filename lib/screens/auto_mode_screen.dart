import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/auto_mode_service.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// AutoModeScreen displays temperature and humidity data 
/// automatically sent at regular intervals to the server.
/// The screen uses AutoModeService to simulate and transmit telemetry,
/// and shows real-time updates on a chart.
class AutoModeScreen extends StatefulWidget {
  /// The WebSocket client used to communicate with the server
  final ThingClient thingClient;

  const AutoModeScreen({super.key, required this.thingClient});

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

class _AutoModeScreenState extends State<AutoModeScreen> {
  // List to hold telemetry data points for the graph
  final List<TelemetryPoint> _points = [];

  // Current temperature unit displayed (°C or otherwise)
  String _unit = "°C";

  // Service handling automatic telemetry data generation and sending
  late AutoModeService _service;

  @override
  void initState() {
    super.initState();
    print("AutoModeScreen opened!");
    
    // Initialize the auto mode service with callbacks and client
    _service = AutoModeService(
      onNewPoint: _addPoint,
      onUnitChanged: _updateUnit,
      thingClient: widget.thingClient, 
    );

    // Start the automatic simulation
    _service.start();
  }

  /// Callback to add a new telemetry point to the chart
  void _addPoint(TelemetryPoint point) {
    setState(() {
      _points.add(point);

      // Keep the list size limited for performance
      if (_points.length > kMaxTelemetryPoints) {
        _points.removeAt(0);
      }
    });
  }

  /// Callback to update the temperature unit shown in UI
  void _updateUnit(String unit) {
    setState(() {
      _unit = unit;
    });
  }

  /// Toggle between active and sleep modes (changes send frequency)
  void _toggleMode(bool value) {
    setState(() {
      _service.toggleMode(value);
    });
  }

  @override
  void dispose() {
    // Properly dispose the service to clean up timers and streams
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
              // Display current update frequency based on mode
              Text('Data updates every ${_service.isActiveMode ? "10/20" : "20/50"} seconds (T/H).'),
              
              // Display current temperature unit
              Text('Temperature unit: $_unit'),
              const SizedBox(height: 10),

              // Mode toggle switch between active and sleep
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

              // Telemetry chart showing the data points
              Expanded(child: TelemetryChart(points: _points, unit: _unit)),
            ],
          ),
        ),
      );
}
