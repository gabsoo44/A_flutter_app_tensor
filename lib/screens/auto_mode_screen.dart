import 'dart:async';

import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:a_flutter_app_tensor/services/fake_server.dart';
import 'package:a_flutter_app_tensor/services/telemetry_simulator.dart';
import 'package:a_flutter_app_tensor/widgets/telemetry_chart.dart';
import 'package:flutter/material.dart';

// Écran qui simule le mode automatique d'un capteur (température/humidité)
class AutoModeScreen extends StatefulWidget {
  const AutoModeScreen({super.key});

  @override
  State<AutoModeScreen> createState() => _AutoModeScreenState();
}

class _AutoModeScreenState extends State<AutoModeScreen> {
  final List<TelemetryPoint> _points = []; // Historique des mesures
  late TelemetrySimulator _simulator;     // Générateur de données simulées
  final FakeServer _server = FakeServer(); // Faux serveur pour récupérer les attributs
  bool isActiveMode = true;               // Mode actif ou veille
  double? _lastTemp;                      // Dernière température connue
  double? _lastHum;                       // Dernière humidité connue
  String _unit = "°C";                    // Unité de température actuelle (ex. "°C")
  Timer? _pollingTimer;                  // Timer pour interroger le serveur périodiquement

  @override
  void initState() {
    super.initState();
    _startSimulator();                   // Lance la génération de données
    _startPollingServerAttributes();    // Lance l'interrogation périodique du serveur
  }

  // Configure le simulateur selon le mode actif/veille
  void _startSimulator() {
    _simulator = TelemetrySimulator(
      onNewData: _handleNewData,
      tempInterval: isActiveMode ? const Duration(seconds: 10) : const Duration(seconds: 20),
      humInterval: isActiveMode ? const Duration(seconds: 20) : const Duration(seconds: 50),
    );
    _simulator.start();
  }

  // Interroge le faux serveur à intervalle régulier pour obtenir l'unité de température
  void _startPollingServerAttributes() {
    _pollingTimer?.cancel();
    final interval = isActiveMode ? const Duration(seconds: 10) : const Duration(seconds: 20);
    _pollingTimer = Timer.periodic(interval, (_) async {
      final attributes = await _server.getAttributes();
      setState(() {
        _unit = attributes['temperatureUnit'] as String;
      });
    });
  }

  // Réception des nouvelles données simulées (température et/ou humidité)
  void _handleNewData(double temp, double hum) {
    setState(() {
      // On conserve les dernières valeurs valides
      if (temp != -1) {
        _lastTemp = temp;
      }
      if (hum != -1) {
        _lastHum = hum;
      }

      // Ajoute un point uniquement si on a les 2 valeurs
      if (_lastTemp != null && _lastHum != null) {
        _points.add(TelemetryPoint(
          timestamp: DateTime.now(),
          temperature: _lastTemp!,
          humidity: _lastHum!,
        ));
        // Garde un historique limité à 20 points pour ne pas surcharger le graphique
        if (_points.length > 20) {
          _points.removeAt(0);
        }
      }
    });
  }

  // Permet de basculer entre mode actif et veille via le switch
  void _toggleMode(bool value) {
    setState(() {
      isActiveMode = value;
      _simulator.stop();
      _pollingTimer?.cancel();
      _startSimulator();                // Redémarre avec les nouveaux intervalles
      _startPollingServerAttributes();
    });
  }

  @override
  void dispose() {
    _simulator.stop();                 // Nettoyage des timers à la fermeture
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mode Automatique')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Infos sur la fréquence des envois
          Text('Données mises à jour toutes les ${isActiveMode ? "10/20" : "20/50"} secondes (T/H).'),
          Text('Unité température : $_unit'),

          const SizedBox(height: 10),

          // Bouton pour activer/désactiver le mode actif/veille
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Mode Actif'),
              Switch(
                value: isActiveMode,
                onChanged: _toggleMode,
              ),
              const Text('Mode Veille'),
            ],
          ),

          const SizedBox(height: 20),

          // Graphique avec les données télémétriques
          Expanded(
            child: TelemetryChart(
              points: _points,
              unit: _unit,
            ),
          ),
        ],
      ),
    ),
  );
}
