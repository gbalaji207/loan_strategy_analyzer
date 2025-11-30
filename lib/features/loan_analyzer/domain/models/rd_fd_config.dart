import 'package:equatable/equatable.dart';

/// Model for RD (Recurring Deposit) configuration
class RdConfig extends Equatable {
  final int months;
  final double interestRate;

  const RdConfig({
    required this.months,
    required this.interestRate,
  });

  const RdConfig.empty()
      : months = 0,
        interestRate = 0;

  bool get isValid => months > 0 && interestRate > 0;

  RdConfig copyWith({
    int? months,
    double? interestRate,
  }) {
    return RdConfig(
      months: months ?? this.months,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  @override
  List<Object?> get props => [months, interestRate];
}

/// Model for FD (Fixed Deposit) configuration
class FdConfig extends Equatable {
  final int months;
  final double interestRate;

  const FdConfig({
    required this.months,
    required this.interestRate,
  });

  const FdConfig.empty()
      : months = 0,
        interestRate = 0;

  bool get isValid => months > 0 && interestRate > 0;

  FdConfig copyWith({
    int? months,
    double? interestRate,
  }) {
    return FdConfig(
      months: months ?? this.months,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  @override
  List<Object?> get props => [months, interestRate];
}

/// Combined RD/FD configuration
class RdFdConfig extends Equatable {
  final bool isEnabled;
  final RdConfig rdConfig;
  final FdConfig fdConfig;

  const RdFdConfig({
    required this.isEnabled,
    required this.rdConfig,
    required this.fdConfig,
  });

  const RdFdConfig.empty()
      : isEnabled = false,
        rdConfig = const RdConfig.empty(),
        fdConfig = const FdConfig.empty();

  bool get isValid {
    // If not enabled, it's always valid
    if (!isEnabled) return true;

    // If enabled, both RD and FD configs must be valid
    return rdConfig.isValid && fdConfig.isValid;
  }

  RdFdConfig copyWith({
    bool? isEnabled,
    RdConfig? rdConfig,
    FdConfig? fdConfig,
  }) {
    return RdFdConfig(
      isEnabled: isEnabled ?? this.isEnabled,
      rdConfig: rdConfig ?? this.rdConfig,
      fdConfig: fdConfig ?? this.fdConfig,
    );
  }

  @override
  List<Object?> get props => [isEnabled, rdConfig, fdConfig];
}