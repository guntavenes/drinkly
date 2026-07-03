import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({super.key, required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Weekly Hydration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _maxY(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: .15),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: 1000,
                      getTitlesWidget: _leftTitle,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: _bottomTitle,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} ml',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: List.generate(values.length, (index) {
                  final amount = values[index];

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: amount == 0 ? 40 : amount.toDouble(),
                        width: 22,
                        borderRadius: BorderRadius.circular(8),
                        color: index == DateTime.now().weekday - 1
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: .35),
                      ),
                    ],
                  );
                }),
              ),
              duration: const Duration(milliseconds: 700),
            ),
          ),
        ],
      ),
    );
  }

  double _maxY() {
    if (values.isEmpty) return 2500;

    final max = values.reduce((a, b) => a > b ? a : b);

    if (max < 2500) return 2500;

    return (max + 500).toDouble();
  }

  Widget _leftTitle(double value, TitleMeta meta) {
    if (value % 1000 != 0) {
      return const SizedBox.shrink();
    }

    return Text(
      '${(value / 1000).toInt()}L',
      style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
    );
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final index = value.toInt();

    if (index < 0 || index >= days.length) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        days[index],
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
