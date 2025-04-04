import 'dart:async';
import 'dart:convert';

import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/fake_server.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';  // Importation du client WebSocket
/// Handles the logic for auto mode operation: telemetry simulation and server polling.
class AutoModeService {
  final void Function(TelemetryPoint) onNewPoint;
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

  void start() {
    _startSimulator();
    _startPollingServer();
  }

  // Starts the telemetry simulator with correct intervals
  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? kTempIntervalActive : kTempIntervalSleep,
      humInterval: isActiveMode ? kHumIntervalActive : kHumIntervalSleep,
    );
    _simulator.start();
  }

  // Polls the fake server to get current attributes (e.g. temperature unit)
  void _startPollingServer() {
    _pollingTimer?.cancel();
    final interval = isActiveMode ? kPollingIntervalActive : kPollingIntervalSleep;
    _pollingTimer = Timer.periodic(interval, (_) async {
      final attributes = await _server.getAttributes();
      onUnitChanged(attributes['temperatureUnit'] as String);
    });
  }

  // Processes new data from the simulator and emits valid points
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

      // Sending telemetry data via WebSocket
      _sendTelemetryData(point);
    }
  }

  // Send telemetry data through WebSocket (using ThingClient)
  void _sendTelemetryData(TelemetryPoint point) {
    final dataMessage = jsonEncode({
      "thingId": ThingClient().thingId, // using the ThingClient to get the thingId
      "temperature": point.temperature,
      "humidity": point.humidity,
      "timestamp": point.timestamp.toIso8601String(),
    });

    ThingClient().channel?.sink.add(dataMessage); // Send data via WebSocket
    print("📤 Données envoyées via WebSocket : $dataMessage");
  }

  // Toggles between active and sleep modes and restarts the service
  void toggleMode(bool active) {
    isActiveMode = active;
    _simulator.stop();
    _pollingTimer?.cancel();
    start();
  }

  // Stops all background processes
  void dispose() {
    _simulator.stop();
    _pollingTimer?.cancel();
  }
}