import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A reusable section widget that provides consistent styling
/// for content sections throughout the app
class Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final List<Widget>? headerActions;

  const Section({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.headerActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section Header
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.heading3),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppTheme.space4),
                    Text(
                      subtitle!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (headerActions != null) ...headerActions!,
          ],
        ),

        const SizedBox(height: AppTheme.space16),

        // Section Content
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.backgroundPrimary,
            borderRadius: AppTheme.borderRadiusLarge,
            border: Border.all(color: AppTheme.neutral200, width: 1),
            boxShadow: AppTheme.shadowSmall,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.space24),
            child: child,
          ),
        ),
      ],
    );
  }
}

/// A lighter version of Section for less prominent content
class SectionLight extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SectionLight({
    super.key,
    this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(title!, style: AppTheme.heading4.copyWith(fontSize: 16)),
          const SizedBox(height: AppTheme.space12),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundSecondary,
            borderRadius: AppTheme.borderRadiusMedium,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.space16),
            child: child,
          ),
        ),
      ],
    );
  }
}
