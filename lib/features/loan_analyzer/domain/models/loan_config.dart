import 'package:equatable/equatable.dart';

/// Model for basic loan configuration
class LoanConfig extends Equatable {
  final double loanAmount;
  final int tenureMonths;
  final double interestRate;

  const LoanConfig({
    required this.loanAmount,
    required this.tenureMonths,
    required this.interestRate,
  });

  /// Empty constructor for initial state
  const LoanConfig.empty() : loanAmount = 0, tenureMonths = 0, interestRate = 0;

  /// Check if config is valid
  bool get isValid => loanAmount > 0 && tenureMonths > 0 && interestRate > 0;

  /// Calculate monthly EMI
  double calculateEmi() {
    if (!isValid) return 0;

    final monthlyRate = interestRate / (12 * 100);
    final emi =
        loanAmount *
            monthlyRate *
            pow(1 + monthlyRate, tenureMonths) /
            (pow(1 + monthlyRate, tenureMonths) - 1);

    return emi;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'loanAmount': loanAmount,
      'tenureMonths': tenureMonths,
      'interestRate': interestRate,
    };
  }

  /// Create from JSON
  factory LoanConfig.fromJson(Map<String, dynamic> json) {
    return LoanConfig(
      loanAmount: (json['loanAmount'] as num).toDouble(),
      tenureMonths: json['tenureMonths'] as int,
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  }

  /// Copy with method
  LoanConfig copyWith({
    double? loanAmount,
    int? tenureMonths,
    double? interestRate,
  }) {
    return LoanConfig(
      loanAmount: loanAmount ?? this.loanAmount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  @override
  List<Object?> get props => [loanAmount, tenureMonths, interestRate];
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