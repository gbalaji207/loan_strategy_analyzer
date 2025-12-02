import '../../domain/models/loan_config.dart';
import '../../domain/models/payment_plan_config.dart';
import '../../domain/models/rd_fd_config.dart';
import '../../domain/models/strategy_selection.dart';
import '../../domain/models/tax_config.dart';

/// Pure calculation service for loan strategies
/// No state management - just pure functions that take inputs and return results
class LoanCalculationService {
  /// Calculate results for all selected strategies
  static StrategyComparisonResults calculateAllStrategies({
    required LoanConfig loanConfig,
    required PaymentPlanConfig paymentPlanConfig,
    required StrategySelection strategySelection,
    required RdFdConfig rdFdConfig,
    required TaxConfig taxConfig,
  }) {
    final strategies = <String, StrategyResult>{};

    // Calculate each selected strategy
    for (final strategyId in strategySelection.selectedStrategyIds) {
      switch (strategyId) {
        case 'regular_emi':
          strategies[strategyId] = _calculateRegularEmi(
            loanConfig: loanConfig,
            taxConfig: taxConfig,
          );
          break;
        case 'prepay_principal':
          strategies[strategyId] = _calculatePrepayPrincipal(
            loanConfig: loanConfig,
            paymentPlanConfig: paymentPlanConfig,
            taxConfig: taxConfig,
          );
          break;
        case 'regular_rdfd':
          strategies[strategyId] = _calculateRegularRdFd(
            loanConfig: loanConfig,
            paymentPlanConfig: paymentPlanConfig,
            rdFdConfig: rdFdConfig,
            taxConfig: taxConfig,
          );
          break;
        case 'od_loan':
        // Coming soon
          break;
      }
    }

    return StrategyComparisonResults(
      strategies: strategies,
      comparisonMetrics: _calculateComparisonMetrics(strategies),
    );
  }

  // ==========================================================================
  // STRATEGY 0: REGULAR EMI
  // ==========================================================================

  static StrategyResult _calculateRegularEmi({
    required LoanConfig loanConfig,
    required TaxConfig taxConfig,
  }) {
    final schedule = <MonthlyPayment>[];
    double outstandingPrincipal = loanConfig.loanAmount;
    final monthlyEmi = loanConfig.calculateEmi();
    final monthlyRate = loanConfig.interestRate / (12 * 100);

    for (int month = 1; month <= loanConfig.tenureMonths; month++) {
      final interestPayment = outstandingPrincipal * monthlyRate;
      final principalPayment = monthlyEmi - interestPayment;

      // Calculate tax benefits
      final taxBenefit = taxConfig.calculate80cBenefit(principalPayment) +
          taxConfig.calculate24bBenefit(interestPayment);

      schedule.add(MonthlyPayment(
        month: month,
        emiAmount: monthlyEmi,
        principalPayment: principalPayment,
        interestPayment: interestPayment,
        additionalPayment: 0,
        outstandingPrincipal: outstandingPrincipal - principalPayment,
        taxBenefit: taxBenefit,
      ));

      outstandingPrincipal -= principalPayment;
    }

    return StrategyResult(
      strategyId: 'regular_emi',
      tenureMonths: loanConfig.tenureMonths,
      totalInterestPaid: schedule.fold(0.0, (sum, p) => sum + p.interestPayment),
      totalPrincipalPaid: loanConfig.loanAmount,
      totalTaxBenefits: schedule.fold(0.0, (sum, p) => sum + p.taxBenefit),
      netCost: schedule.fold(0.0, (sum, p) => sum + p.interestPayment) -
          schedule.fold(0.0, (sum, p) => sum + p.taxBenefit),
      schedule: schedule,
    );
  }

  // ==========================================================================
  // STRATEGY 1: PREPAY PRINCIPAL
  // ==========================================================================

  static StrategyResult _calculatePrepayPrincipal({
    required LoanConfig loanConfig,
    required PaymentPlanConfig paymentPlanConfig,
    required TaxConfig taxConfig,
  }) {
    final schedule = <MonthlyPayment>[];
    double outstandingPrincipal = loanConfig.loanAmount;
    final monthlyEmi = loanConfig.calculateEmi();
    final monthlyRate = loanConfig.interestRate / (12 * 100);

    int month = 0;
    int year = 1;
    int monthInYear = 1;

    while (outstandingPrincipal > 0.01) {
      // Tolerance for floating point
      month++;

      // Calculate interest for this month
      final interestPayment = outstandingPrincipal * monthlyRate;

      // Regular EMI principal payment
      double principalPayment = monthlyEmi - interestPayment;

      // Additional monthly payment
      final additionalMonthly =
      paymentPlanConfig.calculateMonthlyPayment(year);

      // Additional yearly payment (applied in December)
      double additionalYearly = 0;
      if (monthInYear == 12) {
        additionalYearly = paymentPlanConfig.calculateYearlyPayment(year);
      }

      final totalAdditional = additionalMonthly + additionalYearly;

      // All additional payments go to principal
      principalPayment += totalAdditional;

      // Don't pay more than outstanding
      if (principalPayment > outstandingPrincipal) {
        principalPayment = outstandingPrincipal;
      }

      // Calculate tax benefits
      final taxBenefit = taxConfig.calculate80cBenefit(principalPayment) +
          taxConfig.calculate24bBenefit(interestPayment);

      schedule.add(MonthlyPayment(
        month: month,
        emiAmount: monthlyEmi,
        principalPayment: principalPayment,
        interestPayment: interestPayment,
        additionalPayment: totalAdditional,
        outstandingPrincipal: outstandingPrincipal - principalPayment,
        taxBenefit: taxBenefit,
      ));

      outstandingPrincipal -= principalPayment;

      // Increment month/year counters
      monthInYear++;
      if (monthInYear > 12) {
        monthInYear = 1;
        year++;
      }
    }

    return StrategyResult(
      strategyId: 'prepay_principal',
      tenureMonths: schedule.length,
      totalInterestPaid: schedule.fold(0.0, (sum, p) => sum + p.interestPayment),
      totalPrincipalPaid: loanConfig.loanAmount,
      totalTaxBenefits: schedule.fold(0.0, (sum, p) => sum + p.taxBenefit),
      netCost: schedule.fold(0.0, (sum, p) => sum + p.interestPayment) -
          schedule.fold(0.0, (sum, p) => sum + p.taxBenefit),
      schedule: schedule,
    );
  }

  // ==========================================================================
  // STRATEGY 2: REGULAR EMI + RD/FD
  // ==========================================================================

  static StrategyResult _calculateRegularRdFd({
    required LoanConfig loanConfig,
    required PaymentPlanConfig paymentPlanConfig,
    required RdFdConfig rdFdConfig,
    required TaxConfig taxConfig,
  }) {
    // TODO: Implement RD/FD calculation
    // This is complex - involves tracking RD maturity, FD rollovers, etc.
    // For now, return a placeholder
    return _calculateRegularEmi(loanConfig: loanConfig, taxConfig: taxConfig);
  }

  // ==========================================================================
  // COMPARISON METRICS
  // ==========================================================================

  static ComparisonMetrics _calculateComparisonMetrics(
      Map<String, StrategyResult> strategies,
      ) {
    if (strategies.isEmpty) {
      return ComparisonMetrics.empty();
    }

    // Find best strategy by net cost
    String? bestStrategyId;
    double? bestNetCost;

    for (final entry in strategies.entries) {
      if (bestNetCost == null || entry.value.netCost < bestNetCost) {
        bestNetCost = entry.value.netCost;
        bestStrategyId = entry.key;
      }
    }

    return ComparisonMetrics(
      bestStrategyId: bestStrategyId ?? '',
      bestByNetCost: bestStrategyId ?? '',
      bestByTenure: _findBestByTenure(strategies),
      bestByLiquidity: _findBestByLiquidity(strategies),
    );
  }

  static String _findBestByTenure(Map<String, StrategyResult> strategies) {
    String? bestId;
    int? shortestTenure;

    for (final entry in strategies.entries) {
      if (shortestTenure == null || entry.value.tenureMonths < shortestTenure) {
        shortestTenure = entry.value.tenureMonths;
        bestId = entry.key;
      }
    }

    return bestId ?? '';
  }

  static String _findBestByLiquidity(Map<String, StrategyResult> strategies) {
    // RD/FD strategy provides more liquidity
    if (strategies.containsKey('regular_rdfd')) {
      return 'regular_rdfd';
    }
    return strategies.keys.first;
  }
}

// ============================================================================
// RESULT MODELS
// ============================================================================

/// Monthly payment details
class MonthlyPayment {
  final int month;
  final double emiAmount;
  final double principalPayment;
  final double interestPayment;
  final double additionalPayment;
  final double outstandingPrincipal;
  final double taxBenefit;

  MonthlyPayment({
    required this.month,
    required this.emiAmount,
    required this.principalPayment,
    required this.interestPayment,
    required this.additionalPayment,
    required this.outstandingPrincipal,
    required this.taxBenefit,
  });
}

/// Result for a single strategy
class StrategyResult {
  final String strategyId;
  final int tenureMonths;
  final double totalInterestPaid;
  final double totalPrincipalPaid;
  final double totalTaxBenefits;
  final double netCost;
  final List<MonthlyPayment> schedule;

  StrategyResult({
    required this.strategyId,
    required this.tenureMonths,
    required this.totalInterestPaid,
    required this.totalPrincipalPaid,
    required this.totalTaxBenefits,
    required this.netCost,
    required this.schedule,
  });

  /// Get tenure in years (rounded)
  double get tenureYears => tenureMonths / 12;

  /// Time saved compared to regular tenure (in years)
  double timeSavedYears(int regularTenure) {
    return (regularTenure - tenureMonths) / 12;
  }
}

/// Comparison results for all strategies
class StrategyComparisonResults {
  final Map<String, StrategyResult> strategies;
  final ComparisonMetrics comparisonMetrics;

  StrategyComparisonResults({
    required this.strategies,
    required this.comparisonMetrics,
  });

  /// Get result for a specific strategy
  StrategyResult? getStrategy(String strategyId) => strategies[strategyId];

  /// Check if a strategy exists
  bool hasStrategy(String strategyId) => strategies.containsKey(strategyId);
}

/// Metrics for comparing strategies
class ComparisonMetrics {
  final String bestStrategyId;
  final String bestByNetCost;
  final String bestByTenure;
  final String bestByLiquidity;

  ComparisonMetrics({
    required this.bestStrategyId,
    required this.bestByNetCost,
    required this.bestByTenure,
    required this.bestByLiquidity,
  });

  factory ComparisonMetrics.empty() {
    return ComparisonMetrics(
      bestStrategyId: '',
      bestByNetCost: '',
      bestByTenure: '',
      bestByLiquidity: '',
    );
  }
}