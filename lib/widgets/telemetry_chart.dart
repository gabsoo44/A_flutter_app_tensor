import 'package:a_flutter_app_tensor/models/telemetry_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Widget that displays a line chart with temperature and humidity data over time.
/// Uses `fl_chart` to render smooth curves and tooltips based on the list of `TelemetryPoint` objects.
class TelemetryChart extends StatelessWidget {
  /// List of telemetry points to plot on the graph
  final List<TelemetryPoint> points;

  /// Temperature unit used in tooltip labels (e.g., "°C", "°F")
  final String unit;

  /// Requires a list of points and an optional temperature unit label
  const TelemetryChart({required this.points, this.unit = "°C", super.key});

  @override

  /// Builds the line chart with two curves: one for temperature, one for humidity.
  /// Each curve uses a distinct color and displays a tooltip when touched.
  Widget build(BuildContext context) {
    // Spots for the temperature curve
    final tempSpots = <FlSpot>[];

    // Spots for the humidity curve
    final humiditySpots = <FlSpot>[];

    // Convert telemetry points into FlSpot instances with index-based X-axis
    for (var i = 0; i < points.length; i++) {
      tempSpots.add(FlSpot(i.toDouble(), points[i].temperature));
      humiditySpots.add(FlSpot(i.toDouble(), points[i].humidity));
    }

    return LineChart(
      LineChartData(
        // Axis label configuration
        titlesData: const FlTitlesData(
          // X-axis labels omitted
          bottomTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
        ),

        // Two line series: red for temperature, blue for humidity
        lineBarsData: [
          LineChartBarData(
            spots: tempSpots,
            isCurved: true,
            color: Colors.red,
            // Area under the curve (not shown)
            belowBarData: BarAreaData(),
          ),
          LineChartBarData(
            spots: humiditySpots,
            isCurved: true,
            color: Colors.blue,
            belowBarData: BarAreaData(),
          ),
        ],

        // Draw chart border
        borderData: FlBorderData(show: true),

        // Y-axis range
        minY: 0,
        maxY: 40,

        // Interactive tooltip configuration
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.grey.shade700,
            getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
              final isTemp = spot.bar.color == Colors.red;
              final label = isTemp
                  ? "Temp: ${spot.y.toStringAsFixed(1)} $unit"
                  : "Hum: ${spot.y.toStringAsFixed(1)} %";
              return LineTooltipItem(label, const TextStyle(color: Colors.white));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
