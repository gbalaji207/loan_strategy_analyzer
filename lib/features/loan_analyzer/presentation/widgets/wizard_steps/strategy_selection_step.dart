import 'package:flutter/material.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../strategy_card.dart';

class StrategySelectionStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const StrategySelectionStep({
    super.key,
    required this.onNext,
    required this.onBack,
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
                    const Text(
                      '📋 SELECT STRATEGIES TO ANALYZE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose one or more strategies to compare',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    StrategyCard(
                      title: 'Strategy 1: Prepay Principal',
                      description: 'Use extra payments to reduce principal, '
                          'shortening your loan tenure while keeping EMI constant.',
                      icon: Icons.trending_down,
                      isSelected: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    StrategyCard(
                      title: 'Strategy 2: Regular + RD/FD',
                      description: 'Pay regular EMI and invest excess cash in '
                          'RD/FD instruments to build a corpus.',
                      icon: Icons.account_balance,
                      isSelected: true,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),
                    StrategyCard(
                      title: 'Strategy 3: OD Loan',
                      description: 'Park funds in overdraft account to reduce '
                          'effective principal and interest.',
                      icon: Icons.sync_alt,
                      isSelected: false,
                      isEnabled: false,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
        StickyNavigationFooter(
          child: NavigationButtons(
            showBack: true,
            onBackPressed: onBack,
            showContinue: true,
            continueLabel: 'Calculate Strategies',
            onContinuePressed: onNext,
          ),
        ),
      ],
    );
  }
}

