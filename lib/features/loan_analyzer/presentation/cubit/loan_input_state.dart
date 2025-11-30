import 'package:equatable/equatable.dart';
import '../../domain/models/loan_config.dart';
import '../../domain/models/rd_fd_config.dart';
import '../../domain/models/strategy_selection.dart';
import '../../domain/models/tax_config.dart';

/// Status of the loan input form
enum LoanInputStatus {
  initial,
  editing,
  valid,
  invalid,
}

/// State for loan input step
class LoanInputState extends Equatable {
  final LoanInputStatus status;
  final LoanConfig loanConfig;
  final StrategySelection strategySelection;
  final RdFdConfig rdFdConfig;
  final TaxConfig taxConfig;
  final String? errorMessage;

  const LoanInputState({
    required this.status,
    required this.loanConfig,
    required this.strategySelection,
    required this.rdFdConfig,
    required this.taxConfig,
    this.errorMessage,
  });

  /// Initial state
  factory LoanInputState.initial() {
    return const LoanInputState(
      status: LoanInputStatus.initial,
      loanConfig: LoanConfig.empty(),
      strategySelection: StrategySelection.initial(),
      rdFdConfig: RdFdConfig.empty(),
      taxConfig: TaxConfig.empty(),
    );
  }

  /// Check if all required fields are valid
  bool get isValid {
    // Loan config must be valid
    if (!loanConfig.isValid) return false;

    // At least one strategy must be selected
    if (!strategySelection.hasSelection) return false;

    // If RD/FD strategy is selected, config must be enabled and valid
    if (strategySelection.requiresRdFd) {
      if (!rdFdConfig.isEnabled || !rdFdConfig.isValid) {
        return false;
      }
    }

    // Tax config must be valid
    if (!taxConfig.isValid) return false;

    return true;
  }

  /// Calculate EMI based on current loan config
  double get emi => loanConfig.calculateEmi();

  LoanInputState copyWith({
    LoanInputStatus? status,
    LoanConfig? loanConfig,
    StrategySelection? strategySelection,
    RdFdConfig? rdFdConfig,
    TaxConfig? taxConfig,
    String? errorMessage,
  }) {
    return LoanInputState(
      status: status ?? this.status,
      loanConfig: loanConfig ?? this.loanConfig,
      strategySelection: strategySelection ?? this.strategySelection,
      rdFdConfig: rdFdConfig ?? this.rdFdConfig,
      taxConfig: taxConfig ?? this.taxConfig,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    loanConfig,
    strategySelection,
    rdFdConfig,
    taxConfig,
    errorMessage,
  ];
}