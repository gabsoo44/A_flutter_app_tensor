import 'dart:async';

/// Simulates a remote server that returns sensor configuration attributes.
/// For now, only the temperature unit is supported.
class FakeServer {
  /// Simulated temperature unit stored on the server (always Celsius here)
  String _temperatureUnit = "°C";

  /// Simulates a call to get current sensor attributes from the server
  Future<Map<String, dynamic>> getAttributes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return {'temperatureUnit': _temperatureUnit};
  }

  /// Optionally allows changing the temperature unit (not used yet)
  // ignore: use_setters_to_change_properties
  void setUnit(String newUnit) {
    _temperatureUnit = newUnit;
  }
}
