import 'dart:async';
import 'dart:convert';

import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';

class AutoModeService {
  final void Function(TelemetryPoint) onNewPoint;
  final void Function(String) onUnitChanged;

  late TelemetrySimulator _simulator;
  final ThingClient _thingClient;

  bool isActiveMode = true;
  double? _lastTemp;
  double? _lastHum;
  Timer? _pollingTimer;

  AutoModeService({
    required this.onNewPoint,
    required this.onUnitChanged,
    required ThingClient thingClient,
  }) : _thingClient = thingClient;

  void start() {
    _startSimulator();
    _startPollingServer();
  }

  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? kTempIntervalActive : kTempIntervalSleep,
      humInterval: isActiveMode ? kHumIntervalActive : kHumIntervalSleep,
    );
    _simulator.start();
  }

  void _startPollingServer() {
    _pollingTimer?.cancel();
    final interval = isActiveMode ? kPollingIntervalActive : kPollingIntervalSleep;
    _pollingTimer = Timer.periodic(interval, (_) {
      // Simulation temporaire, à remplacer par appel serveur réel
      onUnitChanged('Celsius');
    });
  }

  void _handleNewData(double temp, double hum) {
    if (temp != -1) _lastTemp = temp;
    if (hum != -1) _lastHum = hum;

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

  void toggleMode(bool active) {
    isActiveMode = active;
    _simulator.stop();
    _pollingTimer?.cancel();
    start();
  }

  void dispose() {
    _simulator.stop();
    _pollingTimer?.cancel();
  }
}
