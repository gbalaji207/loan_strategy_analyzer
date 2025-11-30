import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/strategy_card.dart';

class StrategySelectionPage extends StatelessWidget {
  const StrategySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          const StepProgressIndicator(currentStep: 3),
          const Divider(),

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
            child: _buildNavigationButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const PageHeader(
      title: 'Select Strategies',
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return NavigationButtons(
      showBack: true,
      onBackPressed: () => context.pop(),
      showContinue: true,
      continueLabel: 'Calculate Strategies',
      onContinuePressed: () => context.go(RoutePaths.resultsHub),
    );
  }
}