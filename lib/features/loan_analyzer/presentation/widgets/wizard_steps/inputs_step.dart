import 'package:flutter/material.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';

class InputsStep extends StatelessWidget {
  final VoidCallback onNext;
  final int currentStep;

  const InputsStep({
    super.key,
    required this.onNext,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLoanConfigSection(),
                    const SizedBox(height: 32),
                    _buildRateScheduleSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
        StickyNavigationFooter(
          child: NavigationButtons(
            showContinue: true,
            onContinuePressed: onNext,
          ),
        ),
      ],
    );
  }

  Widget _buildLoanConfigSection() {
    return _Section(
      title: '📊 LOAN CONFIGURATION',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount (₹)',
                    hintText: '3,000,000',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Tenure (Years)',
                    hintText: '30',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateScheduleSection() {
    return _Section(
      title: '💹 INTEREST RATE SCHEDULE',
      child: Column(
        children: [
          const Text('Rate schedule table will go here'),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Rate Change'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ],
    );
  }
}

