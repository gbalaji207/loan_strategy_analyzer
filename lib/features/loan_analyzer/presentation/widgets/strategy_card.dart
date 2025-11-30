import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class StrategyCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isEnabled;
  final bool isComingSoon;
  final ValueChanged<bool?> onChanged;

  const StrategyCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.isEnabled = true,
    this.isComingSoon = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: isSelected ? AppTheme.primaryBlue : AppTheme.neutral200,
          width: isSelected ? 2 : 1.5,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : AppTheme.shadowSmall,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? () => onChanged(!isSelected) : null,
          borderRadius: AppTheme.borderRadiusLarge,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                      colors: [
                        AppTheme.primaryBlue,
                        AppTheme.primaryBlueDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: !isSelected
                        ? (isEnabled ? AppTheme.neutral100 : AppTheme.neutral50)
                        : null,
                    borderRadius: AppTheme.borderRadiusMedium,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isSelected
                        ? Colors.white
                        : (isEnabled
                        ? AppTheme.neutral600
                        : AppTheme.neutral400),
                  ),
                ),

                const SizedBox(width: AppTheme.space16),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTheme.heading4.copyWith(
                                fontSize: 16,
                                color: isEnabled
                                    ? AppTheme.neutral900
                                    : AppTheme.neutral400,
                              ),
                            ),
                          ),
                          if (isComingSoon) ...[
                            const SizedBox(width: AppTheme.space8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentOrange.withOpacity(0.1),
                                    AppTheme.accentOrange.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppTheme.accentOrange.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'COMING SOON',
                                style: AppTheme.bodySmall.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentOrange,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text(
                        description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: isEnabled
                              ? AppTheme.neutral600
                              : AppTheme.neutral400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppTheme.space16),

                // Checkbox
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: isEnabled ? onChanged : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: BorderSide(
                      color: isEnabled
                          ? AppTheme.neutral300
                          : AppTheme.neutral200,
                      width: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}