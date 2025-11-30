import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWinnerAnalysis(),
                      const SizedBox(height: 32),
                      _buildSideBySideMetrics(),
                      const SizedBox(height: 32),
                      _buildCharts(),
                      const SizedBox(height: 32),
                      _buildStrategyLinks(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StickyNavigationFooter(child: _buildNavigationButtons(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return PageHeader(
      title: 'Comparison',
      onBackPressed: () => context.pop(),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {},
          tooltip: 'Export',
        ),
      ],
    );
  }

  Widget _buildWinnerAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 WINNER ANALYSIS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.green.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Strategy 1 is BETTER by ₹2,00,360! 🎉',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('• You save ₹2,00,360 in net costs'),
                Text('• You become debt-free 6.1 years earlier'),
                Text('• Lower financial risk with faster payoff'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideBySideMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 SIDE-BY-SIDE METRICS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Metric')),
                DataColumn(label: Text('Strategy 1')),
                DataColumn(label: Text('Strategy 2')),
                DataColumn(label: Text('Diff')),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('Tenure')),
                    DataCell(Text('287 months ✅')),
                    DataCell(Text('360 months')),
                    DataCell(Text('-73')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Total Interest')),
                    DataCell(Text('₹42.15L ✅')),
                    DataCell(Text('₹47.40L')),
                    DataCell(Text('-5.2L')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('NET COST')),
                    DataCell(Text('₹42.15L ✅')),
                    DataCell(Text('₹44.15L')),
                    DataCell(Text('-2.0L')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📈 VISUAL COMPARISON',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Comparison charts will go here')),
        ),
      ],
    );
  }

  Widget _buildStrategyLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔍 EXPLORE STRATEGIES',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/strategies/details/strategy1'),
                child: const Text('View Strategy 1 Details'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/strategies/details/strategy2'),
                child: const Text('View Strategy 2 Details'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return NavigationButtons(
      showBack: true,
      backLabel: 'Back to Results',
      onBackPressed: () => context.pop(),
    );
  }
}
