import 'package:drinkly/features/statistics/domain/models/statistics_period.dart';
import 'package:flutter_riverpod/legacy.dart';

final statisticsPeriodProvider = StateProvider<StatisticsPeriod>(
  (ref) => StatisticsPeriod.week,
);
