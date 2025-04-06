import 'package:a_flutter_app_tensor/constants/constants.dart';
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/auto_mode_service.dart';
import 'package:a_flutter_app_tensor/services/thing_client.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

class AutoModeScreen extends StatefulWidget {
  final ThingClient thingClient;

  const AutoModeScreen({super.key, required this.thingClient});

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

class _AutoModeScreenState extends State<AutoModeScreen> {
  final List<TelemetryPoint> _points = [];
  String _unit = "°C";
  late AutoModeService _service;

  @override
  void initState() {
    super.initState();
    print("AutoModeScreen ouvert !");
    _service = AutoModeService(
      onNewPoint: _addPoint,
      onUnitChanged: _updateUnit,
      thingClient: widget.thingClient, 
    );
    _service.start();
  }

  void _addPoint(TelemetryPoint point) {
    setState(() {
      _points.add(point);
      if (_points.length > kMaxTelemetryPoints) {
        _points.removeAt(0);
      }
    });
  }

  void _updateUnit(String unit) {
    setState(() {
      _unit = unit;
    });
  }

  void _toggleMode(bool value) {
    setState(() {
      _service.toggleMode(value);
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Auto Mode')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Data updates every ${_service.isActiveMode ? "10/20" : "20/50"} seconds (T/H).'),
              Text('Temperature unit: $_unit'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Active Mode'),
                  Switch(
                    value: _service.isActiveMode,
                    onChanged: _toggleMode,
                  ),
                  const Text('Sleep Mode'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: TelemetryChart(points: _points, unit: _unit)),
            ],
          ),
        ),
      );
}
