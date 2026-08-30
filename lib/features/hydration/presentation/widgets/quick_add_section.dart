import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

class QuickAddSection extends StatelessWidget {
  const QuickAddSection({
    super.key,
    required this.onAddWater,
    required this.amounts,
  });

  final Future<void> Function(int amount) onAddWater;
  final List<int> amounts;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick add',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Log a drink in one tap',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.bolt_rounded,
              size: 20,
              color: primaryColor.withValues(alpha: .8),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: .84),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .045),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final amount in amounts.take(3))
                _QuickAddItem(
                  icon: Icons.water_drop_rounded,
                  label: '$amount',
                  amount: amount,
                  secondaryTextColor: secondaryTextColor,
                  onTap: () => onAddWater(amount),
                ),
              _QuickAddItem(
                icon: Icons.add_rounded,
                label: 'More',
                amount: null,
                secondaryTextColor: secondaryTextColor,
                onTap: () async {
                  _showAddWaterSheet(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddWaterSheet(BuildContext context) {
    final amounts = [100, 200, 250, 330, 500, 750, 1000];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final textColor = Theme.of(sheetContext).colorScheme.onSurface;
        final secondaryTextColor = textColor.withValues(alpha: .58);

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .62,
          minChildSize: .50,
          maxChildSize: .85,
          builder: (_, scrollController) {
            return Material(
              color: Theme.of(sheetContext).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Add Water',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose how much water you drank',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        itemCount: amounts.length + 1,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 2.2,
                            ),
                        itemBuilder: (context, index) {
                          if (index == amounts.length) {
                            return _AmountGridTile(
                              icon: Icons.edit_rounded,
                              title: 'Custom',
                              onTap: () async {
                                Navigator.pop(sheetContext);
                                _showCustomAmountDialog(context);
                              },
                            );
                          }

                          final amount = amounts[index];

                          return _AmountGridTile(
                            icon: Icons.water_drop_outlined,
                            title: '$amount ml',
                            onTap: () async {
                              final navigator = Navigator.of(sheetContext);

                              await HapticFeedback.lightImpact();
                              await onAddWater(amount);

                              navigator.pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomAmountDialog(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final textColor = Theme.of(sheetContext).colorScheme.onSurface;
        final secondaryTextColor = textColor.withValues(alpha: .58);
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Material(
            color: Theme.of(sheetContext).cardColor,
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Custom Amount',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter how much water you drank',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      suffixText: 'ml',
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF4FAFF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final amount = int.tryParse(controller.text);
                        if (amount == null || amount <= 0) return;

                        final navigator = Navigator.of(sheetContext);

                        await HapticFeedback.lightImpact();
                        await onAddWater(amount);

                        navigator.pop();
                      },
                      child: const Text(
                        'Add Water',
                        style: TextStyle(
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
      },
    );
  }
}

class _QuickAddItem extends StatefulWidget {
  const _QuickAddItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.secondaryTextColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int? amount;
  final Color secondaryTextColor;
  final Future<void> Function() onTap;

  @override
  State<_QuickAddItem> createState() => _QuickAddItemState();
}

class _QuickAddItemState extends State<_QuickAddItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _feedbackOpacity;
  late final Animation<Offset> _feedbackOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _feedbackOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 45),
    ]).animate(_controller);

    _feedbackOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.75),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();

    if (widget.amount != null) {
      _controller.forward(from: 0);
    }

    widget.onTap().catchError((error) {
      debugPrint('Quick add error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: 70,
      child: Column(
        children: [
          SizedBox(
            width: 70,
            height: 66,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 54,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleTap,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      backgroundColor: widget.amount == null
                          ? Theme.of(
                              context,
                            ).dividerColor.withValues(alpha: .55)
                          : primaryColor.withValues(alpha: .11),
                      foregroundColor: primaryColor,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Icon(widget.icon, size: 24),
                  ),
                ),
                if (widget.amount != null)
                  Positioned(
                    top: -4,
                    child: IgnorePointer(
                      child: FadeTransition(
                        opacity: _feedbackOpacity,
                        child: SlideTransition(
                          position: _feedbackOffset,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: .24),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              '+${widget.amount} ml',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          if (widget.amount != null)
            Text(
              'ml',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: widget.secondaryTextColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _AmountGridTile extends StatelessWidget {
  const _AmountGridTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        onTap().catchError((error) {
          debugPrint('Amount tile error: $error');
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4FAFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withValues(alpha: .12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
