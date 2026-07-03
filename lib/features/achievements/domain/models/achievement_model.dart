import 'package:flutter/material.dart';

class AchievementModel {
  const AchievementModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.unlocked,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String progressText;
  final bool unlocked;
}
