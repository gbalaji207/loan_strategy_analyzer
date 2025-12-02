import 'package:equatable/equatable.dart';

import '../../data/services/loan_calculation_service.dart';

/// Status of results calculation
enum ResultsStatus { initial, calculating, ready, error }

/// State for results step
class ResultsState extends Equatable {
  final ResultsStatus status;
  final StrategyComparisonResults? results;
  final String? errorMessage;

  const ResultsState({required this.status, this.results, this.errorMessage});

  factory ResultsState.initial() {
    return const ResultsState(status: ResultsStatus.initial);
  }

  factory ResultsState.calculating() {
    return const ResultsState(status: ResultsStatus.calculating);
  }

  factory ResultsState.ready(StrategyComparisonResults results) {
    return ResultsState(status: ResultsStatus.ready, results: results);
  }

  factory ResultsState.error(String message) {
    return ResultsState(status: ResultsStatus.error, errorMessage: message);
  }

  ResultsState copyWith({
    ResultsStatus? status,
    StrategyComparisonResults? results,
    String? errorMessage,
  }) {
    return ResultsState(
      status: status ?? this.status,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, errorMessage];
}
