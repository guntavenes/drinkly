import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_icon_circle.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final amount in amounts.take(3))
              _QuickAddItem(
                icon: Icons.water_drop_outlined,
                label: '$amount',
                amount: amount,
                secondaryTextColor: secondaryTextColor,
                onTap: (_) => onAddWater(amount),
              ),
            _QuickAddItem(
              icon: Icons.add_rounded,
              label: 'More',
              amount: null,
              secondaryTextColor: secondaryTextColor,
              onTap: (_) => _showAddWaterSheet(context),
            ),
          ],
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
                              onTap: (itemContext) {
                                Navigator.pop(sheetContext);
                                _showCustomAmountDialog(context);
                              },
                            );
                          }

                          final amount = amounts[index];

                          return _AmountGridTile(
                            icon: Icons.water_drop_outlined,
                            title: '$amount ml',
                            onTap: (itemContext) async {
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
  final void Function(BuildContext itemContext) onTap;

  @override
  State<_QuickAddItem> createState() => _QuickAddItemState();
}

class _QuickAddItemState extends State<_QuickAddItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bubbleOpacity;
  late final Animation<double> _bubbleMove;
  late final Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _bubbleOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1, end: 1), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 45),
    ]).animate(_controller);

    _bubbleMove = Tween<double>(
      begin: 0,
      end: -34,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _iconScale = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 1, end: .92), weight: 25),
        TweenSequenceItem(tween: Tween(begin: .92, end: 1.06), weight: 35),
        TweenSequenceItem(tween: Tween(begin: 1.06, end: 1), weight: 40),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.amount != null) {
      _controller.forward(from: 0);
    }

    widget.onTap(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        children: [
          SizedBox(
            width: 68,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _iconScale.value,
                      child: child,
                    );
                  },
                  child: AppIconCircle(icon: widget.icon, onTap: _handleTap),
                ),
                if (widget.amount != null)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        top: 2 + _bubbleMove.value,
                        child: Opacity(
                          opacity: _bubbleOpacity.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        Text(
                          '${widget.amount} ml',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (widget.amount != null)
            Text(
              'ml',
              style: TextStyle(
                fontSize: 11,
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
  final void Function(BuildContext itemContext) onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4FAFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: .12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
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
