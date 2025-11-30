import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

class LoanAnalyzerApp extends StatelessWidget {
  const LoanAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Loan Strategy Analyzer',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
