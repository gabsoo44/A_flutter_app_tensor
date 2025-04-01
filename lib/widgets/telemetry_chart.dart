import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Widget affichant un graphique des données de température et d’humidité
class TelemetryChart extends StatelessWidget {
  final List<TelemetryPoint> points;
  final String unit;

  // Le graphique prend une liste de points de télémétrie et une unité de température à afficher
  const TelemetryChart({required this.points, this.unit = "°C", super.key});

  @override
  Widget build(BuildContext context) {
    final tempSpots = <FlSpot>[];      // Points pour la courbe de température
    final humiditySpots = <FlSpot>[];  // Points pour la courbe d’humidité

    // On transforme chaque point de données en un FlSpot pour fl_chart
    for (var i = 0; i < points.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), points[i].temperature));
      humiditySpots.add(FlSpot(i.toDouble(), points[i].humidity));
    }

    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(
          // On laisse les axes top, bottom et right vides ici
          bottomTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),
        lineBarsData: [
          // Courbe rouge pour la température
          LineChartBarData(
            spots: tempSpots,
            isCurved: true,
            color: Colors.red,
            belowBarData: BarAreaData(), // zone sous la courbe (invisible ici)
          ),
          // Courbe bleue pour l’humidité
          LineChartBarData(
            spots: humiditySpots,
            isCurved: true,
            color: Colors.blue,
            belowBarData: BarAreaData(),
          ),
        ],
        borderData: FlBorderData(show: true), // Affiche les bords du graphe
        minY: 0,  // Valeur minimale de l’axe Y
        maxY: 40, // Valeur maximale de l’axe Y

        // Interaction avec le graphique (tooltip)
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey.shade700,
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              final isTemp = spot.bar.color == Colors.red;
              final label = isTemp
                  ? "Temp: ${spot.y.toStringAsFixed(1)} $unit" // unité dynamique
                  : "Hum: ${spot.y.toStringAsFixed(1)} %";
              return LineTooltipItem(label, const TextStyle(color: Colors.white));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
