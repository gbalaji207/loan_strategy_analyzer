import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';
import '../widgets/progress_indicator.dart';

class ResultsHubPage extends StatelessWidget {
  const ResultsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          const StepProgressIndicator(currentStep: 4),
          const Divider(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎯 YOUR STRATEGY RESULTS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildStrategyCards(context),
                      const SizedBox(height: 32),
                      _buildQuickComparison(),
                      const SizedBox(height: 24),
                      _buildComparisonButton(context),
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
      title: 'Results',
    );
  }

  Widget _buildStrategyCards(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _StrategyResultCard(
            strategyId: 'strategy1',
            title: 'STRATEGY 1: PREPAY PRINCIPAL',
            summaryItems: const [
              'Tenure: 287 months',
              'Time Saved: 6.1 years ✅',
              'Interest: ₹42.15L',
              'Net Cost: ₹42.15L',
            ],
            onViewDetails: () => context.go('/results/details/strategy1'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StrategyResultCard(
            strategyId: 'strategy2',
            title: 'STRATEGY 2: REGULAR + RD/FD',
            summaryItems: const [
              'Tenure: 360 months',
              'RD/FD Returns: ₹2.27L',
              'Interest: ₹47.40L',
              'Net Cost: ₹44.15L',
            ],
            onViewDetails: () => context.go('/results/details/strategy2'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 QUICK COMPARISON',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.green.shade50,
          elevation: 2,
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Strategy 1 is BETTER by ₹2,00,360 and 6.1 years! 🎉',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text('Key Differences:'),
                SizedBox(height: 8),
                Text('• Strategy 1 pays off faster (287 vs 360 months)'),
                Text('• Strategy 1 has lower net cost (₹42.15L vs ₹44.15L)'),
                Text('• Strategy 2 provides more liquidity (RD/FD accessible)'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.go('/results/comparison'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 48,
            vertical: 20,
          ),
        ),
        icon: const Icon(Icons.compare_arrows),
        label: const Text(
          'View Detailed Comparison',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return NavigationButtons(
      showBack: true,
      backLabel: 'Back',
      onBackPressed: () => context.pop(),
    );
  }
}

class _StrategyResultCard extends StatelessWidget {
  final String strategyId;
  final String title;
  final List<String> summaryItems;
  final VoidCallback onViewDetails;

  const _StrategyResultCard({
    required this.strategyId,
    required this.title,
    required this.summaryItems,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            const Text(
              'Quick Summary:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            ...summaryItems.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('• $item'),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.visibility),
                label: const Text('View Full Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}