import 'package:equatable/equatable.dart';

/// Model for strategy selection
class StrategySelection extends Equatable {
  final Set<String> selectedStrategyIds;

  const StrategySelection({
    required this.selectedStrategyIds,
  });

  /// Default constructor with Strategy 1 (prepay_principal) selected
  const StrategySelection.initial()
      : selectedStrategyIds = const {'prepay_principal'};

  /// Empty constructor
  const StrategySelection.empty() : selectedStrategyIds = const {};

  /// Check if a strategy is selected
  bool isSelected(String strategyId) {
    return selectedStrategyIds.contains(strategyId);
  }

  /// Check if at least one strategy is selected
  bool get hasSelection => selectedStrategyIds.isNotEmpty;

  /// Get count of selected strategies
  int get count => selectedStrategyIds.length;

  /// Check if RD/FD configuration is needed
  bool get requiresRdFd => selectedStrategyIds.contains('regular_rdfd');

  /// Check if OD configuration is needed
  bool get requiresOd => selectedStrategyIds.contains('od_loan');

  /// Toggle a strategy selection
  StrategySelection toggleStrategy(String strategyId) {
    final newSelection = Set<String>.from(selectedStrategyIds);

    if (newSelection.contains(strategyId)) {
      newSelection.remove(strategyId);
    } else {
      newSelection.add(strategyId);
    }

    return StrategySelection(selectedStrategyIds: newSelection);
  }

  /// Add a strategy
  StrategySelection addStrategy(String strategyId) {
    final newSelection = Set<String>.from(selectedStrategyIds);
    newSelection.add(strategyId);
    return StrategySelection(selectedStrategyIds: newSelection);
  }

  /// Remove a strategy
  StrategySelection removeStrategy(String strategyId) {
    final newSelection = Set<String>.from(selectedStrategyIds);
    newSelection.remove(strategyId);
    return StrategySelection(selectedStrategyIds: newSelection);
  }

  /// Clear all selections
  StrategySelection clear() {
    return const StrategySelection.empty();
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedStrategyIds': selectedStrategyIds.toList(),
    };
  }

  /// Create from JSON
  factory StrategySelection.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ids = json['selectedStrategyIds'] as List<dynamic>;
    return StrategySelection(
      selectedStrategyIds: ids.map((e) => e.toString()).toSet(),
    );
  }

  StrategySelection copyWith({
    Set<String>? selectedStrategyIds,
  }) {
    return StrategySelection(
      selectedStrategyIds: selectedStrategyIds ?? this.selectedStrategyIds,
    );
  }

  @override
  List<Object?> get props => [selectedStrategyIds];
}