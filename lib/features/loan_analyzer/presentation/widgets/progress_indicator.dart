import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep; // 1, 2, 3, or 4

  const StepProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppTheme.space24,
        horizontal: AppTheme.space16,
      ),
      color: AppTheme.backgroundSecondary,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: [
              Expanded(
                child: _StepIndicator(
                  label: 'Inputs',
                  number: 1,
                  isActive: currentStep >= 1,
                  isComplete: currentStep > 1,
                ),
              ),
              _StepConnector(isActive: currentStep > 1),
              Expanded(
                child: _StepIndicator(
                  label: 'Payment Plan',
                  number: 2,
                  isActive: currentStep >= 2,
                  isComplete: currentStep > 2,
                ),
              ),
              _StepConnector(isActive: currentStep > 2),
              Expanded(
                child: _StepIndicator(
                  label: 'Strategies',
                  number: 3,
                  isActive: currentStep >= 3,
                  isComplete: currentStep > 3,
                ),
              ),
              _StepConnector(isActive: currentStep > 3),
              Expanded(
                child: _StepIndicator(
                  label: 'Results',
                  number: 4,
                  isActive: currentStep >= 4,
                  isComplete: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final int number;
  final bool isActive;
  final bool isComplete;

  const _StepIndicator({
    required this.label,
    required this.number,
    required this.isActive,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isComplete || isActive
                ? const LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: (!isComplete && !isActive) ? AppTheme.neutral200 : null,
            boxShadow: isActive && !isComplete
                ? [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isComplete
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 22,
                      key: ValueKey('check'),
                    )
                  : Text(
                      '$number',
                      key: ValueKey('number-$number'),
                      style: TextStyle(
                        color: isActive ? Colors.white : AppTheme.neutral500,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        Text(
          label,
          style: AppTheme.labelMedium.copyWith(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppTheme.neutral900 : AppTheme.neutral500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 34, left: 8, right: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
                )
              : null,
          color: !isActive ? AppTheme.neutral200 : null,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
