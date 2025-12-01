import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../../cubit/payment_plan_cubit.dart';
import '../../cubit/payment_plan_state.dart';
import '../section.dart';

class PaymentPlanStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;

  const PaymentPlanStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
  });

  @override
  State<PaymentPlanStep> createState() => _PaymentPlanStepState();
}

class _PaymentPlanStepState extends State<PaymentPlanStep> {
  // Text editing controllers
  final _additionalMonthlyController = TextEditingController();
  final _monthlyStepUpController = TextEditingController();
  final _additionalYearlyController = TextEditingController();
  final _yearlyStepUpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing state values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  void _initializeControllers() {
    final state = context.read<PaymentPlanCubit>().state;

    if (state.config.additionalMonthlyAmount > 0) {
      _additionalMonthlyController.text = state.config.additionalMonthlyAmount
          .toStringAsFixed(0);
    }
    if (state.config.monthlyStepUpPercentage > 0) {
      _monthlyStepUpController.text = state.config.monthlyStepUpPercentage
          .toString();
    }
    if (state.config.additionalYearlyAmount > 0) {
      _additionalYearlyController.text = state.config.additionalYearlyAmount
          .toStringAsFixed(0);
    }
    if (state.config.yearlyStepUpPercentage > 0) {
      _yearlyStepUpController.text = state.config.yearlyStepUpPercentage
          .toString();
    }
  }

  @override
  void dispose() {
    _additionalMonthlyController.dispose();
    _monthlyStepUpController.dispose();
    _additionalYearlyController.dispose();
    _yearlyStepUpController.dispose();
    super.dispose();
  }

  bool _enableMonthlyStepUp = false;
  bool _enableYearlyStepUp = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentPlanCubit, PaymentPlanState>(
      builder: (context, state) {
        // Sync local toggles with state
        _enableMonthlyStepUp = state.config.enableMonthlyStepUp;
        _enableYearlyStepUp = state.config.enableYearlyStepUp;

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
                        Text(
                          '💰 Configure Your Payment Plan',
                          style: AppTheme.heading2,
                        ),
                        const SizedBox(height: AppTheme.space8),
                        Text(
                          'Tell us how much extra you can contribute beyond your EMI',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.neutral600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.space32),
                        _buildPaymentInputs(context, state),
                        const SizedBox(height: AppTheme.space24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StickyNavigationFooter(
              child: NavigationButtons(
                showBack: true,
                onBackPressed: widget.onBack,
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
    final cubit = context.read<PaymentPlanCubit>();
    if (cubit.validateForm()) {
      widget.onNext();
    } else {
      if (cubit.state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(cubit.state.errorMessage!),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    }
  }

  Widget _buildPaymentInputs(BuildContext context, PaymentPlanState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Monthly contribution
        Section(
          title: '📆 Monthly Contribution',
          subtitle: 'Extra amount you can pay every month beyond your EMI',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Additional Monthly Amount', style: AppTheme.labelLarge),
              const SizedBox(height: AppTheme.space8),
              TextField(
                controller: _additionalMonthlyController,
                decoration: InputDecoration(
                  hintText: '1,000',
                  helperText: 'Amount beyond your regular EMI',
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
                  context
                      .read<PaymentPlanCubit>()
                      .updateAdditionalMonthlyAmount(amount);
                },
              ),
              const SizedBox(height: AppTheme.space20),

              // Monthly step-up toggle
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: _enableMonthlyStepUp
                      ? AppTheme.primaryBlueSubtle
                      : AppTheme.backgroundSecondary,
                  borderRadius: AppTheme.borderRadiusMedium,
                  border: Border.all(
                    color: _enableMonthlyStepUp
                        ? AppTheme.primaryBlue.withOpacity(0.3)
                        : AppTheme.neutral200,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Annual Step-Up',
                            style: AppTheme.labelLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Increase monthly contribution every year',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enableMonthlyStepUp,
                      onChanged: (value) {
                        setState(() {
                          _enableMonthlyStepUp = value;
                        });
                        context.read<PaymentPlanCubit>().toggleMonthlyStepUp(
                          value,
                        );
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ],
                ),
              ),

              if (_enableMonthlyStepUp) ...[
                const SizedBox(height: AppTheme.space16),
                Text('Annual Increase Percentage', style: AppTheme.labelLarge),
                const SizedBox(height: AppTheme.space8),
                TextField(
                  controller: _monthlyStepUpController,
                  decoration: const InputDecoration(
                    hintText: '10',
                    helperText: 'Percentage increase each year',
                    suffixText: '% per year',
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
                    final percentage = double.tryParse(value) ?? 0;
                    context
                        .read<PaymentPlanCubit>()
                        .updateMonthlyStepUpPercentage(percentage);
                  },
                ),
              ],

              const SizedBox(height: AppTheme.space16),

              // Info card
              Container(
                padding: const EdgeInsets.all(AppTheme.space12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreenLight,
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
                      size: 16,
                    ),
                    const SizedBox(width: AppTheme.space8),
                    Expanded(
                      child: Text(
                        'Tip: Even ₹1,000 extra per month can save lakhs in interest and reduce your loan tenure significantly!',
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

        const SizedBox(height: AppTheme.space24),

        // Yearly contribution
        Section(
          title: '📅 Yearly Contribution',
          subtitle:
              'Additional lump sum amount you can pay once a year (e.g., bonus, incentive)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Additional Yearly Amount', style: AppTheme.labelLarge),
              const SizedBox(height: AppTheme.space8),
              TextField(
                controller: _additionalYearlyController,
                decoration: InputDecoration(
                  hintText: '50,000',
                  helperText: 'One-time yearly payment (optional)',
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
                  context.read<PaymentPlanCubit>().updateAdditionalYearlyAmount(
                    amount,
                  );
                },
              ),
              const SizedBox(height: AppTheme.space20),

              // Yearly step-up toggle
              Container(
                padding: const EdgeInsets.all(AppTheme.space16),
                decoration: BoxDecoration(
                  color: _enableYearlyStepUp
                      ? AppTheme.primaryBlueSubtle
                      : AppTheme.backgroundSecondary,
                  borderRadius: AppTheme.borderRadiusMedium,
                  border: Border.all(
                    color: _enableYearlyStepUp
                        ? AppTheme.primaryBlue.withOpacity(0.3)
                        : AppTheme.neutral200,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Annual Step-Up',
                            style: AppTheme.labelLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Increase yearly contribution every year',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.neutral600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enableYearlyStepUp,
                      onChanged: (value) {
                        setState(() {
                          _enableYearlyStepUp = value;
                        });
                        context.read<PaymentPlanCubit>().toggleYearlyStepUp(
                          value,
                        );
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ],
                ),
              ),

              if (_enableYearlyStepUp) ...[
                const SizedBox(height: AppTheme.space16),
                Text('Annual Increase Percentage', style: AppTheme.labelLarge),
                const SizedBox(height: AppTheme.space8),
                TextField(
                  controller: _yearlyStepUpController,
                  decoration: const InputDecoration(
                    hintText: '5',
                    helperText: 'Percentage increase each year',
                    suffixText: '% per year',
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
                    final percentage = double.tryParse(value) ?? 0;
                    context
                        .read<PaymentPlanCubit>()
                        .updateYearlyStepUpPercentage(percentage);
                  },
                ),
              ],

              const SizedBox(height: AppTheme.space16),

              // Info card
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
                        'Common examples: Annual bonus, performance incentives, tax refunds, or festival bonuses',
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
    );
  }
}
