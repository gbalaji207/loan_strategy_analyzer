import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';
import '../../data/services/loan_calculation_service.dart';
import '../../domain/strategy_definitions.dart';
import '../cubit/results_cubit.dart';
import '../cubit/results_state.dart';
import '../widgets/section.dart';

class StrategyDetailsPage extends StatelessWidget {
  final String strategyId;

  const StrategyDetailsPage({super.key, required this.strategyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ResultsCubit, ResultsState>(
        builder: (context, state) {
          if (state.status != ResultsStatus.ready || state.results == null) {
            return _buildNoDataState(context);
          }

          final result = state.results!.strategies[strategyId];
          if (result == null) {
            return _buildNoDataState(context);
          }

          final strategyDef = StrategyDefinitions.getById(strategyId);
          final strategyName = strategyDef?.title ?? 'Strategy Details';

          return Column(
            children: [
              _buildHeader(context, strategyName),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHowItWorks(strategyDef),
                          const SizedBox(height: 32),
                          _buildSummaryCards(result),
                          const SizedBox(height: 32),
                          _buildKeyMetrics(result, state.results!),
                          const SizedBox(height: 32),
                          _buildPaymentBreakdown(result),
                          const SizedBox(height: 32),
                          _buildRepaymentSchedule(context, result),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              StickyNavigationFooter(child: _buildNavigationButtons(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          title: 'Strategy Details',
          onBackPressed: () => context.pop(),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 64, color: AppTheme.neutral400),
                const SizedBox(height: 16),
                Text(
                  'No calculation data available',
                  style: AppTheme.heading3.copyWith(color: AppTheme.neutral600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please go back and calculate results first',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.neutral500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String strategyName) {
    return PageHeader(
      title: strategyName,
      onBackPressed: () => context.pop(),
      actions: [
        IconButton(
          icon: const Icon(Icons.download_outlined),
          onPressed: () {
            // TODO: Implement export
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export coming soon!')),
            );
          },
          tooltip: 'Export Details',
        ),
      ],
    );
  }

  Widget _buildHowItWorks(StrategyDefinition? strategyDef) {
    if (strategyDef == null) return const SizedBox.shrink();

    return Section(
      title: '📖 How This Strategy Works',
      child: Text(strategyDef.description, style: AppTheme.bodyLarge),
    );
  }

  Widget _buildSummaryCards(StrategyResult result) {
    final cards = [
      _MetricCard(
        icon: Icons.calendar_month_outlined,
        label: 'Loan Tenure',
        value: '${result.tenureMonths} months',
        subtitle: '${result.tenureYears.toStringAsFixed(1)} years',
        color: AppTheme.primaryBlue,
      ),
      _MetricCard(
        icon: Icons.currency_rupee_rounded,
        label: 'Total Interest',
        value: '₹${_formatLakhs(result.totalInterestPaid)}',
        subtitle: 'Paid to bank',
        color: AppTheme.accentOrange,
      ),
      _MetricCard(
        icon: Icons.savings_outlined,
        label: 'Tax Benefits',
        value: '₹${_formatLakhs(result.totalTaxBenefits)}',
        subtitle: 'Total savings',
        color: AppTheme.accentGreen,
      ),
      _MetricCard(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Net Cost',
        value: '₹${_formatLakhs(result.netCost)}',
        subtitle: 'After tax benefits',
        color: AppTheme.primaryBlueDark,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid based on screen width
        if (constraints.maxWidth >= 1000) {
          // Desktop: 4 cards in a row
          return Row(
            children: cards
                .map((card) => Expanded(child: card))
                .toList()
                .fold<List<Widget>>(
                  [],
                  (list, widget) => list.isEmpty
                      ? [widget]
                      : [...list, const SizedBox(width: 16), widget],
                ),
          );
        } else if (constraints.maxWidth >= 600) {
          // Tablet: 2 cards per row
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        } else {
          // Mobile: 1 card per row
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: card,
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildKeyMetrics(
    StrategyResult result,
    StrategyComparisonResults allResults,
  ) {
    // Compare with regular EMI if available
    final regularEmi = allResults.strategies['regular_emi'];
    final hasComparison =
        regularEmi != null && result.strategyId != 'regular_emi';

    return Section(
      title: '📊 Key Metrics',
      child: Column(
        children: [
          _buildMetricRow(
            'Loan Amount',
            '₹${_formatLakhs(result.totalPrincipalPaid)}',
          ),
          const Divider(height: 24),
          _buildMetricRow('Total Months', '${result.tenureMonths} months'),
          const Divider(height: 24),
          _buildMetricRow(
            'Total Interest Paid',
            '₹${_formatLakhs(result.totalInterestPaid)}',
          ),
          const Divider(height: 24),
          _buildMetricRow(
            'Total Tax Benefits',
            '₹${_formatLakhs(result.totalTaxBenefits)}',
          ),
          const Divider(height: 24),
          _buildMetricRow(
            'Net Cost (Interest - Tax Benefits)',
            '₹${_formatLakhs(result.netCost)}',
            isHighlighted: true,
          ),

          if (hasComparison) ...[
            const Divider(height: 32),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentGreenLight.withOpacity(0.5),
                borderRadius: AppTheme.borderRadiusMedium,
              ),
              child: Text(
                'Compared to Regular EMI:',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow(
              'Time Saved',
              '${result.timeSavedYears(regularEmi.tenureMonths).toStringAsFixed(1)} years',
              Icons.timer_outlined,
            ),
            const Divider(height: 24),
            _buildComparisonRow(
              'Interest Saved',
              '₹${_formatLakhs(regularEmi.totalInterestPaid - result.totalInterestPaid)}',
              Icons.trending_down,
            ),
            const Divider(height: 24),
            _buildComparisonRow(
              'Net Savings',
              '₹${_formatLakhs(regularEmi.netCost - result.netCost)}',
              Icons.savings_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown(StrategyResult result) {
    // Calculate year-wise summary
    final yearlyData = _calculateYearlySummary(result.schedule);

    return Section(
      title: '📈 Year-wise Payment Breakdown',
      subtitle: 'Summary of payments by year',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;

          return Column(
            children: [
              if (isSmallScreen) ...[
                // Mobile: Show as cards
                ...yearlyData.map(
                  (data) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundSecondary,
                      borderRadius: AppTheme.borderRadiusMedium,
                      border: Border.all(color: AppTheme.neutral200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Year ${data['year']}',
                          style: AppTheme.heading4.copyWith(
                            fontSize: 16,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const Divider(height: 16),
                        _buildYearMetricRow('Principal', data['principal']),
                        const SizedBox(height: 8),
                        _buildYearMetricRow('Interest', data['interest']),
                        const SizedBox(height: 8),
                        _buildYearMetricRow('Tax Benefits', data['taxBenefit']),
                        const SizedBox(height: 8),
                        _buildYearMetricRow('Outstanding', data['outstanding']),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Desktop/Tablet: Show as table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppTheme.backgroundSecondary,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Year',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Principal Paid',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Interest Paid',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tax Benefits',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Outstanding',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: yearlyData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text('Year ${data['year']}')),
                          DataCell(
                            Text('₹${_formatAmount(data['principal'])}'),
                          ),
                          DataCell(Text('₹${_formatAmount(data['interest'])}')),
                          DataCell(
                            Text('₹${_formatAmount(data['taxBenefit'])}'),
                          ),
                          DataCell(
                            Text('₹${_formatAmount(data['outstanding'])}'),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildYearMetricRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutral600),
        ),
        Text(
          '₹${_formatAmount(value)}',
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRepaymentSchedule(BuildContext context, StrategyResult result) {
    return Section(
      title: '📈 Payment Visualization',
      subtitle: 'See how your payments are distributed over time',
      child: Column(
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlueSubtle,
                  AppTheme.primaryBlueSubtle.withOpacity(0.5),
                ],
              ),
              borderRadius: AppTheme.borderRadiusMedium,
              border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Visual representation of your loan repayment journey. '
                    'Click below to view the complete month-by-month schedule.',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Charts section
          _buildChartPlaceholder('Principal vs Interest Over Time'),

          const SizedBox(height: 24),

          _buildChartPlaceholder('Outstanding Balance Over Time'),

          const SizedBox(height: 32),

          // CTA Button to view complete schedule
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate using go_router with extra data
                context.push(
                  '/results/schedule/${result.strategyId}',
                  extra: {
                    'schedule': result.schedule,
                    'strategyName':
                        StrategyDefinitions.getById(result.strategyId)?.title ??
                        'Strategy',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: AppTheme.primaryBlue,
              ),
              icon: const Icon(Icons.table_chart_rounded, size: 20),
              label: const Text(
                'View Complete Repayment Schedule',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.labelLarge.copyWith(
            color: AppTheme.neutral800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppTheme.backgroundSecondary,
            borderRadius: AppTheme.borderRadiusLarge,
            border: Border.all(color: AppTheme.neutral200),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart_rounded,
                  size: 48,
                  color: AppTheme.neutral400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Chart will be displayed here',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.neutral500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Showing $title',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutral400,
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

  // Helper widgets
  Widget _buildMetricRow(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use vertical centered layout on small screens
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                  color: AppTheme.neutral700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTheme.heading3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted
                      ? AppTheme.primaryBlueDark
                      : AppTheme.neutral900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        // Use horizontal layout on larger screens
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: isHighlighted
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: AppTheme.neutral700,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Text(
              value,
              style: AppTheme.heading3.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isHighlighted
                    ? AppTheme.primaryBlueDark
                    : AppTheme.neutral900,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        );
      },
    );
  }

  Widget _buildComparisonRow(String label, String value, IconData icon) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Vertical center-aligned layout on small screens
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: AppTheme.accentGreen),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.neutral700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppTheme.heading3.copyWith(
                  fontSize: 20,
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        // Horizontal layout on larger screens
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppTheme.accentGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.neutral700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Text(
              value,
              style: AppTheme.heading3.copyWith(
                fontSize: 20,
                color: AppTheme.accentGreen,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  List<Map<String, dynamic>> _calculateYearlySummary(
    List<MonthlyPayment> schedule,
  ) {
    final yearlyData = <Map<String, dynamic>>[];
    int currentYear = 1;
    double yearPrincipal = 0;
    double yearInterest = 0;
    double yearTaxBenefit = 0;

    for (int i = 0; i < schedule.length; i++) {
      final payment = schedule[i];
      yearPrincipal += payment.principalPayment;
      yearInterest += payment.interestPayment;
      yearTaxBenefit += payment.taxBenefit;

      // At year end or last month
      if (payment.month % 12 == 0 || i == schedule.length - 1) {
        yearlyData.add({
          'year': currentYear,
          'principal': yearPrincipal,
          'interest': yearInterest,
          'taxBenefit': yearTaxBenefit,
          'outstanding': payment.outstandingPrincipal,
        });

        // Reset for next year
        currentYear++;
        yearPrincipal = 0;
        yearInterest = 0;
        yearTaxBenefit = 0;
      }
    }

    return yearlyData;
  }

  String _formatLakhs(double amount) {
    final lakhs = amount / 100000;
    return '${lakhs.toStringAsFixed(2)}L';
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)}L';
    }
    return amount.toStringAsFixed(0);
  }
}

// Metric Card Widget
class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 200;

        return Container(
          padding: EdgeInsets.all(isSmall ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppTheme.borderRadiusLarge,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppTheme.borderRadiusMedium,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: isSmall ? 18 : 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.neutral600,
                        fontSize: isSmall ? 10 : 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmall ? 12 : 16),
              Text(
                value,
                style: AppTheme.heading2.copyWith(
                  fontSize: isSmall ? 20 : 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.neutral500,
                  fontSize: isSmall ? 10 : 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
