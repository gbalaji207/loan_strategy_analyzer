import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/payment_plan_config.dart';
import 'payment_plan_state.dart';

/// Cubit for managing payment plan state and logic
class PaymentPlanCubit extends Cubit<PaymentPlanState> {
  PaymentPlanCubit() : super(PaymentPlanState.initial());

  // ============================================================================
  // MONTHLY PAYMENT CONFIGURATION
  // ============================================================================

  /// Update additional monthly amount
  void updateAdditionalMonthlyAmount(double amount) {
    final newConfig = state.config.copyWith(additionalMonthlyAmount: amount);
    _updateConfig(newConfig);
  }

  /// Toggle monthly step-up enabled
  void toggleMonthlyStepUp(bool enabled) {
    final newConfig = state.config.copyWith(enableMonthlyStepUp: enabled);
    _updateConfig(newConfig);
  }

  /// Update monthly step-up percentage
  void updateMonthlyStepUpPercentage(double percentage) {
    final newConfig =
    state.config.copyWith(monthlyStepUpPercentage: percentage);
    _updateConfig(newConfig);
  }

  // ============================================================================
  // YEARLY PAYMENT CONFIGURATION
  // ============================================================================

  /// Update additional yearly amount
  void updateAdditionalYearlyAmount(double amount) {
    final newConfig = state.config.copyWith(additionalYearlyAmount: amount);
    _updateConfig(newConfig);
  }

  /// Toggle yearly step-up enabled
  void toggleYearlyStepUp(bool enabled) {
    final newConfig = state.config.copyWith(enableYearlyStepUp: enabled);
    _updateConfig(newConfig);
  }

  /// Update yearly step-up percentage
  void updateYearlyStepUpPercentage(double percentage) {
    final newConfig = state.config.copyWith(yearlyStepUpPercentage: percentage);
    _updateConfig(newConfig);
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  void _updateConfig(PaymentPlanConfig newConfig) {
    emit(state.copyWith(
      config: newConfig,
      status: PaymentPlanStatus.editing,
    ));
    _validateAndUpdateStatus();
  }

  /// Validate all inputs and update status
  void _validateAndUpdateStatus() {
    if (state.isValid) {
      emit(state.copyWith(
        status: PaymentPlanStatus.valid,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: PaymentPlanStatus.invalid,
        errorMessage: _getValidationError(),
      ));
    }
  }

  /// Get validation error message
  String? _getValidationError() {
    if (!state.config.isValid) {
      if (state.config.enableMonthlyStepUp &&
          state.config.monthlyStepUpPercentage <= 0) {
        return 'Please enter a valid monthly step-up percentage';
      }
      if (state.config.enableYearlyStepUp &&
          state.config.yearlyStepUpPercentage <= 0) {
        return 'Please enter a valid yearly step-up percentage';
      }
      return 'Please check your payment plan configuration';
    }
    return null;
  }

  /// Validate form (can be called before proceeding to next step)
  bool validateForm() {
    _validateAndUpdateStatus();
    return state.isValid;
  }

  // ============================================================================
  // RESET
  // ============================================================================

  /// Reset to initial state
  void reset() {
    emit(PaymentPlanState.initial());
  }
}