import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/loan_config.dart';
import 'loan_input_state.dart';

/// Cubit for managing loan input state and logic
class LoanInputCubit extends Cubit<LoanInputState> {
  LoanInputCubit() : super(LoanInputState.initial());

  // ============================================================================
  // LOAD FROM IMPORT (called by wizard page)
  // ============================================================================

  /// Load state from imported data (called during import)
  void loadFromImport(LoanInputState importedState) {
    emit(importedState);
  }

  // ============================================================================
  // LOAN CONFIGURATION
  // ============================================================================

  /// Update loan amount
  void updateLoanAmount(double amount) {
    final newConfig = state.loanConfig.copyWith(loanAmount: amount);
    _updateLoanConfig(newConfig);
  }

  /// Update loan tenure in months
  void updateLoanTenure(int months) {
    final newConfig = state.loanConfig.copyWith(tenureMonths: months);
    _updateLoanConfig(newConfig);
  }

  /// Update interest rate
  void updateInterestRate(double rate) {
    final newConfig = state.loanConfig.copyWith(interestRate: rate);
    _updateLoanConfig(newConfig);
  }

  void _updateLoanConfig(LoanConfig newConfig) {
    emit(
      state.copyWith(loanConfig: newConfig, status: LoanInputStatus.editing),
    );
    _validateAndUpdateStatus();
  }

  // ============================================================================
  // STRATEGY SELECTION
  // ============================================================================

  /// Toggle strategy selection
  void toggleStrategy(String strategyId) {
    final newSelection = state.strategySelection.toggleStrategy(strategyId);
    emit(
      state.copyWith(
        strategySelection: newSelection,
        status: LoanInputStatus.editing,
      ),
    );

    // If RD/FD strategy is selected, automatically enable RD/FD config
    if (newSelection.requiresRdFd && !state.rdFdConfig.isEnabled) {
      emit(
        state.copyWith(rdFdConfig: state.rdFdConfig.copyWith(isEnabled: true)),
      );
    }

    // If RD/FD strategy is deselected, disable RD/FD config
    if (!newSelection.requiresRdFd && state.rdFdConfig.isEnabled) {
      emit(
        state.copyWith(rdFdConfig: state.rdFdConfig.copyWith(isEnabled: false)),
      );
    }

    _validateAndUpdateStatus();
  }

  /// Select a strategy
  void selectStrategy(String strategyId) {
    final newSelection = state.strategySelection.addStrategy(strategyId);
    emit(
      state.copyWith(
        strategySelection: newSelection,
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  /// Deselect a strategy
  void deselectStrategy(String strategyId) {
    final newSelection = state.strategySelection.removeStrategy(strategyId);
    emit(
      state.copyWith(
        strategySelection: newSelection,
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  // ============================================================================
  // RD/FD CONFIGURATION
  // ============================================================================

  /// Toggle RD/FD enabled state
  void toggleRdFdEnabled(bool enabled) {
    emit(
      state.copyWith(
        rdFdConfig: state.rdFdConfig.copyWith(isEnabled: enabled),
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  /// Update RD months
  void updateRdMonths(int months) {
    final newRdConfig = state.rdFdConfig.rdConfig.copyWith(months: months);
    emit(
      state.copyWith(
        rdFdConfig: state.rdFdConfig.copyWith(rdConfig: newRdConfig),
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  /// Update RD interest rate
  void updateRdInterestRate(double rate) {
    final newRdConfig = state.rdFdConfig.rdConfig.copyWith(interestRate: rate);
    emit(
      state.copyWith(
        rdFdConfig: state.rdFdConfig.copyWith(rdConfig: newRdConfig),
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  /// Update FD months
  void updateFdMonths(int months) {
    final newFdConfig = state.rdFdConfig.fdConfig.copyWith(months: months);
    emit(
      state.copyWith(
        rdFdConfig: state.rdFdConfig.copyWith(fdConfig: newFdConfig),
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  /// Update FD interest rate
  void updateFdInterestRate(double rate) {
    final newFdConfig = state.rdFdConfig.fdConfig.copyWith(interestRate: rate);
    emit(
      state.copyWith(
        rdFdConfig: state.rdFdConfig.copyWith(fdConfig: newFdConfig),
        status: LoanInputStatus.editing,
      ),
    );
    _validateAndUpdateStatus();
  }

  // ============================================================================
  // TAX CONFIGURATION
  // ============================================================================

  /// Update tax slab percentage
  void updateTaxSlab(int percentage) {
    final newConfig = state.taxConfig.copyWith(taxSlabPercentage: percentage);
    emit(state.copyWith(taxConfig: newConfig, status: LoanInputStatus.editing));
    _validateAndUpdateStatus();
  }

  /// Update Section 80C eligibility
  void updateSection80c(double amount) {
    final newConfig = state.taxConfig.copyWith(section80cEligibility: amount);
    emit(state.copyWith(taxConfig: newConfig, status: LoanInputStatus.editing));
    _validateAndUpdateStatus();
  }

  /// Update Section 24(B) eligibility
  void updateSection24b(double amount) {
    final newConfig = state.taxConfig.copyWith(section24bEligibility: amount);
    emit(state.copyWith(taxConfig: newConfig, status: LoanInputStatus.editing));
    _validateAndUpdateStatus();
  }

  // ============================================================================
  // VALIDATION
  // ============================================================================

  /// Validate all inputs and update status
  void _validateAndUpdateStatus() {
    if (state.isValid) {
      emit(state.copyWith(status: LoanInputStatus.valid, errorMessage: null));
    } else {
      emit(
        state.copyWith(
          status: LoanInputStatus.invalid,
          errorMessage: _getValidationError(),
        ),
      );
    }
  }

  /// Get validation error message
  String? _getValidationError() {
    if (!state.loanConfig.isValid) {
      return 'Please complete loan configuration';
    }
    if (!state.strategySelection.hasSelection) {
      return 'Please select at least one strategy';
    }
    if (state.strategySelection.requiresRdFd) {
      if (!state.rdFdConfig.isEnabled) {
        return 'RD/FD configuration is required for the selected strategy';
      }
      if (!state.rdFdConfig.rdConfig.isValid) {
        return 'Please complete RD (Recurring Deposit) details';
      }
      if (!state.rdFdConfig.fdConfig.isValid) {
        return 'Please complete FD (Fixed Deposit) details';
      }
    }
    if (!state.taxConfig.isValid) {
      return 'Please select a valid tax slab';
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
    emit(LoanInputState.initial());
  }
}