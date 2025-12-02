import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/services/loan_calculation_service.dart';
import '../../domain/strategy_definitions.dart';

/// Comprehensive line charts for strategy comparison over time
class ComparisonLineChartsWidget extends StatelessWidget {
  final StrategyComparisonResults results;

  const ComparisonLineChartsWidget({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Charts (Most Important)
        _buildOutstandingBalanceChart(),
        const SizedBox(height: 32),
        _buildCumulativeInterestChart(),

        const SizedBox(height: 32),

        // Secondary Charts (Additional Insights)
        LayoutBuilder(
          builder: (context, constraints) {
            final use2Columns = constraints.maxWidth >= 1000;

            if (use2Columns) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMonthlyPaymentChart()),
                      const SizedBox(width: 24),
                      Expanded(child: _buildNetCostAccumulationChart()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildPrincipalVsInterestChart(),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildMonthlyPaymentChart(),
                  const SizedBox(height: 24),
                  _buildNetCostAccumulationChart(),
                  const SizedBox(height: 32),
                  _buildPrincipalVsInterestChart(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // CHART 1: OUTSTANDING BALANCE OVER TIME (PRIMARY) ⭐
  // ==========================================================================

  Widget _buildOutstandingBalanceChart() {
    return _ChartCard(
      title: '1️⃣ Outstanding Balance Over Time',
      subtitle: 'The "race to zero" - Which strategy pays off fastest?',
      isPrimary: true,
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: _getMaxBalance() / 5,
                verticalInterval: 60,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 0.5,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Time (Months)',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Outstanding Balance',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 55,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₹${(value / 100000).toStringAsFixed(0)}L',
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppTheme.neutral300),
                  bottom: BorderSide(color: AppTheme.neutral300),
                ),
              ),
              minX: 0,
              maxX: _getMaxTenureMonths().toDouble(),
              minY: 0,
              maxY: _getMaxBalance() * 1.1,
              lineBarsData: _buildBalanceLines(),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final strategyId = _getStrategyIdByIndex(spot.barIndex);
                      final strategy = StrategyDefinitions.getById(strategyId);
                      return LineTooltipItem(
                        '${strategy?.shortTitle}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text:
                            'Month ${spot.x.toInt()}\n₹${(spot.y / 100000).toStringAsFixed(2)}L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildBalanceLines() {
    final strategies = results.strategies.entries.toList();
    return List.generate(strategies.length, (index) {
      final entry = strategies[index];
      final isBest = entry.key == results.comparisonMetrics.bestStrategyId;

      return LineChartBarData(
        spots: _generateBalanceSpots(entry.value),
        isCurved: true,
        color: isBest ? AppTheme.accentGreen : _getStrategyColor(index),
        barWidth: isBest ? 3 : 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: (isBest ? AppTheme.accentGreen : _getStrategyColor(index))
              .withValues(alpha: 0.1),
        ),
      );
    });
  }

  List<FlSpot> _generateBalanceSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    for (final payment in result.schedule) {
      spots.add(FlSpot(
        payment.month.toDouble(),
        payment.outstandingPrincipal,
      ));
    }
    return spots;
  }

  // ==========================================================================
  // CHART 2: CUMULATIVE INTEREST PAID (PRIMARY) 💰
  // ==========================================================================

  Widget _buildCumulativeInterestChart() {
    return _ChartCard(
      title: '2️⃣ Cumulative Interest Paid',
      subtitle: 'How interest costs accumulate - Flatter is better!',
      isPrimary: true,
      child: AspectRatio(
        aspectRatio: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: _getMaxInterest() / 5,
                verticalInterval: 60,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 0.5,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Time (Months)',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Interest Paid',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 55,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₹${(value / 100000).toStringAsFixed(0)}L',
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppTheme.neutral300),
                  bottom: BorderSide(color: AppTheme.neutral300),
                ),
              ),
              minX: 0,
              maxX: _getMaxTenureMonths().toDouble(),
              minY: 0,
              maxY: _getMaxInterest() * 1.1,
              lineBarsData: _buildInterestLines(),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final strategyId = _getStrategyIdByIndex(spot.barIndex);
                      final strategy = StrategyDefinitions.getById(strategyId);
                      return LineTooltipItem(
                        '${strategy?.shortTitle}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text:
                            'Month ${spot.x.toInt()}\n₹${(spot.y / 100000).toStringAsFixed(2)}L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildInterestLines() {
    final strategies = results.strategies.entries.toList();
    return List.generate(strategies.length, (index) {
      final entry = strategies[index];
      final isBest = entry.key == results.comparisonMetrics.bestStrategyId;

      return LineChartBarData(
        spots: _generateCumulativeInterestSpots(entry.value),
        isCurved: true,
        color: isBest ? AppTheme.accentGreen : _getStrategyColor(index),
        barWidth: isBest ? 3 : 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: (isBest ? AppTheme.accentGreen : _getStrategyColor(index))
              .withValues(alpha: 0.1),
        ),
      );
    });
  }

  List<FlSpot> _generateCumulativeInterestSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    double cumulative = 0;
    for (final payment in result.schedule) {
      cumulative += payment.interestPayment;
      spots.add(FlSpot(payment.month.toDouble(), cumulative));
    }
    return spots;
  }

  // ==========================================================================
  // CHART 3: MONTHLY PAYMENT AMOUNT (SECONDARY) 💵
  // ==========================================================================

  Widget _buildMonthlyPaymentChart() {
    return _ChartCard(
      title: '3️⃣ Monthly Payment Amount',
      subtitle: 'Cash flow impact - How much you pay each month',
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 0.5,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Months',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 20,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTheme.bodySmall.copyWith(fontSize: 9),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Payment',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 45,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₹${(value / 1000).toStringAsFixed(0)}K',
                        style: AppTheme.bodySmall.copyWith(fontSize: 9),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppTheme.neutral300),
                  bottom: BorderSide(color: AppTheme.neutral300),
                ),
              ),
              minX: 0,
              maxX: _getMaxTenureMonths().toDouble(),
              minY: 0,
              maxY: _getMaxPayment() * 1.2,
              lineBarsData: _buildPaymentLines(),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final strategyId = _getStrategyIdByIndex(spot.barIndex);
                      final strategy = StrategyDefinitions.getById(strategyId);
                      return LineTooltipItem(
                        '${strategy?.shortTitle}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: '₹${spot.y.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildPaymentLines() {
    final strategies = results.strategies.entries.toList();
    return List.generate(strategies.length, (index) {
      final entry = strategies[index];
      final isBest = entry.key == results.comparisonMetrics.bestStrategyId;

      return LineChartBarData(
        spots: _generatePaymentSpots(entry.value),
        isCurved: false,
        color: isBest ? AppTheme.accentGreen : _getStrategyColor(index),
        barWidth: isBest ? 2.5 : 1.5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
      );
    });
  }

  List<FlSpot> _generatePaymentSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    for (final payment in result.schedule) {
      final totalPayment = payment.emiAmount + payment.additionalPayment;
      spots.add(FlSpot(payment.month.toDouble(), totalPayment));
    }
    return spots;
  }

  // ==========================================================================
  // CHART 4: NET COST ACCUMULATION (SECONDARY) 📊
  // ==========================================================================

  Widget _buildNetCostAccumulationChart() {
    return _ChartCard(
      title: '4️⃣ Net Cost Accumulation',
      subtitle: 'True economic cost over time (with tax benefits)',
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 0.5,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Months',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 20,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTheme.bodySmall.copyWith(fontSize: 9),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Net Cost',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 45,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '₹${(value / 100000).toStringAsFixed(0)}L',
                        style: AppTheme.bodySmall.copyWith(fontSize: 9),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppTheme.neutral300),
                  bottom: BorderSide(color: AppTheme.neutral300),
                ),
              ),
              minX: 0,
              maxX: _getMaxTenureMonths().toDouble(),
              minY: 0,
              maxY: _getMaxNetCost() * 1.1,
              lineBarsData: _buildNetCostLines(),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final strategyId = _getStrategyIdByIndex(spot.barIndex);
                      final strategy = StrategyDefinitions.getById(strategyId);
                      return LineTooltipItem(
                        '${strategy?.shortTitle}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text:
                            'Month ${spot.x.toInt()}\n₹${(spot.y / 100000).toStringAsFixed(2)}L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildNetCostLines() {
    final strategies = results.strategies.entries.toList();
    return List.generate(strategies.length, (index) {
      final entry = strategies[index];
      final isBest = entry.key == results.comparisonMetrics.bestStrategyId;

      return LineChartBarData(
        spots: _generateNetCostSpots(entry.value),
        isCurved: true,
        color: isBest ? AppTheme.accentGreen : _getStrategyColor(index),
        barWidth: isBest ? 2.5 : 1.5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: (isBest ? AppTheme.accentGreen : _getStrategyColor(index))
              .withValues(alpha: 0.08),
        ),
      );
    });
  }

  List<FlSpot> _generateNetCostSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    double cumulativePrincipal = 0;
    double cumulativeInterest = 0;
    double cumulativeTaxBenefit = 0;

    for (final payment in result.schedule) {
      cumulativePrincipal += payment.principalPayment;
      cumulativeInterest += payment.interestPayment;
      cumulativeTaxBenefit += payment.taxBenefit;

      final netCost =
          cumulativePrincipal + cumulativeInterest - cumulativeTaxBenefit;
      spots.add(FlSpot(payment.month.toDouble(), netCost));
    }
    return spots;
  }

  // ==========================================================================
  // CHART 5: PRINCIPAL VS INTEREST (EDUCATIONAL) 📚
  // ==========================================================================

  Widget _buildPrincipalVsInterestChart() {
    // Show for best strategy only
    final bestStrategyId = results.comparisonMetrics.bestStrategyId;
    final bestResult = results.strategies[bestStrategyId]!;
    final bestStrategy = StrategyDefinitions.getById(bestStrategyId)!;

    return _ChartCard(
      title: '5️⃣ Principal vs Interest Breakdown',
      subtitle:
      'How payment composition changes over time (${bestStrategy.shortTitle})',
      child: AspectRatio(
        aspectRatio: 2.2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppTheme.neutral200,
                  strokeWidth: 0.5,
                  dashArray: [5, 5],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Time (Months)',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 60,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    'Percentage',
                    style: AppTheme.labelMedium.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: AppTheme.bodySmall.copyWith(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppTheme.neutral300),
                  bottom: BorderSide(color: AppTheme.neutral300),
                ),
              ),
              minX: 0,
              maxX: bestResult.tenureMonths.toDouble(),
              minY: 0,
              maxY: 100,
              lineBarsData: _buildPrincipalInterestLines(bestResult),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isInterest = spot.barIndex == 0;
                      return LineTooltipItem(
                        '${isInterest ? 'Interest' : 'Principal'}\n',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        children: [
                          TextSpan(
                            text: '${spot.y.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _buildPrincipalInterestLines(StrategyResult result) {
    return [
      // Interest line
      LineChartBarData(
        spots: _generateInterestPercentageSpots(result),
        isCurved: true,
        color: AppTheme.accentRed.withValues(alpha: 0.8),
        barWidth: 2.5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.accentRed.withValues(alpha: 0.2),
        ),
      ),
      // Principal line
      LineChartBarData(
        spots: _generatePrincipalPercentageSpots(result),
        isCurved: true,
        color: AppTheme.primaryBlue.withValues(alpha: 0.8),
        barWidth: 2.5,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppTheme.primaryBlue.withValues(alpha: 0.2),
        ),
      ),
    ];
  }

  List<FlSpot> _generateInterestPercentageSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    for (final payment in result.schedule) {
      final total = payment.principalPayment + payment.interestPayment;
      final percentage = total > 0 ? (payment.interestPayment / total) * 100 : 0.0;
      spots.add(FlSpot(payment.month.toDouble(), percentage));
    }
    return spots;
  }

  List<FlSpot> _generatePrincipalPercentageSpots(StrategyResult result) {
    final spots = <FlSpot>[];
    for (final payment in result.schedule) {
      final total = payment.principalPayment + payment.interestPayment;
      final percentage = total > 0 ? (payment.principalPayment / total) * 100 : 0.0;
      spots.add(FlSpot(payment.month.toDouble(), percentage));
    }
    return spots;
  }

  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================

  String _getStrategyIdByIndex(int index) {
    return results.strategies.keys.elementAt(index);
  }

  Color _getStrategyColor(int index) {
    const colors = [
      AppTheme.primaryBlue,
      AppTheme.accentOrange,
      Color(0xFF8B5CF6), // Purple
      Color(0xFFEC4899), // Pink
    ];
    return colors[index % colors.length];
  }

  double _getMaxBalance() {
    double max = 0;
    for (final result in results.strategies.values) {
      if (result.schedule.isNotEmpty) {
        final firstBalance = result.schedule.first.outstandingPrincipal;
        if (firstBalance > max) max = firstBalance;
      }
    }
    return max;
  }

  double _getMaxInterest() {
    return results.strategies.values
        .map((r) => r.totalInterestPaid)
        .reduce((a, b) => a > b ? a : b);
  }

  double _getMaxPayment() {
    double max = 0;
    for (final result in results.strategies.values) {
      for (final payment in result.schedule) {
        final total = payment.emiAmount + payment.additionalPayment;
        if (total > max) max = total;
      }
    }
    return max;
  }

  double _getMaxNetCost() {
    return results.strategies.values
        .map((r) => r.netCost)
        .reduce((a, b) => a > b ? a : b);
  }

  int _getMaxTenureMonths() {
    return results.strategies.values
        .map((r) => r.tenureMonths)
        .reduce((a, b) => a > b ? a : b);
  }
}

// ==========================================================================
// CHART CARD WRAPPER
// ==========================================================================

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool isPrimary;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: isPrimary
              ? AppTheme.primaryBlue.withValues(alpha: 0.3)
              : AppTheme.neutral200,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: isPrimary
            ? [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isPrimary
                  ? AppTheme.primaryBlueSubtle
                  : AppTheme.backgroundSecondary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.heading4.copyWith(
                    fontSize: isPrimary ? 18 : 16,
                    color: isPrimary
                        ? AppTheme.primaryBlueDark
                        : AppTheme.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutral600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          child,
          // Legend
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    if (title.contains('Principal vs Interest')) {
      return Wrap(
        spacing: 24,
        runSpacing: 8,
        children: [
          _LegendItem(
            color: AppTheme.accentRed.withValues(alpha: 0.8),
            label: 'Interest %',
          ),
          _LegendItem(
            color: AppTheme.primaryBlue.withValues(alpha: 0.8),
            label: 'Principal %',
          ),
        ],
      );
    }
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        _LegendItem(
          color: AppTheme.accentGreen,
          label: 'Best Strategy',
        ),
        _LegendItem(
          color: AppTheme.neutral400,
          label: 'Other Strategies',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.neutral600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}