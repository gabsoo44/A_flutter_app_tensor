import 'dart:async';

import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/fake_server.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';

/// Handles the logic for auto mode operation: telemetry simulation and server polling.
class AutoModeService {
  /// Callback to return a new TelemetryPoint to the UI
  final void Function(TelemetryPoint) onNewPoint;

  /// Callback to update the unit shown in the UI
  final void Function(String) onUnitChanged;

  late TelemetrySimulator _simulator;
  final FakeServer _server = FakeServer();

  bool isActiveMode = true;
  double? _lastTemp;
  double? _lastHum;
  Timer? _pollingTimer;

  AutoModeService({
    required this.onNewPoint,
    required this.onUnitChanged,
  });

  /// Starts the simulator and server polling
  void start() {
    _startSimulator();
    _startPollingServer();
  }

  /// Initializes the telemetry simulator with correct intervals
  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? kTempIntervalActive : kTempIntervalSleep,
      humInterval: isActiveMode ? kHumIntervalActive : kHumIntervalSleep,
    );
    _simulator.start();
  }

  /// Polls the fake server to get current attributes (e.g. temperature unit)
  void _startPollingServer() {
    _pollingTimer?.cancel();
    final interval = isActiveMode ? kPollingIntervalActive : kPollingIntervalSleep;
    _pollingTimer = Timer.periodic(interval, (_) async {
      final attributes = await _server.getAttributes();
      onUnitChanged(attributes['temperatureUnit'] as String);
    });
  }

  /// Processes new data from the simulator and emits valid points
  void _handleNewData(double temp, double hum) {
    if (temp != -1) {
      _lastTemp = temp;
    }
    if (hum != -1) {
      _lastHum = hum;
    }

    if (_lastTemp != null && _lastHum != null) {
      final point = TelemetryPoint(
        timestamp: DateTime.now(),
        temperature: _lastTemp!,
        humidity: _lastHum!,
      );
      onNewPoint(point);
    }
  }

  /// Toggles between active and sleep modes and restarts the service
  // ignore: avoid_positional_boolean_parameters
  void toggleMode(bool active) {
    isActiveMode = active;
    _simulator.stop();
    _pollingTimer?.cancel();
    start();
  }

  /// Stops all background processes
  void dispose() {
    _simulator.stop();
    _pollingTimer?.cancel();
  }
}
