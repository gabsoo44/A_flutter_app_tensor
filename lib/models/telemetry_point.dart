/// Represents a single telemetry data point measured by the sensor at a specific moment in time.
/// This class encapsulates both temperature and humidity values, along with their associated timestamp.
/// It is typically used to store, display, or transmit environmental readings in monitoring systems.
class TelemetryPoint {
  /// Timestamp when the measurement was captured.
  /// Used to order, analyze trends, or time-align with other data sources.
  DateTime timestamp;

  /// Measured temperature value, expected in degrees Celsius.
  /// Can be used in threshold checks, graph plotting, or statistical analysis.
  double temperature;

  // Measured humidity percentage at the time of the reading.
  // Useful for correlating environmental conditions or detecting anomalies.
  double humidity;

  // Constructor requiring all fields to ensure the telemetry point is fully defined.
  // Prevents incomplete data points which could break data integrity in storage or processing.
  TelemetryPoint({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
  });
}
