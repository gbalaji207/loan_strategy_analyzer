import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          icon: const Icon(Icons.arrow_back),
          label: Text(backLabel),
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
        ElevatedButton(
          onPressed: onContinuePressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(continueLabel),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      );
    }

    // If only continue button, align to the right
    MainAxisAlignment finalAlignment = alignment;
    if (!showBack && showContinue && (additionalButtons == null || additionalButtons!.isEmpty)) {
      finalAlignment = MainAxisAlignment.end;
    }

    return Row(
      mainAxisAlignment: finalAlignment,
      children: buttons,
    );
  }
}

