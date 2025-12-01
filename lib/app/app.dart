import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/loan_analyzer/presentation/cubit/loan_input_cubit.dart';
import '../features/loan_analyzer/presentation/cubit/payment_plan_cubit.dart';

class LoanAnalyzerApp extends StatelessWidget {
  const LoanAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoanInputCubit()),
        BlocProvider(create: (context) => PaymentPlanCubit()),
      ],
      child: MaterialApp.router(
        title: 'Loan Strategy Analyzer',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
