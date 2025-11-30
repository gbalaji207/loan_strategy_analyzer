import 'package:flutter/material.dart';
import '../core/router/app_router.dart';

class LoanAnalyzerApp extends StatelessWidget {
  const LoanAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Loan Strategy Analyzer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
