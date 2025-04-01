// Import du modèle de données, du formulaire de saisie et du graphique
import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/widgets/data_input_form.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

// Écran pour le mode manuel (saisie des données par l'utilisateur)
class ManualModeScreen extends StatefulWidget {
  const ManualModeScreen({super.key});

  @override
  State<ManualModeScreen> createState() => _ManualModeScreenState();
}

class _ManualModeScreenState extends State<ManualModeScreen> {
  // Liste des points de télémétrie saisis manuellement
  final List<TelemetryPoint> _points = [];

  // Fonction appelée lors de la soumission du formulaire
  void _addPoint(double temperature, double humidity) {
    setState(() {
      _points.add(TelemetryPoint(
        timestamp: DateTime.now(), // Date actuelle pour le point
        temperature: temperature,
        humidity: humidity,
      ));

      // On limite à 20 valeurs pour éviter d'alourdir le graphique
      if (_points.length > 20) {
        _points.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mode Manuel')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Formulaire pour saisir température et humidité
              DataInputForm(onSubmit: _addPoint),

              const SizedBox(height: 20),

              // Graphique affichant les données saisies
              Expanded(child: TelemetryChart(points: _points)),
            ],
          ),
        ),
      );
}
