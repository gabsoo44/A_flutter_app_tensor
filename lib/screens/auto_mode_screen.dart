import 'dart:async';

import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/fake_server.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

/// UI screen representing the automatic mode of a sensor system.
/// It simulates periodic telemetry data (temperature & humidity) using a simulator,
/// and fetches remote configuration attributes (like temperature unit) from a fake server.
/// It includes a toggle to switch between Active and Sleep modes, adjusting data generation intervals accordingly.
class AutoModeScreen extends StatefulWidget {
  const AutoModeScreen({super.key});

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

/// State class for AutoModeScreen.
/// Manages telemetry simulation, server polling, and rendering of the sensor's automatic behavior.
class _AutoModeScreenState extends State<AutoModeScreen> {
  /// Stores the latest telemetry data points (temperature & humidity) for graph display.
  final List<TelemetryPoint> _points = [];

  /// Simulates telemetry data generation at configured intervals.
  late TelemetrySimulator _simulator;

  /// Fake server instance to retrieve dynamic attributes like temperature unit.
  final FakeServer _server = FakeServer();

  /// Represents whether the system is in Active mode (true) or Sleep mode (false).
  bool isActiveMode = true;

  /// Caches the most recent valid temperature value received from simulator.
  double? _lastTemp;

  /// Caches the most recent valid humidity value received from simulator.
  double? _lastHum;

  /// Current temperature unit displayed (e.g., "°C", "°F").
  String _unit = "°C";

  /// Periodic timer to poll the fake server for attribute updates.
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    /// Begins telemetry simulation with appropriate intervals.
    _startSimulator();

    /// Starts periodic polling for temperature unit from server.
    _startPollingServerAttributes();
  }

  /// Initializes and starts the telemetry simulator with intervals based on mode.
  /// Adjusts temperature and humidity emission frequency accordingly.
  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? const Duration(seconds: 10) : const Duration(seconds: 20),
      humInterval: isActiveMode ? const Duration(seconds: 20) : const Duration(seconds: 50),
    );
    _simulator.start();
  }

  /// Starts a periodic polling task to fetch temperature unit from the fake server.
  /// The polling frequency adapts based on whether the system is in active or sleep mode.
  void _startPollingServerAttributes() {
    // Ensure no existing timer is running
    _pollingTimer?.cancel();
    final interval = isActiveMode ? const Duration(seconds: 10) : const Duration(seconds: 20);
    _pollingTimer = Timer.periodic(interval, (_) async {
      final attributes = await _server.getAttributes();
      setState(() {
        _unit = attributes['temperatureUnit'] as String;
      });
    });
  }

  /// Callback triggered on each new simulated telemetry value.
  /// Maintains state and pushes complete data points to the history list.
  void _handleNewData(double temp, double hum) {
    setState(() {
      // Only update if valid values are received
      if (temp != -1) _lastTemp = temp;
      if (hum != -1) _lastHum = hum;

      // Ensure both temperature and humidity are available before creating a point
      if (_lastTemp != null && _lastHum != null) {
        _points.add(TelemetryPoint(
          timestamp: DateTime.now(),
          temperature: _lastTemp!,
          humidity: _lastHum!,
        ));

        // Keep a rolling window of the last 20 telemetry points for performance
        if (_points.length > 20) {
          _points.removeAt(0);
        }
      }
    });
  }

  /// Toggles between Active and Sleep modes.
  /// Stops the current simulator and polling cycle, and restarts them with new settings.
  void _toggleMode(bool value) {
    setState(() {
      isActiveMode = value;
      _simulator.stop();
      _pollingTimer?.cancel();
      _startSimulator();
      _startPollingServerAttributes();
    });
  }

  @override
  void dispose() {
    /// Clean up simulator on screen disposal
    _simulator.stop();

    /// Stop polling to avoid memory leaks
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode Automatique')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Display data refresh rate based on mode
              Text(
                  'Données mises à jour toutes les ${isActiveMode ? "10/20" : "20/50"} secondes (T/H).'),
              Text('Unité température : $_unit'),

              const SizedBox(height: 10),

              /// Mode toggle switch between Active and Sleep modes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Mode Actif'),
                  Switch(
                    value: isActiveMode,
                    onChanged: _toggleMode,
                  ),
                  const Text('Mode Veille'),
                ],
              ),

              const SizedBox(height: 20),

              /// Graph displaying telemetry points over time
              Expanded(
                child: TelemetryChart(
                  points: _points,
                  unit: _unit,
                ),
              ),
            ],
          ),
        ),
      );
}
