import 'package:drinkly/core/utils/formatters.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/models/statistics_period.dart';

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({
    super.key,
    required this.values,
    required this.period,
  });

  final List<int> values;
  final StatisticsPeriod period;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);
    final gridColor = Theme.of(context).dividerColor.withValues(alpha: .45);

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                _title(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textColor,
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
                  horizontalInterval: _interval(),
                  getDrawingHorizontalLine: (_) {
                    return FlLine(color: gridColor, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      interval: _interval(),
                      getTitlesWidget: (value, meta) {
                        return _leftTitle(value, meta, secondaryTextColor);
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return _bottomTitle(value, meta, secondaryTextColor);
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        Formatters.formatVolume(rod.toY.toInt()),
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
                        toY: amount == 0 ? _emptyBarValue() : amount.toDouble(),
                        width: _barWidth(),
                        borderRadius: BorderRadius.circular(8),
                        color: index == _activeIndex()
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

  String _title() {
    switch (period) {
      case StatisticsPeriod.week:
        return 'Weekly Hydration';
      case StatisticsPeriod.month:
        return 'Monthly Hydration';
      case StatisticsPeriod.year:
        return 'Yearly Hydration';
    }
  }

  List<String> _labels() {
    switch (period) {
      case StatisticsPeriod.week:
        return ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      case StatisticsPeriod.month:
        return ['W1', 'W2', 'W3', 'W4'];
      case StatisticsPeriod.year:
        return ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    }
  }

  double _maxY() {
    if (values.isEmpty) {
      return switch (period) {
        StatisticsPeriod.week => 2500,
        StatisticsPeriod.month => 10000,
        StatisticsPeriod.year => 50000,
      };
    }

    final max = values.reduce((a, b) => a > b ? a : b);

    final minimum = switch (period) {
      StatisticsPeriod.week => 2500,
      StatisticsPeriod.month => 10000,
      StatisticsPeriod.year => 50000,
    };

    if (max < minimum) return minimum.toDouble();

    final step = switch (period) {
      StatisticsPeriod.week => 1000,
      StatisticsPeriod.month => 5000,
      StatisticsPeriod.year => 10000,
    };

    return (((max + step) / step).ceil() * step).toDouble();
  }

  double _interval() {
    return switch (period) {
      StatisticsPeriod.week => 1000,
      StatisticsPeriod.month => 5000,
      StatisticsPeriod.year => 10000,
    };
  }

  double _emptyBarValue() {
    return switch (period) {
      StatisticsPeriod.week => 40,
      StatisticsPeriod.month => 150,
      StatisticsPeriod.year => 500,
    };
  }

  double _barWidth() {
    return switch (period) {
      StatisticsPeriod.week => 22,
      StatisticsPeriod.month => 28,
      StatisticsPeriod.year => 18,
    };
  }

  int _activeIndex() {
    final now = DateTime.now();

    switch (period) {
      case StatisticsPeriod.week:
        return now.weekday - 1;
      case StatisticsPeriod.month:
        return ((now.day - 1) / 7).floor().clamp(0, 3);
      case StatisticsPeriod.year:
        return now.month - 1;
    }
  }

  Widget _leftTitle(double value, TitleMeta meta, Color color) {
    if (value == 0) {
      return Text('0L', style: TextStyle(fontSize: 11, color: color));
    }

    if (value % _interval() != 0) {
      return const SizedBox.shrink();
    }

    return Text(
      '${(value / 1000).toStringAsFixed(0)}L',
      style: TextStyle(fontSize: 11, color: color),
    );
  }

  Widget _bottomTitle(double value, TitleMeta meta, Color color) {
    final labels = _labels();
    final index = value.toInt();

    if (index < 0 || index >= labels.length) {
      return const SizedBox.shrink();
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        labels[index],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
