import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../../../data/services/loan_calculation_service.dart';
import '../../../domain/strategy_definitions.dart';
import '../../cubit/loan_input_cubit.dart';
import '../../cubit/payment_plan_cubit.dart';
import '../../cubit/results_cubit.dart';
import '../../cubit/results_state.dart';
import '../section.dart';
import '../comparison_line_charts_widget.dart';

class ResultsStep extends StatefulWidget {
  final VoidCallback onBack;
  final int currentStep;

  const ResultsStep({
    super.key,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<ResultsStep> createState() => _ResultsStepState();
}

class _ResultsStepState extends State<ResultsStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateResults();
    });
  }

  void _calculateResults() {
    final loanInputState = context.read<LoanInputCubit>().state;
    final paymentPlanState = context.read<PaymentPlanCubit>().state;

    context.read<ResultsCubit>().calculateResults(
      loanInputState: loanInputState,
      paymentPlanState: paymentPlanState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ResultsCubit, ResultsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: _buildContent(state),
                  ),
                ),
              );
            },
          ),
        ),
        StickyNavigationFooter(
          child: NavigationButtons(
            showBack: true,
            backLabel: 'Back',
            onBackPressed: widget.onBack,
            additionalButtons: [
              TextButton.icon(
                onPressed: _calculateResults,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Recalculate'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ResultsState state) {
    switch (state.status) {
      case ResultsStatus.initial:
        return _buildInitialState();
      case ResultsStatus.calculating:
        return _buildCalculatingState();
      case ResultsStatus.error:
        return _buildErrorState(state.errorMessage ?? 'Unknown error');
      case ResultsStatus.ready:
        return _buildReadyState(state);
    }
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calculate_outlined, size: 64, color: AppTheme.neutral400),
          const SizedBox(height: 16),
          Text('Ready to calculate results',
              style: AppTheme.heading3.copyWith(color: AppTheme.neutral600)),
        ],
      ),
    );
  }

  Widget _buildCalculatingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text('Calculating strategies...', style: AppTheme.heading3),
          const SizedBox(height: 8),
          Text('This may take a moment',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutral600)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.accentRed),
          const SizedBox(height: 16),
          Text('Calculation Error',
              style: AppTheme.heading3.copyWith(color: AppTheme.accentRed)),
          const SizedBox(height: 8),
          Text(errorMessage,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutral600),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _calculateResults,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(ResultsState state) {
    final results = state.results!;
    final hasMultipleStrategies = results.strategies.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🎯 YOUR STRATEGY RESULTS',
            style: AppTheme.heading1.copyWith(fontSize: 28)),
        const SizedBox(height: 8),
        Text('Compare your selected strategies and choose the best option',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.neutral600)),
        const SizedBox(height: 32),

        // Strategy cards
        _buildStrategyCards(results),

        if (hasMultipleStrategies) ...[
          const SizedBox(height: 40),
          _buildWinnerAnalysis(results),
          const SizedBox(height: 40),
          _buildSideBySideComparison(results),
          const SizedBox(height: 40),
          _buildComparisonCharts(results),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStrategyCards(StrategyComparisonResults results) {
    final selectedStrategies = context
        .read<LoanInputCubit>()
        .state
        .strategySelection
        .selectedStrategyIds;

    final cards = selectedStrategies.map((strategyId) {
      final strategy = StrategyDefinitions.getById(strategyId);
      final result = results.strategies[strategyId];

      if (strategy == null || result == null) return null;

      return _StrategyResultCard(
        strategyId: strategyId,
        title: strategy.shortTitle,
        result: result,
        isBest: strategyId == results.comparisonMetrics.bestStrategyId,
        onViewDetails: () => context.push('/results/details/$strategyId'),
      );
    }).whereType<Widget>().toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final use2Columns = constraints.maxWidth >= 800;

        if (use2Columns && cards.length > 1) {
          final rows = <Widget>[];
          for (int i = 0; i < cards.length; i += 2) {
            rows.add(Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[i]),
                const SizedBox(width: 16),
                i + 1 < cards.length
                    ? Expanded(child: cards[i + 1])
                    : const Expanded(child: SizedBox.shrink()),
              ],
            ));
            if (i + 2 < cards.length) rows.add(const SizedBox(height: 16));
          }
          return Column(children: rows);
        } else {
          return Column(
            children: cards
                .map((card) => Padding(
                padding: const EdgeInsets.only(bottom: 16), child: card))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildWinnerAnalysis(StrategyComparisonResults results) {
    final bestStrategyId = results.comparisonMetrics.bestStrategyId;
    final bestStrategy = StrategyDefinitions.getById(bestStrategyId);
    final bestResult = results.strategies[bestStrategyId];
    final regularResult = results.strategies['regular_emi'];

    if (bestStrategy == null || bestResult == null) return const SizedBox.shrink();

    return Section(
      title: '🏆 Winner Analysis',
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentGreenLight,
              AppTheme.accentGreenLight.withOpacity(0.3),
            ],
          ),
          borderRadius: AppTheme.borderRadiusLarge,
          border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events_rounded,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${bestStrategy.shortTitle} is the BEST!',
                          style: AppTheme.heading2
                              .copyWith(fontSize: 22, color: AppTheme.accentGreen)),
                      const SizedBox(height: 4),
                      Text('Lowest net cost with optimal time savings',
                          style: AppTheme.bodyMedium
                              .copyWith(color: AppTheme.neutral700)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text('Key Highlights:',
                style: AppTheme.labelLarge
                    .copyWith(fontSize: 14, color: AppTheme.neutral800)),
            const SizedBox(height: 12),
            _buildHighlight(Icons.schedule_rounded, 'Tenure',
                '${bestResult.tenureMonths} months (${bestResult.tenureYears.toStringAsFixed(1)} years)'),
            const SizedBox(height: 8),
            _buildHighlight(Icons.currency_rupee_rounded, 'Net Cost',
                '₹${_formatLakhs(bestResult.netCost)}'),
            const SizedBox(height: 8),
            _buildHighlight(Icons.savings_outlined, 'Tax Benefits',
                '₹${_formatLakhs(bestResult.totalTaxBenefits)}'),
            if (regularResult != null && bestStrategyId != 'regular_emi') ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text('Compared to Regular EMI:',
                  style: AppTheme.labelLarge
                      .copyWith(fontSize: 14, color: AppTheme.neutral800)),
              const SizedBox(height: 12),
              _buildHighlight(Icons.timer_outlined, 'Time Saved',
                  '${bestResult.timeSavedYears(regularResult.tenureMonths).toStringAsFixed(1)} years'),
              const SizedBox(height: 8),
              _buildHighlight(Icons.trending_down, 'Cost Savings',
                  '₹${_formatLakhs(regularResult.netCost - bestResult.netCost)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHighlight(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.accentGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutral700)),
              Text(value,
                  style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold, color: AppTheme.neutral900)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideBySideComparison(StrategyComparisonResults results) {
    final strategies = results.strategies.entries.toList();

    return Section(
      title: '📊 Side-by-Side Comparison',
      subtitle: 'Detailed metrics for all selected strategies',
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppTheme.backgroundSecondary),
          columns: [
            const DataColumn(
                label:
                Text('Metric', style: TextStyle(fontWeight: FontWeight.bold))),
            ...strategies.map((entry) {
              final strategyDef = StrategyDefinitions.getById(entry.key);
              final isBest = entry.key == results.comparisonMetrics.bestStrategyId;
              return DataColumn(
                label: Row(
                  children: [
                    Text(strategyDef?.shortTitle ?? entry.key,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isBest ? AppTheme.accentGreen : null)),
                    if (isBest) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.emoji_events,
                          size: 16, color: AppTheme.accentGreen),
                    ],
                  ],
                ),
              );
            }),
          ],
          rows: [
            _buildComparisonRow('Tenure', strategies,
                    (result) => '${result.tenureMonths} months',
                findMin: true),
            _buildComparisonRow('Total Interest', strategies,
                    (result) => '₹${_formatLakhs(result.totalInterestPaid)}',
                findMin: true),
            _buildComparisonRow('Tax Benefits', strategies,
                    (result) => '₹${_formatLakhs(result.totalTaxBenefits)}',
                findMin: false),
            _buildComparisonRow('NET COST', strategies,
                    (result) => '₹${_formatLakhs(result.netCost)}',
                findMin: true, isHighlighted: true),
          ],
        ),
      ),
    );
  }

  DataRow _buildComparisonRow(String metric,
      List<MapEntry<String, StrategyResult>> strategies,
      String Function(StrategyResult) getValue,
      {bool findMin = true, bool isHighlighted = false}) {
    double? bestNumericValue;
    for (var entry in strategies) {
      final result = entry.value;
      double numericValue;

      if (metric == 'Tenure') {
        numericValue = result.tenureMonths.toDouble();
      } else if (metric == 'Total Interest') {
        numericValue = result.totalInterestPaid;
      } else if (metric == 'Tax Benefits') {
        numericValue = result.totalTaxBenefits;
      } else {
        numericValue = result.netCost;
      }

      if (bestNumericValue == null) {
        bestNumericValue = numericValue;
      } else if (findMin && numericValue < bestNumericValue) {
        bestNumericValue = numericValue;
      } else if (!findMin && numericValue > bestNumericValue) {
        bestNumericValue = numericValue;
      }
    }

    return DataRow(
      cells: [
        DataCell(Text(metric,
            style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500))),
        ...strategies.map((entry) {
          final result = entry.value;
          final value = getValue(result);

          double numericValue;
          if (metric == 'Tenure') {
            numericValue = result.tenureMonths.toDouble();
          } else if (metric == 'Total Interest') {
            numericValue = result.totalInterestPaid;
          } else if (metric == 'Tax Benefits') {
            numericValue = result.totalTaxBenefits;
          } else {
            numericValue = result.netCost;
          }

          final isBest = numericValue == bestNumericValue;

          return DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value,
                    style: TextStyle(
                        fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                        color: isBest ? AppTheme.accentGreen : null)),
                if (isBest) ...[
                  const SizedBox(width: 4),
                  const Text('✓', style: TextStyle(color: AppTheme.accentGreen)),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildComparisonCharts(StrategyComparisonResults results) {
    return Section(
      title: '📈 Strategy Comparison Over Time',
      subtitle: 'Interactive line charts showing progression and trends',
      child: ComparisonLineChartsWidget(results: results),
    );
  }

  String _formatLakhs(double amount) {
    return '${(amount / 100000).toStringAsFixed(2)}L';
  }
}

class _StrategyResultCard extends StatelessWidget {
  final String strategyId;
  final String title;
  final StrategyResult result;
  final bool isBest;
  final VoidCallback onViewDetails;

  const _StrategyResultCard({
    required this.strategyId,
    required this.title,
    required this.result,
    required this.isBest,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: isBest ? AppTheme.accentGreen : AppTheme.neutral200,
          width: isBest ? 2 : 1,
        ),
        boxShadow: isBest
            ? [
          BoxShadow(
            color: AppTheme.accentGreen.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : AppTheme.shadowSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title.toUpperCase(),
                      style: AppTheme.heading4.copyWith(
                          fontSize: 15,
                          color: isBest ? AppTheme.accentGreen : AppTheme.neutral900)),
                ),
                if (isBest)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('BEST',
                            style: AppTheme.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            const Text('Quick Summary:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 12),
            _buildMetric(
                '• Tenure: ${result.tenureMonths} months (${result.tenureYears.toStringAsFixed(1)} years)'),
            const SizedBox(height: 6),
            _buildMetric(
                '• Interest Paid: ₹${_formatLakhs(result.totalInterestPaid)}'),
            const SizedBox(height: 6),
            _buildMetric('• Tax Benefits: ₹${_formatLakhs(result.totalTaxBenefits)}'),
            const SizedBox(height: 6),
            _buildMetric('• Net Cost: ₹${_formatLakhs(result.netCost)}',
                isHighlighted: true),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('View Full Details'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isBest ? AppTheme.accentGreen : null,
                  side: BorderSide(
                      color: isBest ? AppTheme.accentGreen : AppTheme.neutral300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(String text, {bool isHighlighted = false}) {
    return Text(text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            color: isHighlighted ? AppTheme.primaryBlueDark : AppTheme.neutral700));
  }

  String _formatLakhs(double amount) {
    return '${(amount / 100000).toStringAsFixed(2)}L';
  }
}