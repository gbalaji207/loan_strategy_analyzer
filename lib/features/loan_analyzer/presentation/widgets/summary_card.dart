import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class SummaryCard extends StatelessWidget {
  final List<SummaryItem> items;
  final String? title;

  const SummaryCard({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlueSubtle,
            AppTheme.primaryBlueSubtle.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTheme.heading4.copyWith(
                  fontSize: 16,
                  color: AppTheme.primaryBlueDark,
                ),
              ),
              const SizedBox(height: AppTheme.space16),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items
                  .map((item) => Expanded(child: _buildItem(item)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(SummaryItem item) {
    return Column(
      children: [
        Text(
          item.label,
          style: AppTheme.labelMedium.copyWith(
            color: AppTheme.neutral600,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.space8),
        Text(
          item.value,
          style: AppTheme.heading3.copyWith(
            fontSize: 22,
            color: AppTheme.primaryBlueDark,
          ),
          textAlign: TextAlign.center,
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: AppTheme.space4),
          Text(
            item.subtitle!,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.neutral500,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class SummaryItem {
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

  const SummaryItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });
}
