import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../settings/data/providers/settings_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  int _activityLevel = 1;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    settingsAsync.whenData((settings) {
      if (settings == null || _initialized) return;

      _nameController.text = settings.userName ?? '';
      _weightController.text = settings.weightKg?.toString() ?? '';
      _activityLevel = settings.activityLevel;
      _initialized = true;
    });

    final recommendedGoal = _calculateRecommendedGoal();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _Header(onBack: () => Navigator.pop(context)),
              const SizedBox(height: 28),
              const _AvatarCard(),
              const SizedBox(height: 20),
              GlassCard(
                borderRadius: 28,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _InputRow(
                      title: 'Name',
                      hint: 'Your name',
                      controller: _nameController,
                    ),
                    const _Divider(),
                    _InputRow(
                      title: 'Weight',
                      hint: '75',
                      suffix: 'kg',
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const _Divider(),
                    _ActivitySelector(
                      selected: _activityLevel,
                      onChanged: (value) {
                        setState(() => _activityLevel = value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _RecommendedGoalCard(goal: recommendedGoal),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () async {
                    final repository = ref.read(settingsRepositoryProvider);
                    final weight = int.tryParse(_weightController.text);

                    await repository.updateProfile(
                      userName: _nameController.text.trim().isEmpty
                          ? null
                          : _nameController.text.trim(),
                      weightKg: weight,
                      activityLevel: _activityLevel,
                    );

                    await repository.updateDailyGoal(recommendedGoal);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateRecommendedGoal() {
    final weight = int.tryParse(_weightController.text) ?? 75;
    final base = weight * 35;

    final activityBonus = switch (_activityLevel) {
      1 => 0,
      2 => 300,
      3 => 600,
      _ => 0,
    };

    final result = base + activityBonus;

    return ((result / 100).round() * 100).clamp(1500, 5000);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onBack,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 46),
      ],
    );
  }
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drinkly Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Personalize your hydration goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.title,
    required this.hint,
    required this.controller,
    this.suffix,
    this.keyboardType,
    this.inputFormatters,
  });

  final String title;
  final String hint;
  final String? suffix;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w800, color: textColor),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hint,
                suffixText: suffix,
                border: InputBorder.none,
                hintStyle: TextStyle(color: secondaryTextColor),
              ),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitySelector extends StatelessWidget {
  const _ActivitySelector({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Level',
            style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _ActivityChip(
                label: 'Low',
                emoji: '🐢',
                selected: selected == 1,
                onTap: () => onChanged(1),
              ),
              const SizedBox(width: 10),
              _ActivityChip(
                label: 'Medium',
                emoji: '🚶',
                selected: selected == 2,
                onTap: () => onChanged(2),
              ),
              const SizedBox(width: 10),
              _ActivityChip(
                label: 'High',
                emoji: '🏃',
                selected: selected == 3,
                onTap: () => onChanged(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityChip extends StatelessWidget {
  const _ActivityChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: .58);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: .14)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .45)
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: selected ? AppColors.primary : secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedGoalCard extends StatelessWidget {
  const _RecommendedGoalCard({required this.goal});

  final int goal;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Recommendation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$goal ml/day',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your weight and activity level',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 18,
      endIndent: 18,
      color: Theme.of(context).dividerColor,
    );
  }
}
