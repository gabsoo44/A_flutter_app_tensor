import 'dart:async';
import 'dart:math';

/// Simulates telemetry data generation for temperature and humidity.
/// Sends values at different intervals using two independent timers.
class TelemetrySimulator {
  final Function(double, double) onNewData;
  final Duration tempInterval;
  final Duration humInterval;

  Timer? _tempTimer;
  Timer? _humTimer;
  final Random _random = Random();

  TelemetrySimulator({
    required this.onNewData,
    required this.tempInterval,
    required this.humInterval,
  });

  /// Starts the timers to periodically generate random data
  void start() {
    _tempTimer = Timer.periodic(tempInterval, (_) {
      final temp = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      onNewData(temp, -1); // -1 indicates no humidity update
    });

    _humTimer = Timer.periodic(humInterval, (_) {
      final hum = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      onNewData(-1, hum); // -1 indicates no temperature update
    });
  }

  /// Stops both timers
  void stop() {
    _tempTimer?.cancel();
    _humTimer?.cancel();
  }
}
