import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../../../domain/strategy_definitions.dart';
import '../../cubit/loan_input_cubit.dart';
import '../../cubit/loan_input_state.dart';
import '../section.dart';
import '../strategy_card.dart';

class InputsStep extends StatefulWidget {
  final VoidCallback onNext;
  final int currentStep;

  const InputsStep({
    super.key,
    required this.onNext,
    required this.currentStep,
  });

  @override
  State<InputsStep> createState() => _InputsStepState();
}

class _InputsStepState extends State<InputsStep> {
  late TextEditingController _loanAmountController;
  late TextEditingController _tenureController;
  late TextEditingController _interestRateController;
  late TextEditingController _rdMonthsController;
  late TextEditingController _rdRateController;
  late TextEditingController _fdMonthsController;
  late TextEditingController _fdRateController;
  late TextEditingController _section80cController;
  late TextEditingController _section24bController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final state = context.read<LoanInputCubit>().state;

    _loanAmountController = TextEditingController(
      text: state.loanConfig.loanAmount > 0
          ? state.loanConfig.loanAmount.toStringAsFixed(0)
          : '',
    );

    _tenureController = TextEditingController(
      text: state.loanConfig.tenureMonths > 0
          ? state.loanConfig.tenureMonths.toString()
          : '',
    );

    _interestRateController = TextEditingController(
      text: state.loanConfig.interestRate > 0
          ? state.loanConfig.interestRate.toString()
          : '',
    );

    _rdMonthsController = TextEditingController(
      text: state.rdFdConfig.rdConfig.months > 0
          ? state.rdFdConfig.rdConfig.months.toString()
          : '',
    );

    _rdRateController = TextEditingController(
      text: state.rdFdConfig.rdConfig.interestRate > 0
          ? state.rdFdConfig.rdConfig.interestRate.toString()
          : '',
    );

    _fdMonthsController = TextEditingController(
      text: state.rdFdConfig.fdConfig.months > 0
          ? state.rdFdConfig.fdConfig.months.toString()
          : '',
    );

    _fdRateController = TextEditingController(
      text: state.rdFdConfig.fdConfig.interestRate > 0
          ? state.rdFdConfig.fdConfig.interestRate.toString()
          : '',
    );

    _section80cController = TextEditingController(
      text: state.taxConfig.section80cEligibility > 0
          ? state.taxConfig.section80cEligibility.toStringAsFixed(0)
          : '',
    );

    _section24bController = TextEditingController(
      text: state.taxConfig.section24bEligibility > 0
          ? state.taxConfig.section24bEligibility.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _tenureController.dispose();
    _interestRateController.dispose();
    _rdMonthsController.dispose();
    _rdRateController.dispose();
    _fdMonthsController.dispose();
    _fdRateController.dispose();
    _section80cController.dispose();
    _section24bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanInputCubit, LoanInputState>(
      buildWhen: (previous, current) {
        // Rebuild when strategies change (affects RD/FD section visibility)
        return previous.strategySelection != current.strategySelection;
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.space24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page title
                        Text('💡 Let\'s Get Started', style: AppTheme.heading2),
                        const SizedBox(height: AppTheme.space8),
                        Text(
                          'Share your loan details, investment preferences, and tax information to get started',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.neutral600,
                          ),
                        ),

                        const SizedBox(height: AppTheme.space40),

                        _buildLoanConfigSection(state),

                        const SizedBox(height: AppTheme.space32),

                        _buildStrategySelectionSection(state),

                        // Conditionally show RD/FD section
                        if (state.strategySelection.requiresRdFd) ...[
                          const SizedBox(height: AppTheme.space32),
                          _buildRdFdSection(state),
                        ],

                        const SizedBox(height: AppTheme.space32),

                        _buildTaxDetailsSection(state),

                        const SizedBox(height: AppTheme.space24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StickyNavigationFooter(
              child: NavigationButtons(
                showContinue: true,
                onContinuePressed: () => _handleContinue(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleContinue(BuildContext context) {
    final cubit = context.read<LoanInputCubit>();
    if (cubit.validateForm()) {
      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cubit.state.errorMessage ?? 'Please complete all required fields',
          ),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Widget _buildLoanConfigSection(LoanInputState state) {
    return Section(
      title: '📊 Loan Configuration',
      subtitle: 'Basic details about your loan',
      child: Column(
        children: [
          // Loan Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan Amount', style: AppTheme.labelLarge),
              const SizedBox(height: AppTheme.space8),
              TextField(
                controller: _loanAmountController,
                decoration: InputDecoration(
                  hintText: '30,00,000',
                  prefixText: '₹ ',
                  prefixStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.neutral600,
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: const Icon(
                    Icons.currency_rupee_rounded,
                    size: 18,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final amount = double.tryParse(value.replaceAll(',', '')) ?? 0;
                  context.read<LoanInputCubit>().updateLoanAmount(amount);
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Tenure and Interest Rate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Loan Tenure', style: AppTheme.labelLarge),
                    const SizedBox(height: AppTheme.space8),
                    TextField(
                      controller: _tenureController,
                      decoration: const InputDecoration(
                        hintText: '360',
                        suffixText: 'months',
                        suffixStyle: TextStyle(
                          color: AppTheme.neutral600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        final months = int.tryParse(value) ?? 0;
                        context.read<LoanInputCubit>().updateLoanTenure(months);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.space20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Interest Rate', style: AppTheme.labelLarge),
                    const SizedBox(height: AppTheme.space8),
                    TextField(
                      controller: _interestRateController,
                      decoration: const InputDecoration(
                        hintText: '8.5',
                        suffixText: '% p.a.',
                        suffixStyle: TextStyle(
                          color: AppTheme.neutral600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      onChanged: (value) {
                        final rate = double.tryParse(value) ?? 0;
                        context.read<LoanInputCubit>().updateInterestRate(rate);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Info card with calculated EMI
          BlocBuilder<LoanInputCubit, LoanInputState>(
            buildWhen: (previous, current) => previous.emi != current.emi,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlueSubtle,
                  borderRadius: AppTheme.borderRadiusMedium,
                  border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: AppTheme.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly EMI: ₹${state.emi > 0 ? state.emi.toStringAsFixed(2) : '0.00'}',
                            style: AppTheme.labelLarge.copyWith(
                              color: AppTheme.primaryBlueDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'These values will be used to calculate EMI and compare different repayment strategies',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryBlueDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStrategySelectionSection(LoanInputState state) {
    return Section(
      title: '🎯 Select Strategies to Compare',
      subtitle: 'Choose one or more repayment strategies to analyze',
      child: Column(
        children: [
          ...StrategyDefinitions.all.map((strategy) {
            final isSelected = state.strategySelection.isSelected(strategy.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.space16),
              child: StrategyCard(
                title: strategy.title,
                description: strategy.description,
                icon: strategy.icon,
                isSelected: isSelected,
                isEnabled: strategy.isEnabled,
                isComingSoon: strategy.isComingSoon,
                onChanged: (selected) {
                  if (!strategy.isRequired) {
                    context.read<LoanInputCubit>().toggleStrategy(strategy.id);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRdFdSection(LoanInputState state) {
    return Section(
      title: '💰 RD/FD Investment Details',
      subtitle:
      'Monthly surplus goes to RD, bonuses/incentives go to FD. Payment amounts can be set in the next step.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RD Details
          Container(
            padding: const EdgeInsets.all(AppTheme.space20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: AppTheme.borderRadiusLarge,
              border: Border.all(color: AppTheme.neutral200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space8),
                    Text(
                      'Recurring Deposit (RD)',
                      style: AppTheme.heading4.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Months', style: AppTheme.labelMedium),
                          const SizedBox(height: AppTheme.space8),
                          TextField(
                            controller: _rdMonthsController,
                            decoration: const InputDecoration(
                              hintText: '12',
                              suffixText: 'months',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              final months = int.tryParse(value) ?? 0;
                              context
                                  .read<LoanInputCubit>()
                                  .updateRdMonths(months);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.space16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Interest Rate', style: AppTheme.labelMedium),
                          const SizedBox(height: AppTheme.space8),
                          TextField(
                            controller: _rdRateController,
                            decoration: const InputDecoration(
                              hintText: '6.5',
                              suffixText: '% p.a.',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (value) {
                              final rate = double.tryParse(value) ?? 0;
                              context
                                  .read<LoanInputCubit>()
                                  .updateRdInterestRate(rate);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space12),
                // RD Note
                Container(
                  padding: const EdgeInsets.all(AppTheme.space12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlueSubtle,
                    borderRadius: AppTheme.borderRadiusMedium,
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.primaryBlue,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.space8),
                      Expanded(
                        child: Text(
                          'Once RD tenure is over, principal and accrued interest (after tax) will be added to FD account',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primaryBlueDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.space16),

          // FD Details
          Container(
            padding: const EdgeInsets.all(AppTheme.space20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: AppTheme.borderRadiusLarge,
              border: Border.all(color: AppTheme.neutral200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentOrange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppTheme.space8),
                    Text(
                      'Fixed Deposit (FD)',
                      style: AppTheme.heading4.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Months', style: AppTheme.labelMedium),
                          const SizedBox(height: AppTheme.space8),
                          TextField(
                            controller: _fdMonthsController,
                            decoration: const InputDecoration(
                              hintText: '60',
                              suffixText: 'months',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              final months = int.tryParse(value) ?? 0;
                              context
                                  .read<LoanInputCubit>()
                                  .updateFdMonths(months);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.space16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Interest Rate', style: AppTheme.labelMedium),
                          const SizedBox(height: AppTheme.space8),
                          TextField(
                            controller: _fdRateController,
                            decoration: const InputDecoration(
                              hintText: '7.0',
                              suffixText: '% p.a.',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (value) {
                              final rate = double.tryParse(value) ?? 0;
                              context
                                  .read<LoanInputCubit>()
                                  .updateFdInterestRate(rate);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.space12),
                // FD Note
                Container(
                  padding: const EdgeInsets.all(AppTheme.space12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrangeLight,
                    borderRadius: AppTheme.borderRadiusMedium,
                    border: Border.all(
                      color: AppTheme.accentOrange.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.accentOrange,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.space8),
                      Expanded(
                        child: Text(
                          'After tenure is over, principal and accrued interest (after tax) will be reinvested in FD again',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.neutral800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxDetailsSection(LoanInputState state) {
    return Section(
      title: '📋 Tax Details',
      subtitle: 'Tax benefits and eligibility for home loan deductions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income Tax Slab
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Income Tax Slab', style: AppTheme.labelLarge),
              const SizedBox(height: AppTheme.space8),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  hintText: 'Select your tax slab',
                ),
                value: state.taxConfig.taxSlabPercentage > 0
                    ? state.taxConfig.taxSlabPercentage
                    : null,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('No Tax (0%)')),
                  DropdownMenuItem(value: 5, child: Text('5%')),
                  DropdownMenuItem(value: 10, child: Text('10%')),
                  DropdownMenuItem(value: 15, child: Text('15%')),
                  DropdownMenuItem(value: 20, child: Text('20%')),
                  DropdownMenuItem(value: 25, child: Text('25%')),
                  DropdownMenuItem(value: 30, child: Text('30%')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<LoanInputCubit>().updateTaxSlab(value);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Section 80C Eligibility
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Section 80C Eligibility', style: AppTheme.labelLarge),
                  const SizedBox(width: AppTheme.space8),
                  Tooltip(
                    message:
                    'Maximum ₹1,50,000 deduction for principal repayment\nEnter remaining eligibility after other 80C investments',
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space8),
              TextField(
                controller: _section80cController,
                decoration: InputDecoration(
                  hintText: '1,50,000',
                  helperText: 'After deducting your other 80C investments',
                  helperStyle: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutral500,
                  ),
                  prefixText: '₹ ',
                  prefixStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.neutral600,
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: const Icon(
                    Icons.currency_rupee_rounded,
                    size: 18,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final amount =
                      double.tryParse(value.replaceAll(',', '')) ?? 0;
                  context.read<LoanInputCubit>().updateSection80c(amount);
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Section 24(B) Eligibility
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Section 24(B) Eligibility', style: AppTheme.labelLarge),
                  const SizedBox(width: AppTheme.space8),
                  Tooltip(
                    message:
                    'Maximum ₹2,00,000 deduction for interest payment\non self-occupied property',
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 16,
                      color: AppTheme.neutral500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.space8),
              TextField(
                controller: _section24bController,
                decoration: InputDecoration(
                  hintText: '2,00,000',
                  helperText: 'Maximum deduction for interest paid',
                  helperStyle: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutral500,
                  ),
                  prefixText: '₹ ',
                  prefixStyle: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.neutral600,
                    fontWeight: FontWeight.w600,
                  ),
                  suffixIcon: const Icon(
                    Icons.currency_rupee_rounded,
                    size: 18,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final amount =
                      double.tryParse(value.replaceAll(',', '')) ?? 0;
                  context.read<LoanInputCubit>().updateSection24b(amount);
                },
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Info card about tax benefits
          Container(
            padding: const EdgeInsets.all(AppTheme.space16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentGreenLight,
                  AppTheme.accentGreenLight.withOpacity(0.5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppTheme.borderRadiusMedium,
              border: Border.all(
                color: AppTheme.accentGreen.withOpacity(0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppTheme.accentGreen,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tax Benefits Summary',
                        style: AppTheme.labelLarge.copyWith(
                          color: AppTheme.accentGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '• 80C: Up to ₹1.5L on principal repayment\n'
                            '• 24(B): Up to ₹2L on interest payment\n'
                            '• Total potential savings based on your tax slab',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.neutral800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}