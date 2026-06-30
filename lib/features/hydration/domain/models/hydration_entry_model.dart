import 'package:intl/intl.dart';

class HydrationEntryModel {
  const HydrationEntryModel({
    required this.id,
    required this.amount,
    required this.createdAt,
  });

  final int id;
  final int amount;
  final DateTime createdAt;

  String get amountText => '$amount ml';

  String get timeText => DateFormat('HH:mm').format(createdAt);

  bool get isToday {
    final now = DateTime.now();

    return now.year == createdAt.year &&
        now.month == createdAt.month &&
        now.day == createdAt.day;
  }
}
