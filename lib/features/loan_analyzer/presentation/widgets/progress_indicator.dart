import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep; // 1, 2, 3, or 4

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StepIndicator(
            label: 'Inputs',
            number: 1,
            isActive: currentStep >= 1,
            isComplete: currentStep > 1,
          ),
          _StepConnector(isActive: currentStep > 1),
          _StepIndicator(
            label: 'Payment Plan',
            number: 2,
            isActive: currentStep >= 2,
            isComplete: currentStep > 2,
          ),
          _StepConnector(isActive: currentStep > 2),
          _StepIndicator(
            label: 'Select Strategies',
            number: 3,
            isActive: currentStep >= 3,
            isComplete: currentStep > 3,
          ),
          _StepConnector(isActive: currentStep > 3),
          _StepIndicator(
            label: 'Results',
            number: 4,
            isActive: currentStep >= 4,
            isComplete: false,
          ),
        ],
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
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete
                ? Colors.green
                : isActive
                ? Colors.blue
                : Colors.grey.shade300,
          ),
          child: Center(
            child: isComplete
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
              '$number',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey.shade600,
          ),
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
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.only(bottom: 30),
      color: isActive ? Colors.blue : Colors.grey.shade300,
    );
  }
}