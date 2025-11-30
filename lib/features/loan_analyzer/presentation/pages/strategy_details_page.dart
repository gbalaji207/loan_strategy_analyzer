import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';

class StrategyDetailsPage extends StatelessWidget {
  final String strategyId;

  const StrategyDetailsPage({super.key, required this.strategyId});

  @override
  Widget build(BuildContext context) {
    final strategyName = strategyId == 'strategy1'
        ? 'Strategy 1: Prepay Principal'
        : 'Strategy 2: Regular + RD/FD';

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context, strategyName),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHowItWorks(),
                      const SizedBox(height: 32),
                      _buildSummary(),
                      const SizedBox(height: 32),
                      _buildCharts(),
                      const SizedBox(height: 32),
                      _buildRepaymentSchedule(),
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

  Widget _buildHeader(BuildContext context, String strategyName) {
    return PageHeader(
      title: strategyName,
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {},
          tooltip: 'Export',
        ),
      ],
    );
  }

  Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📖 HOW THIS WORKS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              strategyId == 'strategy1'
                  ? 'This strategy uses extra payments to reduce principal, '
                        'shortening your loan tenure while keeping EMI constant.'
                  : 'This strategy pays regular EMI and invests excess cash in '
                        'RD/FD instruments to build a corpus while servicing the loan.',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 SUMMARY',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _SummaryRow(label: 'Loan Amount', value: '₹30,00,000'),
                _SummaryRow(label: 'Regular Tenure', value: '360 months'),
                _SummaryRow(
                  label: 'Reduced Tenure',
                  value: strategyId == 'strategy1'
                      ? '287 months ✨'
                      : '360 months',
                ),
                _SummaryRow(
                  label: 'Time Saved',
                  value: strategyId == 'strategy1' ? '6.1 years' : '-',
                ),
                _SummaryRow(label: 'Total Interest', value: '₹42,15,000'),
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
          '📈 CHARTS',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(child: Text('Charts will go here')),
        ),
      ],
    );
  }

  Widget _buildRepaymentSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📅 REPAYMENT SCHEDULE',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Repayment schedule table will go here'),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Month')),
                    DataColumn(label: Text('Payment')),
                    DataColumn(label: Text('Interest')),
                    DataColumn(label: Text('Principal')),
                    DataColumn(label: Text('Outstanding')),
                  ],
                  rows: List.generate(
                    5,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        const DataCell(Text('22,500')),
                        const DataCell(Text('19,375')),
                        const DataCell(Text('3,125')),
                        const DataCell(Text('2,996,875')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return NavigationButtons(
      showBack: true,
      backLabel: 'Back to Results',
      onBackPressed: () => context.pop(),
      alignment: MainAxisAlignment.center,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
