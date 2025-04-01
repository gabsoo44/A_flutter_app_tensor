// Représente un point de données mesuré par le capteur à un instant donné
class TelemetryPoint {
  // Moment où la donnée a été capturée
  final DateTime timestamp;

  // Température relevée (en °C, par défaut)
  final double temperature;

  // Humidité relevée (en %)
  final double humidity;

  // Constructeur de la classe : on a besoin des 3 infos pour créer un point
  TelemetryPoint({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
  });
}