import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/loan_analyzer/presentation/pages/loan_wizard_page.dart';
import '../../features/loan_analyzer/presentation/pages/strategy_details_page.dart';
import '../../features/loan_analyzer/presentation/pages/repayment_schedule_page.dart';
import '../../features/loan_analyzer/data/services/loan_calculation_service.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'wizard',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const LoanWizardPage(),
      ),
    ),
    GoRoute(
      path: '/results/details/:strategyId',
      name: RouteNames.strategyDetails,
      pageBuilder: (context, state) {
        final strategyId = state.pathParameters['strategyId']!;
        return _buildPageWithSlideTransition(
          context,
          state,
          StrategyDetailsPage(strategyId: strategyId),
        );
      },
    ),
    GoRoute(
      path: '/results/schedule/:strategyId',
      name: RouteNames.repaymentSchedule,
      pageBuilder: (context, state) {
        final strategyId = state.pathParameters['strategyId']!;
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return MaterialPage(
            key: state.pageKey,
            child: const Scaffold(
              body: Center(
                child: Text('Error: No schedule data available'),
              ),
            ),
          );
        }

        return _buildPageWithSlideTransition(
          context,
          state,
          RepaymentSchedulePage(
            strategyId: strategyId,
            schedule: extra['schedule'] as List<MonthlyPayment>,
            strategyName: extra['strategyName'] as String,
          ),
        );
      },
    ),
  ],
);

// Custom page transition with slide animation
Page<dynamic> _buildPageWithSlideTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
    ) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}