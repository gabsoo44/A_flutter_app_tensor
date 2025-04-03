import 'package:a_flutter_app_tensor/models/telemetry_point.dart';

/// Service for managing manual telemetry data entry.
/// Handles validation and creation of TelemetryPoint instances.
class ManualModeService {
  final List<TelemetryPoint> _points = [];
  final void Function(List<TelemetryPoint>) onUpdate;

  ManualModeService({required this.onUpdate});

  /// Adds a new telemetry point with the given values
  void addPoint(double temperature, double humidity) {
    final point = TelemetryPoint(
      timestamp: DateTime.now(),
      temperature: temperature,
      humidity: humidity,
    );

    _points.add(point);

    // Keep only the most recent 20 points
    if (_points.length > 20) {
      _points.removeAt(0);
    }

    // Notify the UI
    onUpdate(List.unmodifiable(_points));
  }

  /// Returns the current list of telemetry points
  List<TelemetryPoint> get points => List.unmodifiable(_points);

  /// Clears all data points (optional helper)
  void reset() {
    _points.clear();
    onUpdate(List.unmodifiable(_points));
  }
}
