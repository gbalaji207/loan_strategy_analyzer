import 'package:flutter/material.dart';
import '../../../../shared/widgets/page_header.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PageHeader(
            title: 'Loan Strategy Analyzer',
            showBackButton: false,
            actions: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text('Load'),
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
                  onNext: _goToNextPage,
                  currentStep: _currentStep,
                ),
                PaymentPlanStep(
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

