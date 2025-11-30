import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/summary_card.dart';

class PaymentPlanPage extends StatelessWidget {
  const PaymentPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          const StepProgressIndicator(currentStep: 2),
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
                        '💰 Configure Your Monthly Payments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 32),
                      _buildSummary(),
                      const SizedBox(height: 32),
                      _buildPaymentSchedule(),
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
    return const PageHeader(
      title: 'Loan Strategy Analyzer',
      showBackButton: false,
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit),
          label: const Text('Set All to EMI'),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.money),
          label: const Text('Fixed Amount'),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload_file),
          label: const Text('Import CSV'),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.pattern),
          label: const Text('Apply Pattern'),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return const SummaryCard(
      items: [
        SummaryItem(label: 'Total Payments', value: '₹81,00,000'),
        SummaryItem(label: 'Avg Per Month', value: '₹22,500'),
        SummaryItem(label: 'Extra vs EMI', value: '₹3,60,000'),
      ],
    );
  }

  Widget _buildPaymentSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📅 PAYMENT SCHEDULE',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Payment schedule table will go here'),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Month')),
                    DataColumn(label: Text('Payment (₹)')),
                    DataColumn(label: Text('vs EMI')),
                    DataColumn(label: Text('Notes')),
                  ],
                  rows: List.generate(
                    5,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        const DataCell(Text('22,500')),
                        const DataCell(Text('+1,008')),
                        const DataCell(Text('Regular month')),
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
      onBackPressed: () => context.pop(),
      showContinue: true,
      onContinuePressed: () => context.go(RoutePaths.strategySelection),
    );
  }
}
