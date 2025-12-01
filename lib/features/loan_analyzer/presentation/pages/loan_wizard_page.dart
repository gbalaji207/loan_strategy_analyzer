import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/page_header.dart';
import '../cubit/loan_input_cubit.dart';
import '../cubit/payment_plan_cubit.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/wizard_steps/inputs_step.dart';
import '../widgets/wizard_steps/payment_plan_step.dart';
import '../widgets/wizard_steps/results_step.dart';

class LoanWizardPage extends StatefulWidget {
  const LoanWizardPage({super.key});

  @override
  State<LoanWizardPage> createState() => _LoanWizardPageState();
}

class _LoanWizardPageState extends State<LoanWizardPage> {
  late PageController _pageController;
  int _currentStep = 1;
  Key _inputsStepKey = UniqueKey();
  Key _paymentPlanStepKey = UniqueKey();

  final _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentStep < 4) {
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentStep > 1) {
      _pageController.animateToPage(
        _currentStep - 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ============================================================================
  // EXPORT - Reads from both cubits
  // ============================================================================

  Future<void> _handleExport(BuildContext context) async {
    try {
      final loanInputCubit = context.read<LoanInputCubit>();
      final paymentPlanCubit = context.read<PaymentPlanCubit>();

      // Get current states from both cubits
      final loanInputState = loanInputCubit.state;
      final paymentPlanConfig = paymentPlanCubit.state.config;

      // Export both together
      await _storageService.exportConfiguration(
        loanInputState: loanInputState,
        paymentPlanConfig: paymentPlanConfig,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Configuration exported successfully!'),
              ],
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Export failed: $e')),
              ],
            ),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // ============================================================================
  // IMPORT - Updates both cubits
  // ============================================================================

  Future<void> _handleImport(BuildContext context) async {
    try {
      final loanInputCubit = context.read<LoanInputCubit>();
      final paymentPlanCubit = context.read<PaymentPlanCubit>();

      // Import configuration
      final imported = await _storageService.importConfiguration();

      if (imported != null && mounted) {
        // Update both cubits
        loanInputCubit.loadFromImport(imported.loanInputState);
        paymentPlanCubit.loadFromConfig(imported.paymentPlanConfig);

        // Force rebuild of both steps with new data
        setState(() {
          _inputsStepKey = UniqueKey();
          _paymentPlanStepKey = UniqueKey();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Configuration loaded successfully!'),
              ],
            ),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Import failed: $e')),
              ],
            ),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // ============================================================================
  // CLEAR - Resets both cubits
  // ============================================================================

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will clear all data and reset to default values. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();

              final loanInputCubit = context.read<LoanInputCubit>();
              final paymentPlanCubit = context.read<PaymentPlanCubit>();

              // Clear both cubits
              loanInputCubit.reset();
              paymentPlanCubit.reset();

              // Force rebuild of both steps with cleared data
              setState(() {
                _inputsStepKey = UniqueKey();
                _paymentPlanStepKey = UniqueKey();
              });

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('All data cleared successfully'),
                      ],
                    ),
                    backgroundColor: AppTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: 'Loan Strategy Analyzer',
            showBackButton: false,
            actions: [
              // Export button
              Tooltip(
                message: 'Export configuration to file',
                child: IconButton(
                  onPressed: () => _handleExport(context),
                  icon: const Icon(Icons.download_outlined),
                  style: IconButton.styleFrom(
                    foregroundColor: AppTheme.neutral700,
                    backgroundColor: AppTheme.neutral100,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Import button
              Tooltip(
                message: 'Import configuration from file',
                child: IconButton(
                  onPressed: () => _handleImport(context),
                  icon: const Icon(Icons.upload_outlined),
                  style: IconButton.styleFrom(
                    foregroundColor: AppTheme.neutral700,
                    backgroundColor: AppTheme.neutral100,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Clear all button
              Tooltip(
                message: 'Clear all data',
                child: IconButton(
                  onPressed: () => _showClearDialog(context),
                  icon: const Icon(Icons.delete_outline),
                  style: IconButton.styleFrom(
                    foregroundColor: AppTheme.accentRed,
                    backgroundColor: AppTheme.accentRedLight,
                  ),
                ),
              ),
            ],
          ),
          StepProgressIndicator(currentStep: _currentStep),
          const Divider(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index + 1;
                });
              },
              children: [
                InputsStep(
                  key: _inputsStepKey,
                  onNext: _goToNextPage,
                  currentStep: _currentStep,
                ),
                PaymentPlanStep(
                  key: _paymentPlanStepKey,
                  onNext: _goToNextPage,
                  onBack: _goToPreviousPage,
                  currentStep: _currentStep,
                ),
                ResultsStep(
                  onBack: _goToPreviousPage,
                  currentStep: _currentStep,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}