import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
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
  bool _enableMonthlyStepUp = false;
  bool _enableYearlyStepUp = false;

  @override
  Widget build(BuildContext context) {
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
                    _buildPaymentInputs(),
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
            onContinuePressed: widget.onNext,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInputs() {
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
                ),
              ],
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
