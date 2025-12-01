import 'package:equatable/equatable.dart';

/// Model for payment plan configuration
class PaymentPlanConfig extends Equatable {
  final double additionalMonthlyAmount;
  final bool enableMonthlyStepUp;
  final double monthlyStepUpPercentage;
  final double additionalYearlyAmount;
  final bool enableYearlyStepUp;
  final double yearlyStepUpPercentage;

  const PaymentPlanConfig({
    required this.additionalMonthlyAmount,
    required this.enableMonthlyStepUp,
    required this.monthlyStepUpPercentage,
    required this.additionalYearlyAmount,
    required this.enableYearlyStepUp,
    required this.yearlyStepUpPercentage,
  });

  /// Empty constructor for initial state
  const PaymentPlanConfig.empty()
      : additionalMonthlyAmount = 0,
        enableMonthlyStepUp = false,
        monthlyStepUpPercentage = 0,
        additionalYearlyAmount = 0,
        enableYearlyStepUp = false,
        yearlyStepUpPercentage = 0;

  /// Check if config is valid
  bool get isValid {
    // Monthly amount can be 0 (no additional payment)
    if (additionalMonthlyAmount < 0) return false;

    // If monthly step-up is enabled, percentage must be > 0
    if (enableMonthlyStepUp && monthlyStepUpPercentage <= 0) return false;

    // Yearly amount can be 0 (no yearly payment)
    if (additionalYearlyAmount < 0) return false;

    // If yearly step-up is enabled, percentage must be > 0
    if (enableYearlyStepUp && yearlyStepUpPercentage <= 0) return false;

    return true;
  }

  /// Check if any additional payments are configured
  bool get hasAdditionalPayments =>
      additionalMonthlyAmount > 0 || additionalYearlyAmount > 0;

  /// Calculate monthly payment for a given year
  double calculateMonthlyPayment(int year) {
    if (additionalMonthlyAmount == 0) return 0;

    if (!enableMonthlyStepUp || year <= 1) {
      return additionalMonthlyAmount;
    }

    // Apply step-up for years 2 onwards
    final yearsElapsed = year - 1;
    final growthFactor = pow(
      1 + (monthlyStepUpPercentage / 100),
      yearsElapsed,
    );

    return additionalMonthlyAmount * growthFactor;
  }

  /// Calculate yearly payment for a given year
  double calculateYearlyPayment(int year) {
    if (additionalYearlyAmount == 0) return 0;

    if (!enableYearlyStepUp || year <= 1) {
      return additionalYearlyAmount;
    }

    // Apply step-up for years 2 onwards
    final yearsElapsed = year - 1;
    final growthFactor = pow(
      1 + (yearlyStepUpPercentage / 100),
      yearsElapsed,
    );

    return additionalYearlyAmount * growthFactor;
  }

  /// Calculate total additional payment for a given year
  double calculateTotalForYear(int year) {
    final monthlyTotal = calculateMonthlyPayment(year) * 12;
    final yearlyTotal = calculateYearlyPayment(year);
    return monthlyTotal + yearlyTotal;
  }

  PaymentPlanConfig copyWith({
    double? additionalMonthlyAmount,
    bool? enableMonthlyStepUp,
    double? monthlyStepUpPercentage,
    double? additionalYearlyAmount,
    bool? enableYearlyStepUp,
    double? yearlyStepUpPercentage,
  }) {
    return PaymentPlanConfig(
      additionalMonthlyAmount:
      additionalMonthlyAmount ?? this.additionalMonthlyAmount,
      enableMonthlyStepUp: enableMonthlyStepUp ?? this.enableMonthlyStepUp,
      monthlyStepUpPercentage:
      monthlyStepUpPercentage ?? this.monthlyStepUpPercentage,
      additionalYearlyAmount:
      additionalYearlyAmount ?? this.additionalYearlyAmount,
      enableYearlyStepUp: enableYearlyStepUp ?? this.enableYearlyStepUp,
      yearlyStepUpPercentage:
      yearlyStepUpPercentage ?? this.yearlyStepUpPercentage,
    );
  }

  // ============================================================================
  // JSON SERIALIZATION
  // ============================================================================

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'additionalMonthlyAmount': additionalMonthlyAmount,
      'enableMonthlyStepUp': enableMonthlyStepUp,
      'monthlyStepUpPercentage': monthlyStepUpPercentage,
      'additionalYearlyAmount': additionalYearlyAmount,
      'enableYearlyStepUp': enableYearlyStepUp,
      'yearlyStepUpPercentage': yearlyStepUpPercentage,
    };
  }

  /// Create from JSON
  factory PaymentPlanConfig.fromJson(Map<String, dynamic> json) {
    return PaymentPlanConfig(
      additionalMonthlyAmount:
      (json['additionalMonthlyAmount'] as num?)?.toDouble() ?? 0,
      enableMonthlyStepUp: json['enableMonthlyStepUp'] as bool? ?? false,
      monthlyStepUpPercentage:
      (json['monthlyStepUpPercentage'] as num?)?.toDouble() ?? 0,
      additionalYearlyAmount:
      (json['additionalYearlyAmount'] as num?)?.toDouble() ?? 0,
      enableYearlyStepUp: json['enableYearlyStepUp'] as bool? ?? false,
      yearlyStepUpPercentage:
      (json['yearlyStepUpPercentage'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    additionalMonthlyAmount,
    enableMonthlyStepUp,
    monthlyStepUpPercentage,
    additionalYearlyAmount,
    enableYearlyStepUp,
    yearlyStepUpPercentage,
  ];
}

// Helper for pow function
num pow(num x, num exponent) {
  return x.toDouble().pow(exponent.toInt());
}

extension on double {
  double pow(int exponent) {
    if (exponent == 0) return 1.0;
    if (exponent == 1) return this;

    double result = 1.0;
    double base = this;
    int exp = exponent.abs();

    while (exp > 0) {
      if (exp % 2 == 1) {
        result *= base;
      }
      base *= base;
      exp ~/= 2;
    }

    return exponent < 0 ? 1.0 / result : result;
  }
}