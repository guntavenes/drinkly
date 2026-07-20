import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';

class HydrationSourcesScreen extends StatelessWidget {
  const HydrationSourcesScreen({super.key});

  static final Uri _efsaUri = Uri.parse(
    'https://www.efsa.europa.eu/en/efsajournal/pub/1459',
  );

  static final Uri _nationalAcademiesUri = Uri.parse(
    'https://www.nationalacademies.org/read/10925/chapter/6',
  );

  static final Uri _cdcUri = Uri.parse(
    'https://www.cdc.gov/healthy-weight-growth/water-healthy-drinks/index.html',
  );

  Future<void> _openSource(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Unable to open this source.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Hydration Sources',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              GlassCard(
                borderRadius: 26,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Health notice',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Drinkly provides general hydration tracking information '
                      'for educational and wellness purposes only. It does not '
                      'provide medical advice, diagnosis, or treatment.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hydration needs can vary based on age, sex, activity, '
                      'climate, pregnancy, breastfeeding, diet, health '
                      'conditions, and medication. Consult a qualified '
                      'healthcare professional for personal guidance.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sources',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 14),
              _SourceCard(
                title: 'European Food Safety Authority',
                subtitle: 'Dietary Reference Values for water',
                description:
                    'Scientific reference values concerning adequate total '
                    'water intake for population groups.',
                onTap: () => _openSource(context, _efsaUri),
              ),
              const SizedBox(height: 12),
              _SourceCard(
                title: 'National Academies',
                subtitle: 'Dietary Reference Intakes for Water',
                description:
                    'Reference information about total water intake, including '
                    'water from beverages and foods.',
                onTap: () => _openSource(context, _nationalAcademiesUri),
              ),
              const SizedBox(height: 12),
              _SourceCard(
                title: 'Centers for Disease Control and Prevention',
                subtitle: 'About Water and Healthier Drinks',
                description:
                    'General information about hydration and factors that can '
                    'affect daily water needs.',
                onTap: () => _openSource(context, _cdcUri),
              ),
              const SizedBox(height: 24),
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Drinkly’s suggested starting goal is a general tracking '
                  'estimate based on the profile information entered by the '
                  'user. It is not a clinical calculation and is not intended '
                  'to replace individualized medical advice.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: secondaryTextColor,
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

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: .58);

    return GlassCard(
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
