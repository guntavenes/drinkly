import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_icon_circle.dart';

class QuickAddSection extends StatelessWidget {
  const QuickAddSection({super.key, required this.onAddWater});

  final Future<void> Function(int amount) onAddWater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Add',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.lightText,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _QuickAddItem(
              icon: Icons.local_drink_outlined,
              label: '250',
              amount: 250,
              onTap: () => onAddWater(250),
            ),
            _QuickAddItem(
              icon: Icons.water_drop_outlined,
              label: '500',
              amount: 500,
              onTap: () => onAddWater(500),
            ),
            _QuickAddItem(
              icon: Icons.inventory_2_outlined,
              label: '750',
              amount: 750,
              onTap: () => onAddWater(750),
            ),
            _QuickAddItem(
              icon: Icons.add_rounded,
              label: 'More',
              amount: null,
              onTap: () => _showAddWaterSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddWaterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Add Water',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose how much water you drank',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                _WaterAmountTile(
                  amount: 100,
                  onTap: () {
                    Navigator.pop(context);
                    onAddWater(100);
                  },
                ),
                _WaterAmountTile(
                  amount: 250,
                  onTap: () {
                    Navigator.pop(context);
                    onAddWater(250);
                  },
                ),
                _WaterAmountTile(
                  amount: 500,
                  onTap: () {
                    Navigator.pop(context);
                    onAddWater(500);
                  },
                ),
                _WaterAmountTile(
                  amount: 1000,
                  onTap: () {
                    Navigator.pop(context);
                    onAddWater(1000);
                  },
                ),
              ],
            ),
          ),
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int? amount;
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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.lightText,
            ),
          ),
          if (amount != null)
            const Text(
              'ml',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

class _WaterAmountTile extends StatelessWidget {
  const _WaterAmountTile({required this.amount, required this.onTap});

  final int amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.water_drop_outlined, color: AppColors.primary),
      title: Text(
        '$amount ml',
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.lightText,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.lightTextSecondary,
      ),
    );
  }
}
