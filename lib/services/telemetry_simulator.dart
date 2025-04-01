import 'dart:async';
import 'dart:math';

/// Simulates a sensor that periodically emits temperature and humidity readings.
/// Each reading is generated independently based on configured time intervals,
/// and emitted through a callback with placeholder `-1` when a value is not updated.
class TelemetrySimulator {
  /// Callback function triggered when new data is available.
  /// Called with (temperature, humidity) where either can be `-1` if not updated.
  final Function(double, double) onNewData;

  /// Time interval between generated temperature values.
  final Duration tempInterval;

  /// Time interval between generated humidity values.
  final Duration humInterval;

  // Timer responsible for periodic temperature generation
  Timer? _tempTimer;

  // Timer responsible for periodic humidity generation
  Timer? _humTimer;

  // Used to generate pseudo-random values for temperature and humidity
  final Random _random = Random();

  /// Constructor that configures the simulator with its data emission intervals
  TelemetrySimulator({
    required this.onNewData,
    required this.tempInterval,
    required this.humInterval,
  });

  /// Starts the simulation by launching two independent periodic timers:
  /// - One for temperature updates
  /// - One for humidity updates
  void start() {
    _tempTimer = Timer.periodic(tempInterval, (_) {
      // Generate a random temperature between 10.0 and 30.0 with 0.1 precision
      final temp = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      // Trigger callback with updated temperature and placeholder for humidity
      onNewData(temp, -1);
    });

    _humTimer = Timer.periodic(humInterval, (_) {
      // Generate a random humidity between 10% and 30% with 0.1 precision
      final hum = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      // Trigger callback with placeholder for temperature and updated humidity
      onNewData(-1, hum);
    });
  }

  /// Stops both timers to halt data generation.
  /// Should be called when the simulator is no longer needed to prevent leaks.
  void stop() {
    _tempTimer?.cancel();
    _humTimer?.cancel();
  }
}
