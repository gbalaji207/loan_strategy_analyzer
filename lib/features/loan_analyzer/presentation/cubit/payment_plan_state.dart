import 'package:equatable/equatable.dart';
import '../../domain/models/payment_plan_config.dart';

/// Status of the payment plan form
enum PaymentPlanStatus {
  initial,
  editing,
  valid,
  invalid,
}

/// State for payment plan step
class PaymentPlanState extends Equatable {
  final PaymentPlanStatus status;
  final PaymentPlanConfig config;
  final String? errorMessage;

  const PaymentPlanState({
    required this.status,
    required this.config,
    this.errorMessage,
  });

  /// Initial state
  factory PaymentPlanState.initial() {
    return const PaymentPlanState(
      status: PaymentPlanStatus.initial,
      config: PaymentPlanConfig.empty(),
    );
  }

  /// Check if all required fields are valid
  bool get isValid => config.isValid;

  /// Check if user has configured any additional payments
  bool get hasAdditionalPayments => config.hasAdditionalPayments;

  PaymentPlanState copyWith({
    PaymentPlanStatus? status,
    PaymentPlanConfig? config,
    String? errorMessage,
  }) {
    return PaymentPlanState(
      status: status ?? this.status,
      config: config ?? this.config,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, config, errorMessage];
}