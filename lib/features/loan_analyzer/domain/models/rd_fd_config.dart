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

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'interestRate': interestRate,
    };
  }

  factory RdConfig.fromJson(Map<String, dynamic> json) {
    return RdConfig(
      months: json['months'] as int,
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'months': months,
      'interestRate': interestRate,
    };
  }

  factory FdConfig.fromJson(Map<String, dynamic> json) {
    return FdConfig(
      months: json['months'] as int,
      interestRate: (json['interestRate'] as num).toDouble(),
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'rdConfig': rdConfig.toJson(),
      'fdConfig': fdConfig.toJson(),
    };
  }

  factory RdFdConfig.fromJson(Map<String, dynamic> json) {
    return RdFdConfig(
      isEnabled: json['isEnabled'] as bool,
      rdConfig: RdConfig.fromJson(json['rdConfig'] as Map<String, dynamic>),
      fdConfig: FdConfig.fromJson(json['fdConfig'] as Map<String, dynamic>),
    );
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