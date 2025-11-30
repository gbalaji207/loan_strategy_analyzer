import 'package:flutter/material.dart';

/// Strategy definition model
class StrategyDefinition {
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final IconData icon;
  final bool isEnabled;
  final bool isRequired;
  final bool isComingSoon;
  final bool requiresRdFdConfig;
  final bool requiresOdConfig;

  const StrategyDefinition({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.icon,
    this.isEnabled = true,
    this.isRequired = false,
    this.isComingSoon = false,
    this.requiresRdFdConfig = false,
    this.requiresOdConfig = false,
  });
}

/// All available strategies
class StrategyDefinitions {
  static const List<StrategyDefinition> all = [
    StrategyDefinition(
      id: 'regular_emi',
      title: 'Strategy 0: Regular EMI Only',
      shortTitle: 'Regular EMI',
      description:
      'Pay only the standard EMI amount each month without any extra payments or investments.',
      icon: Icons.payments_outlined,
      isEnabled: true,
    ),
    StrategyDefinition(
      id: 'prepay_principal',
      title: 'Strategy 1: Prepay Principal',
      shortTitle: 'Prepay Principal',
      description:
      'Use extra payments to reduce principal, shortening your loan tenure while keeping EMI constant.',
      icon: Icons.trending_down,
      isRequired: true,
      isEnabled: true,
    ),
    StrategyDefinition(
      id: 'regular_rdfd',
      title: 'Strategy 2: Regular EMI + RD/FD',
      shortTitle: 'Regular + RD/FD',
      description:
      'Pay regular EMI and invest excess cash in RD/FD instruments. Monthly surplus goes to RD, lumpsum amounts (bonus/incentives) go to FD.',
      icon: Icons.account_balance,
      isEnabled: true,
      requiresRdFdConfig: true,
    ),
    StrategyDefinition(
      id: 'od_loan',
      title: 'Strategy 3: Overdraft (OD) Loan',
      shortTitle: 'OD Loan',
      description:
      'Park funds in overdraft account to reduce effective principal and interest.',
      icon: Icons.sync_alt,
      isEnabled: false,
      isComingSoon: true,
      requiresOdConfig: true,
    ),
  ];

  /// Get strategy by ID
  static StrategyDefinition? getById(String id) {
    try {
      return all.firstWhere((strategy) => strategy.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all enabled strategies
  static List<StrategyDefinition> getEnabled() {
    return all.where((strategy) => strategy.isEnabled).toList();
  }

  /// Get all required strategies
  static List<StrategyDefinition> getRequired() {
    return all.where((strategy) => strategy.isRequired).toList();
  }

  /// Check if any selected strategy requires RD/FD config
  static bool requiresRdFdConfig(List<String> selectedStrategyIds) {
    return all.any(
          (strategy) =>
      selectedStrategyIds.contains(strategy.id) &&
          strategy.requiresRdFdConfig,
    );
  }

  /// Check if any selected strategy requires OD config
  static bool requiresOdConfig(List<String> selectedStrategyIds) {
    return all.any(
          (strategy) =>
      selectedStrategyIds.contains(strategy.id) && strategy.requiresOdConfig,
    );
  }
}