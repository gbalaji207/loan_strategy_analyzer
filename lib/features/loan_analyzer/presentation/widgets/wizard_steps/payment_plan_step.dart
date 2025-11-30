import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/navigation_buttons.dart';
import '../../../../../shared/widgets/sticky_navigation_footer.dart';
import '../section.dart';
import '../summary_card.dart';

class PaymentPlanStep extends StatelessWidget {
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
                      '💰 Configure Your Monthly Payments',
                      style: AppTheme.heading2,
                    ),
                    const SizedBox(height: AppTheme.space8),
                    Text(
                      'Set up your monthly payment schedule. Pay more than EMI to save on interest.',
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),

                    const SizedBox(height: AppTheme.space32),

                    _buildQuickActions(),

                    const SizedBox(height: AppTheme.space24),

                    _buildSummary(),

                    const SizedBox(height: AppTheme.space32),

                    _buildPaymentSchedule(),

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
            onBackPressed: onBack,
            showContinue: true,
            onContinuePressed: onNext,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.neutral50,
            AppTheme.backgroundPrimary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppTheme.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: AppTheme.accentOrange,
                size: 20,
              ),
              const SizedBox(width: AppTheme.space8),
              Text(
                'Quick Actions',
                style: AppTheme.heading4.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space16),
          Wrap(
            spacing: AppTheme.space12,
            runSpacing: AppTheme.space12,
            children: [
              _QuickActionButton(
                icon: Icons.edit_outlined,
                label: 'Set All to EMI',
                onPressed: () {},
              ),
              _QuickActionButton(
                icon: Icons.payments_outlined,
                label: 'Fixed Amount',
                onPressed: () {},
              ),
              _QuickActionButton(
                icon: Icons.upload_file_outlined,
                label: 'Import CSV',
                onPressed: () {},
              ),
              _QuickActionButton(
                icon: Icons.pattern_outlined,
                label: 'Apply Pattern',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return const SummaryCard(
      title: '📊 Payment Summary',
      items: [
        SummaryItem(
          label: 'TOTAL PAYMENTS',
          value: '₹81.0L',
          subtitle: '360 months',
        ),
        SummaryItem(
          label: 'AVG PER MONTH',
          value: '₹22,500',
          subtitle: 'Above EMI',
        ),
        SummaryItem(
          label: 'EXTRA vs EMI',
          value: '₹3.6L',
          subtitle: 'Total extra',
        ),
      ],
    );
  }

  Widget _buildPaymentSchedule() {
    return Section(
      title: '📅 Payment Schedule',
      subtitle: 'Monthly payment breakdown for your loan tenure',
      headerActions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, size: 20),
          tooltip: 'Export Schedule',
          style: IconButton.styleFrom(
            foregroundColor: AppTheme.neutral600,
          ),
        ),
      ],
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space16,
              vertical: AppTheme.space12,
            ),
            decoration: BoxDecoration(
              color: AppTheme.backgroundSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Month', style: AppTheme.labelMedium),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Payment (₹)', style: AppTheme.labelMedium),
                ),
                Expanded(
                  flex: 2,
                  child: Text('vs EMI', style: AppTheme.labelMedium),
                ),
                Expanded(
                  flex: 4,
                  child: Text('Notes', style: AppTheme.labelMedium),
                ),
                const SizedBox(width: 40), // Actions column
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // Table rows
          ...List.generate(
            5,
                (index) => _PaymentRow(
              month: index + 1,
              payment: 22500,
              vsEmi: 1008,
              notes: 'Regular month',
            ),
          ),

          const SizedBox(height: AppTheme.space16),

          // Show more button
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.expand_more_rounded, size: 18),
            label: const Text('Show All 360 Months'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space12,
        ),
        backgroundColor: AppTheme.backgroundPrimary,
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final int month;
  final double payment;
  final double vsEmi;
  final String notes;

  const _PaymentRow({
    required this.month,
    required this.payment,
    required this.vsEmi,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.neutral100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$month',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '₹${payment.toStringAsFixed(0)}',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentGreenLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '+₹${vsEmi.toStringAsFixed(0)}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              notes,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutral600,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: AppTheme.neutral500,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Text('Duplicate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}