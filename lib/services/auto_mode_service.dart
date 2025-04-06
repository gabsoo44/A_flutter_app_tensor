import 'dart:async';
import 'dart:convert';

import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';

/// Service to simulate automatic telemetry data generation and transmission.
///
/// It periodically generates temperature and humidity data and sends it
/// to the WebSocket server using the [ThingClient]. The interval depends
/// on whether the system is in Active or Sleep mode.
class AutoModeService {
  /// Callback triggered when a new TelemetryPoint is generated.
  final void Function(TelemetryPoint) onNewPoint;

  /// Callback triggered when the temperature unit (e.g. °C) is fetched from the server.
  final void Function(String) onUnitChanged;

  /// Internal simulator to generate temperature and humidity data.
  late TelemetrySimulator _simulator;

  /// Client responsible for sending data to the WebSocket server.
  final ThingClient _thingClient;

  /// True if the current mode is Active; false if in Sleep mode.
  bool isActiveMode = true;

  /// Last generated temperature value (cached until paired with humidity).
  double? _lastTemp;

  /// Last generated humidity value (cached until paired with temperature).
  double? _lastHum;

  /// Timer used to periodically poll the server for configuration updates.
  Timer? _pollingTimer;

  /// Constructor that takes callback functions and a ThingClient instance.
  AutoModeService({
    required this.onNewPoint,
    required this.onUnitChanged,
    required ThingClient thingClient,
  }) : _thingClient = thingClient;

  /// Starts the simulator and polling mechanisms.
  void start() {
    _startSimulator();
    _startPollingServer();
  }

  /// Initializes and starts the telemetry simulator with appropriate intervals.
  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? kTempIntervalActive : kTempIntervalSleep,
      humInterval: isActiveMode ? kHumIntervalActive : kHumIntervalSleep,
    );
    _simulator.start();
  }

  /// Starts polling the server for attribute updates like temperature unit.
  /// Currently simulated by calling [onUnitChanged] with a hardcoded value.
  void _startPollingServer() {
    _pollingTimer?.cancel(); // Clear previous timer
    final interval = isActiveMode ? kPollingIntervalActive : kPollingIntervalSleep;

    _pollingTimer = Timer.periodic(interval, (_) {
      // Simulated server attribute fetch – replace with real API call
      onUnitChanged('Celsius');
    });
  }

  /// Callback triggered by the simulator when new temperature or humidity is generated.
  void _handleNewData(double temp, double hum) {
    if (temp != -1) _lastTemp = temp;
    if (hum != -1) _lastHum = hum;

    // Only send when both temperature and humidity are available
    if (_lastTemp != null && _lastHum != null) {
      final point = TelemetryPoint(
        timestamp: DateTime.now(),
        temperature: _lastTemp!,
        humidity: _lastHum!,
      );

      onNewPoint(point);
      _sendTelemetryData(point);
    }
  }

  /// Encodes a TelemetryPoint into JSON and sends it to the server via WebSocket.
  void _sendTelemetryData(TelemetryPoint point) {
    final dataMessage = jsonEncode({
      "thingId": _thingClient.thingId,
      "temperature": point.temperature,
      "humidity": point.humidity,
      "timestamp": point.timestamp.toIso8601String(),
    });

    _thingClient.sendMessage(dataMessage);
    print("Données envoyées via WebSocket : $dataMessage");
  }

  /// Toggles between Active and Sleep mode.
  /// This restarts the simulator and polling with new intervals.
  void toggleMode(bool active) {
    isActiveMode = active;
    _simulator.stop();
    _pollingTimer?.cancel();
    start(); // Restart services with new settings
  }

  /// Stops the simulator and polling timer. To be called on disposal.
  void dispose() {
    _simulator.stop();
    _pollingTimer?.cancel();
  }
}
