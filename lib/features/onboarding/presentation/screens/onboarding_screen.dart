import 'package:drinkly/features/reminders/application/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../settings/data/providers/settings_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  int _page = 0;
  int _activityLevel = 1;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  int get _recommendedGoal {
    final weight = int.tryParse(_weightController.text) ?? 75;
    final base = weight * 35;

    final bonus = switch (_activityLevel) {
      1 => 0,
      2 => 300,
      3 => 600,
      _ => 0,
    };

    return (((base + bonus) / 100).round() * 100).clamp(1500, 5000);
  }

  void _next() {
    if (_page < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _finish();
  }

  Future<void> _finish() async {
    final repository = ref.read(settingsRepositoryProvider);
    final weight = int.tryParse(_weightController.text);

    await repository.updateProfile(
      userName: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      weightKg: weight,
      activityLevel: _activityLevel,
    );

    await repository.updateDailyGoal(_recommendedGoal);
    await repository.updateOnboardingCompleted(true);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _page = index);
                  },
                  children: [
                    _IntroPage(
                      emoji: '💧',
                      title: 'Welcome to Drinkly',
                      subtitle: 'Build a healthy hydration habit every day.',
                    ),
                    _InputPage(
                      title: 'What should we call you?',
                      subtitle: 'Personalize your Drinkly experience.',
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Your name',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _InputPage(
                      title: 'Your weight',
                      subtitle: 'We use this to calculate your daily goal.',
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: '75 kg',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    _ActivityPage(
                      selected: _activityLevel,
                      recommendedGoal: _recommendedGoal,
                      onChanged: (value) {
                        setState(() => _activityLevel = value);
                      },
                    ),
                    _NotificationPage(
                      onEnable: () async {
                        await ref
                            .read(notificationControllerProvider)
                            .updateReminder(true);
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? AppColors.primary
                          : secondaryTextColor.withValues(alpha: .25),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
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
                  onPressed: _next,
                  child: Text(
                    _page == 4 ? 'Start Drinking' : 'Continue',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 76)),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _InputPage extends StatelessWidget {
  const _InputPage({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 28),
        GlassCard(
          borderRadius: 26,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: child,
        ),
      ],
    );
  }
}

class _ActivityPage extends StatelessWidget {
  const _ActivityPage({
    required this.selected,
    required this.recommendedGoal,
    required this.onChanged,
  });

  final int selected;
  final int recommendedGoal;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Activity level',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'This helps us recommend your daily goal.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 28),
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
        const SizedBox(height: 24),
        GlassCard(
          borderRadius: 26,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Recommended Goal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$recommendedGoal ml/day',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
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
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: .14)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: .45)
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
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

class _NotificationPage extends StatefulWidget {
  const _NotificationPage({required this.onEnable});

  final Future<void> Function() onEnable;

  @override
  State<_NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<_NotificationPage> {
  bool _enabled = false;
  bool _loading = false;

  Future<void> _enable() async {
    setState(() => _loading = true);

    await widget.onEnable();

    if (!mounted) return;

    setState(() {
      _enabled = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('🔔', style: TextStyle(fontSize: 72)),
        const SizedBox(height: 24),
        Text(
          'Stay on track',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _enabled
              ? 'Reminders are enabled. You can change this later in Settings.'
              : 'Enable reminders so Drinkly can gently remind you to drink water.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 28),
        GlassCard(
          borderRadius: 26,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                _enabled
                    ? Icons.check_circle_rounded
                    : Icons.notifications_active_rounded,
                color: AppColors.primary,
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                _enabled
                    ? 'Reminders enabled successfully.'
                    : 'You can change this later in Settings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _enabled || _loading ? null : _enable,
                  child: Text(
                    _loading
                        ? 'Enabling...'
                        : _enabled
                        ? 'Enabled'
                        : 'Enable Reminders',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
