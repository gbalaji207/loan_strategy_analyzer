import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../section.dart';

class InputsStep extends StatelessWidget {
  final VoidCallback onNext;
  final int currentStep;

  const InputsStep({
    super.key,
    required this.onNext,
    required this.currentStep,
  });

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
                    // Page title
                    Text('💡 Let\'s Get Started', style: AppTheme.heading2),
                    const SizedBox(height: AppTheme.space8),
                    Text(
                      'Enter your loan details to begin analyzing repayment strategies',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),

                    const SizedBox(height: AppTheme.space40),

                    _buildLoanConfigSection(),

                    const SizedBox(height: AppTheme.space32),

                    _buildRateScheduleSection(),

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
            onContinuePressed: onNext,
          ),
        ),
      ],
    );
  }

  Widget _buildLoanConfigSection() {
    return Section(
      title: '📊 Loan Configuration',
      subtitle: 'Basic details about your loan',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Loan Amount', style: AppTheme.labelLarge),
                    const SizedBox(height: AppTheme.space8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '3,000,000',
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
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.space20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Loan Tenure', style: AppTheme.labelLarge),
                    const SizedBox(height: AppTheme.space8),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: '30',
                        suffixText: 'years',
                        suffixStyle: TextStyle(
                          color: AppTheme.neutral600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space20),

          // Info card
          Container(
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
                  child: Text(
                    'These values will be used to calculate EMI and compare different repayment strategies',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateScheduleSection() {
    return Section(
      title: '💹 Interest Rate Schedule',
      subtitle: 'Define how your interest rate changes over time',
      headerActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add Rate Change'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space16,
              vertical: AppTheme.space12,
            ),
          ),
        ),
      ],
      child: Column(
        children: [
          // Sample rate entry
          _RateEntryRow(
            fromMonth: 1,
            toMonth: 12,
            rate: 7.75,
            onEdit: () {},
            onDelete: () {},
          ),

          const SizedBox(height: AppTheme.space12),

          _RateEntryRow(
            fromMonth: 13,
            toMonth: 360,
            rate: 8.25,
            onEdit: () {},
            onDelete: () {},
          ),

          const SizedBox(height: AppTheme.space20),

          // Add rate placeholder
          InkWell(
            onTap: () {},
            borderRadius: AppTheme.borderRadiusMedium,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.space16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.neutral300,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
                borderRadius: AppTheme.borderRadiusMedium,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppTheme.neutral500,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.space8),
                  Text(
                    'Add another rate period',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.neutral600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RateEntryRow extends StatelessWidget {
  final int fromMonth;
  final int toMonth;
  final double rate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RateEntryRow({
    required this.fromMonth,
    required this.toMonth,
    required this.rate,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundSecondary,
        borderRadius: AppTheme.borderRadiusMedium,
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Row(
        children: [
          // Period indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentOrange, Color(0xFFF59E0B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppTheme.borderRadiusMedium,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: AppTheme.space16),

          // Period details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Month $fromMonth - $toMonth', style: AppTheme.labelLarge),
                const SizedBox(height: AppTheme.space4),
                Text(
                  'Interest Rate: $rate% p.a.',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.neutral600,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            tooltip: 'Edit',
            style: IconButton.styleFrom(foregroundColor: AppTheme.neutral600),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            tooltip: 'Delete',
            style: IconButton.styleFrom(foregroundColor: AppTheme.accentRed),
          ),
        ],
      ),
    );
  }
}
