import 'package:equatable/equatable.dart';

/// Model for tax configuration
class TaxConfig extends Equatable {
  final int taxSlabPercentage;
  final double section80cEligibility;
  final double section24bEligibility;

  const TaxConfig({
    required this.taxSlabPercentage,
    required this.section80cEligibility,
    required this.section24bEligibility,
  });

  const TaxConfig.empty()
      : taxSlabPercentage = 0,
        section80cEligibility = 0,
        section24bEligibility = 0;

  /// Check if tax config is valid
  bool get isValid => taxSlabPercentage >= 0 && taxSlabPercentage <= 30;

  /// Get tax rate as decimal (e.g., 30% -> 0.30)
  double get taxRate => taxSlabPercentage / 100.0;

  /// Calculate tax savings on a given amount
  double calculateTaxSavings(double amount) {
    return amount * taxRate;
  }

  /// Calculate 80C tax benefit for principal payment
  double calculate80cBenefit(double principalPaid) {
    final eligibleAmount = principalPaid > section80cEligibility
        ? section80cEligibility
        : principalPaid;
    return calculateTaxSavings(eligibleAmount);
  }

  /// Calculate 24(B) tax benefit for interest payment
  double calculate24bBenefit(double interestPaid) {
    final eligibleAmount = interestPaid > section24bEligibility
        ? section24bEligibility
        : interestPaid;
    return calculateTaxSavings(eligibleAmount);
  }

  TaxConfig copyWith({
    int? taxSlabPercentage,
    double? section80cEligibility,
    double? section24bEligibility,
  }) {
    return TaxConfig(
      taxSlabPercentage: taxSlabPercentage ?? this.taxSlabPercentage,
      section80cEligibility:
      section80cEligibility ?? this.section80cEligibility,
      section24bEligibility:
      section24bEligibility ?? this.section24bEligibility,
    );
  }

  @override
  List<Object?> get props =>
      [taxSlabPercentage, section80cEligibility, section24bEligibility];
}