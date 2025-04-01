import 'dart:async';
import 'dart:math';

// Cette classe simule un capteur qui génère périodiquement des données de température et d'humidité
class TelemetrySimulator {
  // Fonction de rappel appelée à chaque nouvelle donnée générée
  final Function(double, double) onNewData;

  // Fréquence d'envoi des données de température
  final Duration tempInterval;

  // Fréquence d'envoi des données d'humidité
  final Duration humInterval;

  Timer? _tempTimer;
  Timer? _humTimer;
  final Random _random = Random();

  TelemetrySimulator({
    required this.onNewData,
    required this.tempInterval,
    required this.humInterval,
  });

  // Démarre les deux timers : un pour la température, un pour l’humidité
  void start() {
    _tempTimer = Timer.periodic(tempInterval, (_) {
      // Génère une température aléatoire entre 10.0 et 30.0 (précision 0.1)
      final temp = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      // Appelle la fonction de rappel avec -1 pour l’humidité (non mise à jour ici)
      onNewData(temp, -1);
    });

    _humTimer = Timer.periodic(humInterval, (_) {
      // Génère une humidité aléatoire entre 10% et 30% (précision 0.1)
      final hum = double.parse((10 + _random.nextDouble() * 20).toStringAsFixed(1));
      // Appelle la fonction de rappel avec -1 pour la température (non mise à jour ici)
      onNewData(-1, hum);
    });
  }

  // Arrête les deux timers
  void stop() {
    _tempTimer?.cancel();
    _humTimer?.cancel();
  }
}
