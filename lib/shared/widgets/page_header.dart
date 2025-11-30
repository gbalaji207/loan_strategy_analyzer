import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final String? pageTitle;
  final String? pageSubtitle;

  const PageHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.pageTitle,
    this.pageSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space24,
        vertical: AppTheme.space16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.neutral200,
            width: 1,
          ),
        ),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBackPressed ?? () => context.pop(),
              tooltip: 'Back',
              style: IconButton.styleFrom(
                foregroundColor: AppTheme.neutral700,
                backgroundColor: AppTheme.neutral100,
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: AppTheme.space16),
          ],

          // Logo/Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppTheme.borderRadiusMedium,
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: AppTheme.space12),

          Text(
            title,
            style: AppTheme.heading3.copyWith(
              fontSize: 18,
              letterSpacing: -0.3,
            ),
          ),

          const Spacer(),

          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}