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
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                onTap: () => onAddWater(amount),
              ),
            _QuickAddItem(
              icon: Icons.add_rounded,
              label: 'More',
              amount: null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              onTap: () => _showAddWaterSheet(context),
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
                              onTap: () {
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
                              await HapticFeedback.lightImpact();
                              await onAddWater(amount);

                              if (sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
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

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Custom Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter amount',
              suffixText: 'ml',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = int.tryParse(controller.text);

                if (amount == null || amount <= 0) return;

                await HapticFeedback.lightImpact();
                await onAddWater(amount);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _QuickAddItem extends StatelessWidget {
  const _QuickAddItem({
    required this.icon,
    required this.label,
    required this.amount,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int? amount;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        children: [
          AppIconCircle(icon: icon, onTap: onTap),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          if (amount != null)
            Text(
              'ml',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
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
