import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StickyNavigationFooter extends StatelessWidget {
  final Widget child;

  const StickyNavigationFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        border: Border(top: BorderSide(color: AppTheme.neutral200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral900.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space24,
              vertical: AppTheme.space20,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
