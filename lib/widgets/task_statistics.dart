import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/models/task.dart';

class TaskStatistics extends StatefulWidget {
  final List<Task> tasks;

  const TaskStatistics({super.key, required this.tasks});

  @override
  State<TaskStatistics> createState() => _TaskStatisticsState();
}

class _TaskStatisticsState extends State<TaskStatistics> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildWeeklyChart(context),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildPriorityPieChart(context)),
                Expanded(child: _buildStatusPieChart(context)),
              ],
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(12),
            tooltipMargin: 8,
            tooltipBorder: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              width: 1,
            ),
            getTooltipColor: (spot) => Theme.of(context).colorScheme.surface,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.round()} tasks',
                  TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '\n${_getWeekDay(spot.x.toInt())}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    days[value.toInt()],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: _getWeeklyData(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWeeklyData() {
    // Mock data - replace with actual task completion data
    return [
      const FlSpot(0, 3),
      const FlSpot(1, 5),
      const FlSpot(2, 4),
      const FlSpot(3, 6),
      const FlSpot(4, 8),
      const FlSpot(5, 4),
      const FlSpot(6, 5),
    ];
  }

  Widget _buildPriorityPieChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (event is! FlPointerHoverEvent &&
                    event is! FlTapUpEvent &&
                    event is! FlPanEndEvent) {
                  return;
                }
                _touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
              });
            },
          ),
          sections: _getPrioritySections(context),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPrioritySections(BuildContext context) {
    return [
      _buildPieSection('High', 30, Colors.red, 0),
      _buildPieSection('Medium', 40, Colors.orange, 1),
      _buildPieSection('Low', 30, Colors.green, 2),
    ];
  }

  PieChartSectionData _buildPieSection(
    String title,
    double value,
    Color color,
    int index,
  ) {
    final isTouched = index == _touchedIndex;
    final radius = isTouched ? 60.0 : 50.0;
    final fontSize = isTouched ? 20.0 : 16.0;

    return PieChartSectionData(
      value: value,
      title: '$title\n${value.round()}%',
      color: color,
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: isTouched
          ? _BadgeWidget(
              text: title,
              color: color,
            )
          : null,
      badgePositionPercentageOffset: 1.2,
    );
  }

  String _getWeekDay(int index) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[index];
  }

  Widget _buildStatusPieChart(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 60,
              title: 'Done',
              color: Colors.green,
              radius: 50,
            ),
            PieChartSectionData(
              value: 25,
              title: 'In Progress',
              color: Colors.blue,
              radius: 50,
            ),
            PieChartSectionData(
              value: 15,
              title: 'Pending',
              color: Colors.grey,
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;

  const _BadgeWidget({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().scale();
  }
}