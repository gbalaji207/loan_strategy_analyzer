import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class NavigationButtons extends StatelessWidget {
  final bool showBack;
  final String backLabel;
  final VoidCallback? onBackPressed;
  final bool showContinue;
  final String continueLabel;
  final VoidCallback? onContinuePressed;
  final MainAxisAlignment alignment;
  final List<Widget>? additionalButtons;

  const NavigationButtons({
    super.key,
    this.showBack = false,
    this.backLabel = 'Back',
    this.onBackPressed,
    this.showContinue = false,
    this.continueLabel = 'Continue',
    this.onContinuePressed,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.additionalButtons,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];

    // Add back button if needed
    if (showBack) {
      buttons.add(
        OutlinedButton.icon(
          onPressed: onBackPressed ?? () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: Text(backLabel),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space20,
              vertical: AppTheme.space16,
            ),
          ),
        ),
      );
    }

    // Add additional buttons if provided
    if (additionalButtons != null) {
      buttons.addAll(additionalButtons!);
    }

    // Add continue button if needed
    if (showContinue) {
      buttons.add(
        ElevatedButton.icon(
          onPressed: onContinuePressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space24,
              vertical: AppTheme.space16,
            ),
            elevation: 0,
            shadowColor: AppTheme.primaryBlue.withOpacity(0.3),
          ),
          label: Text(continueLabel),
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          iconAlignment: IconAlignment.end,
        ),
      );
    }

    // If only continue button, align to the right
    MainAxisAlignment finalAlignment = alignment;
    if (!showBack &&
        showContinue &&
        (additionalButtons == null || additionalButtons!.isEmpty)) {
      finalAlignment = MainAxisAlignment.end;
    }

    return Row(mainAxisAlignment: finalAlignment, children: buttons);
  }
}
