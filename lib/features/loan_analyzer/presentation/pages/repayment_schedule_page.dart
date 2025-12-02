import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/sticky_navigation_footer.dart';
import '../../../../shared/widgets/navigation_buttons.dart';
import '../../data/services/loan_calculation_service.dart';

class RepaymentSchedulePage extends StatelessWidget {
  final String strategyId;
  final List<MonthlyPayment> schedule;
  final String strategyName;

  const RepaymentSchedulePage({
    super.key,
    required this.strategyId,
    required this.schedule,
    required this.strategyName,
  });

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
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryBanner(),
                      const SizedBox(height: 24),
                      _buildTableSection(),
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
              backLabel: 'Back to Details',
              onBackPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return PageHeader(
      title: 'Repayment Schedule',
      onBackPressed: () => context.pop(),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlueSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
          ),
          child: Text(
            '${schedule.length} months',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryBlueDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.download_outlined),
          onPressed: () {
            // TODO: Implement CSV export
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('CSV export coming soon!')),
            );
          },
          tooltip: 'Export to CSV',
        ),
      ],
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlueSubtle,
            AppTheme.primaryBlueSubtle.withOpacity(0.5),
          ],
        ),
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.table_chart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategyName,
                      style: AppTheme.heading4.copyWith(
                        color: AppTheme.primaryBlueDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete month-by-month breakdown of your loan repayment',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryBlueDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppTheme.neutral200),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        children: [
          // Table header info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppTheme.neutral600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Scroll horizontally to view all columns. Year-end months are highlighted.',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutral700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable table
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 800;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppTheme.neutral100,
                    ),
                    headingRowHeight: 56,
                    dataRowMinHeight: isSmallScreen ? 48 : 44,
                    dataRowMaxHeight: isSmallScreen ? 56 : 52,
                    columnSpacing: isSmallScreen ? 16 : 24,
                    horizontalMargin: isSmallScreen ? 16 : 24,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Month',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'EMI',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Principal',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Interest',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Additional',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Tax Benefit',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: Text(
                          'Outstanding',
                          style: AppTheme.labelLarge.copyWith(fontSize: 13),
                        ),
                        numeric: true,
                      ),
                    ],
                    rows: schedule.asMap().entries.map((entry) {
                      final payment = entry.value;
                      final isYearEnd = payment.month % 12 == 0;
                      final textStyle = AppTheme.bodyMedium.copyWith(
                        fontSize: isSmallScreen ? 12 : 13,
                      );

                      return DataRow(
                        color: MaterialStateProperty.resolveWith<Color?>((
                          states,
                        ) {
                          if (isYearEnd) {
                            return AppTheme.accentGreenLight.withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return AppTheme.neutral50;
                          }
                          return null;
                        }),
                        cells: [
                          DataCell(
                            Text(
                              '${payment.month}',
                              style: textStyle.copyWith(
                                fontWeight: isYearEnd
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isYearEnd
                                    ? AppTheme.accentGreen
                                    : AppTheme.neutral900,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.emiAmount),
                              style: textStyle,
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.principalPayment),
                              style: textStyle,
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.interestPayment),
                              style: textStyle,
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.additionalPayment),
                              style: textStyle.copyWith(
                                color: payment.additionalPayment > 0
                                    ? AppTheme.accentGreen
                                    : AppTheme.neutral400,
                                fontWeight: payment.additionalPayment > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.taxBenefit),
                              style: textStyle.copyWith(
                                color: payment.taxBenefit > 0
                                    ? AppTheme.accentGreen
                                    : AppTheme.neutral400,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatAmount(payment.outstandingPrincipal),
                              style: textStyle.copyWith(
                                fontWeight: payment.outstandingPrincipal <= 0.01
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),

          // Legend at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreenLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.accentGreen.withOpacity(0.3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Year-end month',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.neutral700,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 20,
                      color: AppTheme.accentGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Additional payments',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.neutral700,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 20,
                      color: AppTheme.accentGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tax benefits',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.neutral700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
