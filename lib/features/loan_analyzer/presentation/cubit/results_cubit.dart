import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/loan_calculation_service.dart';
import '../cubit/loan_input_state.dart';
import '../cubit/payment_plan_state.dart';
import 'results_state.dart';

/// Cubit for managing results calculation
///
/// This cubit READS from LoanInputCubit and PaymentPlanCubit but does not
/// depend on them directly. The wizard page passes the required data.
class ResultsCubit extends Cubit<ResultsState> {
  ResultsCubit() : super(ResultsState.initial());

  /// Calculate results from loan input and payment plan states
  ///
  /// This is called by the wizard page when navigating to results step
  void calculateResults({
    required LoanInputState loanInputState,
    required PaymentPlanState paymentPlanState,
  }) {
    try {
      // Validate inputs
      if (!loanInputState.isValid) {
        emit(ResultsState.error('Invalid loan configuration'));
        return;
      }

      if (!paymentPlanState.isValid) {
        emit(ResultsState.error('Invalid payment plan'));
        return;
      }

      // Start calculation
      emit(ResultsState.calculating());

      // Delegate to calculation service (pure business logic)
      final results = LoanCalculationService.calculateAllStrategies(
        loanConfig: loanInputState.loanConfig,
        paymentPlanConfig: paymentPlanState.config,
        strategySelection: loanInputState.strategySelection,
        rdFdConfig: loanInputState.rdFdConfig,
        taxConfig: loanInputState.taxConfig,
      );

      // Emit ready state
      emit(ResultsState.ready(results));
    } catch (e) {
      emit(ResultsState.error('Failed to calculate results: $e'));
    }
  }

  /// Recalculate results (used when user changes inputs and comes back)
  void recalculate({
    required LoanInputState loanInputState,
    required PaymentPlanState paymentPlanState,
  }) {
    calculateResults(
      loanInputState: loanInputState,
      paymentPlanState: paymentPlanState,
    );
  }

  /// Reset results
  void reset() {
    emit(ResultsState.initial());
  }
}
