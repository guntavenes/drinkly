import 'package:drinkly/app/app_shell.dart';
import 'package:drinkly/features/reminders/application/notification_controller.dart';
import 'package:drinkly/features/settings/presentation/screens/hydration_sources_screen.dart';
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

  String? _nameError;
  String? _weightError;

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

  void _previous() {
    FocusScope.of(context).unfocus();

    if (_page == 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    FocusScope.of(context).unfocus();

    setState(() {
      _nameError = null;
      _weightError = null;
    });

    if (_page == 1 && _nameController.text.trim().isEmpty) {
      setState(() {
        _nameError = 'Please enter your name';
      });
      return;
    }

    if (_page == 2) {
      final weight = int.tryParse(_weightController.text);

      if (weight == null) {
        setState(() {
          _weightError = 'Please enter your weight';
        });
        return;
      }

      if (weight < 30 || weight > 250) {
        setState(() {
          _weightError = 'Please enter a valid weight';
        });
        return;
      }
    }

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
      userName: _nameController.text.trim(),
      weightKg: weight,
      activityLevel: _activityLevel,
    );

    await repository.updateDailyGoal(_recommendedGoal);
    await repository.updateOnboardingCompleted(true);

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AppShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    FocusScope.of(context).unfocus();
                    setState(() => _page = index);
                  },
                  children: [
                    const _IntroPage(
                      emoji: '💧',
                      title: 'Welcome to Drinkly',
                      subtitle: 'Build a healthy hydration habit every day.',
                    ),
                    _NamePage(
                      controller: _nameController,
                      errorText: _nameError,
                      onChanged: () {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    _WeightPage(
                      controller: _weightController,
                      errorText: _weightError,
                      onChanged: () {
                        setState(() => _weightError = null);
                      },
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
            ),
            _OnboardingBottomBar(
              page: _page,
              totalPages: 5,
              onBack: _previous,
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar({
    required this.page,
    required this.totalPages,
    required this.onBack,
    required this.onNext,
  });

  final int page;
  final int totalPages;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final inactiveColor = textColor.withValues(alpha: .16);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: .94),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .08),
            blurRadius: 28,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 106,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: page == 0 ? null : onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                disabledForegroundColor: textColor.withValues(alpha: .22),
                side: BorderSide(color: Theme.of(context).dividerColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: _StepProgress(
              currentPage: page,
              totalPages: totalPages,
              inactiveColor: inactiveColor,
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 118,
            height: 54,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: AppColors.primary.withValues(alpha: .28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      page == totalPages - 1 ? 'Start' : 'Next',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      page == totalPages - 1
                          ? Icons.water_drop_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.currentPage,
    required this.totalPages,
    required this.inactiveColor,
  });

  final int currentPage;
  final int totalPages;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (index) {
        final isCompleted = index < currentPage;
        final isCurrent = index == currentPage;

        return Expanded(
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: isCurrent ? 15 : 11,
                height: isCurrent ? 15 : 11,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted || isCurrent
                      ? AppColors.primary
                      : inactiveColor,
                  border: isCurrent
                      ? Border.all(color: Theme.of(context).cardColor, width: 3)
                      : null,
                ),
              ),
              if (index != totalPages - 1)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 3,
                    color: index < currentPage
                        ? AppColors.primary
                        : inactiveColor,
                  ),
                ),
            ],
          ),
        );
      }),
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

class _NamePage extends StatelessWidget {
  const _NamePage({
    required this.controller,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _OnboardingIcon(icon: Icons.person_rounded),
        const SizedBox(height: 28),
        Text(
          'What should we call you?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Personalize your Drinkly experience.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 34),
        _FloatingTextInput(
          controller: controller,
          label: 'Name',
          hintText: 'Enter your name',
          hasError: errorText != null,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          onChanged: onChanged,
        ),
        _ErrorOrTip(
          errorText: errorText,
          tip: 'Tip: You can edit this later in settings.',
        ),
      ],
    );
  }
}

class _WeightPage extends StatelessWidget {
  const _WeightPage({
    required this.controller,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _OnboardingIcon(icon: Icons.monitor_weight_outlined),
        const SizedBox(height: 28),
        Text(
          'Your weight',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We use this to calculate your daily goal.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 28),
        _WeightFloatingInput(
          controller: controller,
          hasError: errorText != null,
          onChanged: onChanged,
        ),
        _ErrorOrTip(
          errorText: errorText,
          tip: 'Tip: You can change this later in settings.',
        ),
      ],
    );
  }
}

class _ErrorOrTip extends StatelessWidget {
  const _ErrorOrTip({required this.errorText, required this.tip});

  final String? errorText;
  final String tip;

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: .58);

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      child: Padding(
        padding: const EdgeInsets.only(top: 18),
        child: errorText != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    errorText!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      tip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _OnboardingIcon extends StatelessWidget {
  const _OnboardingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .08),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 48),
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
        const _OnboardingIcon(icon: Icons.directions_run_rounded),
        const SizedBox(height: 28),
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
                'Suggested Starting Goal',
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
              const SizedBox(height: 10),
              Text(
                'A general starting estimate for tracking purposes. '
                'Individual hydration needs vary.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HydrationSourcesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: const Text(
                  'Sources & health notice',
                  style: TextStyle(fontWeight: FontWeight.w800),
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
        _OnboardingIcon(
          icon: _enabled
              ? Icons.check_circle_rounded
              : Icons.notifications_active_rounded,
        ),
        const SizedBox(height: 28),
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

class _FloatingTextInput extends StatefulWidget {
  const _FloatingTextInput({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.hasError,
    required this.onChanged,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool hasError;
  final VoidCallback onChanged;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;

  @override
  State<_FloatingTextInput> createState() => _FloatingTextInputState();
}

class _FloatingTextInputState extends State<_FloatingTextInput> {
  final _focusNode = FocusNode();

  bool get _isActive =>
      _focusNode.hasFocus || widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });

    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .48);
    final borderColor = widget.hasError
        ? Colors.redAccent
        : _focusNode.hasFocus
        ? AppColors.primary
        : AppColors.primary.withValues(alpha: .18);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 76,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
          width: _focusNode.hasFocus ? 1.8 : 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: _focusNode.hasFocus ? .09 : .05,
            ),
            blurRadius: _focusNode.hasFocus ? 30 : 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            top: _isActive ? 4 : 20,
            left: 0,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: _isActive ? 12 : 22,
                fontWeight: FontWeight.w700,
                color: _isActive
                    ? (_focusNode.hasFocus
                          ? AppColors.primary
                          : secondaryTextColor)
                    : textColor.withValues(alpha: .22),
              ),
              child: Text(_isActive ? widget.label : widget.hintText),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 6,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization,
              autofillHints: widget.autofillHints,
              onChanged: (_) => widget.onChanged(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightFloatingInput extends StatefulWidget {
  const _WeightFloatingInput({
    required this.controller,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final VoidCallback onChanged;

  @override
  State<_WeightFloatingInput> createState() => _WeightFloatingInputState();
}

class _WeightFloatingInputState extends State<_WeightFloatingInput> {
  final _focusNode = FocusNode();

  bool get _isActive =>
      _focusNode.hasFocus || widget.controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .52);

    final borderColor = widget.hasError
        ? Colors.redAccent
        : _focusNode.hasFocus
        ? AppColors.primary
        : AppColors.primary.withValues(alpha: .18);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 118,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
          width: _focusNode.hasFocus ? 1.8 : 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: _focusNode.hasFocus ? .09 : .05,
            ),
            blurRadius: _focusNode.hasFocus ? 30 : 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (_isActive)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              top: 2,
              left: 0,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _focusNode.hasFocus
                      ? AppColors.primary
                      : secondaryTextColor,
                ),
                child: const Text('Weight'),
              ),
            ),
          Center(
            child: SizedBox(
              width: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 3,
                    textAlign: TextAlign.center,
                    onChanged: (_) => widget.onChanged(),
                    style: TextStyle(
                      fontSize: 44,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      counterText: '',
                      hintStyle: TextStyle(
                        fontSize: 44,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: textColor.withValues(alpha: .18),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
