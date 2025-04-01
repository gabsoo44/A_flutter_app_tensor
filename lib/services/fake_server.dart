import 'dart:async';

/// Simulates a backend server responsible for returning remote configuration attributes.
/// Used to emulate asynchronous communication for retrieving temperature unit preferences.
class FakeServer {
  // Internal state representing the temperature unit ("°C" by default)
  String _unit = "°C";

  // Simulates a remote configuration update (unit change)
  // ignore: public_member_api_docs, use_setters_to_change_properties
  void setUnit(String newUnit) {
    _unit = newUnit;
  }

  /// Returns a simulated server response containing telemetry configuration.
  /// Emulates network latency with an artificial delay.
  Future<Map<String, dynamic>> getAttributes() async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate delay
    return {
      'temperatureUnit': _unit,
    };
  }
}
