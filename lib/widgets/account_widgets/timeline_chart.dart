import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf;

// Chart with total value of accounts over time
class Chart extends StatelessWidget {
  const Chart({super.key});

  // Get the data from provider and format for chart type
  Map<String, Object>? _buildChartData(AccountNotifier accountNotifier) {
    final List<ChartData> chartValueData = [];
    final List<ChartData> chartDepositData = [];
    sf.DateTimeIntervalType intervalType = sf.DateTimeIntervalType.auto;
    double interval = 0;

    List<Account> accounts = accountNotifier.filteredAccounts ?? [];
    List<List<dynamic>> accountsHistory = [];
    DateTime? endDate;
    DateTime? startDate;

    // Loop through accounts to pull out history
    for (var account in accounts) {
      accountsHistory.add(account.history as List<dynamic>);
    }

    // Loop through the account histories to get the correct starting date
    for (var i = 0; i < accountsHistory.length; i++) {
      var account = accountsHistory[i];
      if (account.isEmpty) continue;
      if (i == 0) {
        startDate = (account.last[AccountFields.date] as Timestamp).toDate();
        endDate = (account.first[AccountFields.date] as Timestamp).toDate();
      } else {
        DateTime accountHistoryFirstDate = (account.last[AccountFields.date] as Timestamp).toDate();
        if (startDate!.isAfter(accountHistoryFirstDate)) {
          startDate = accountHistoryFirstDate;
        }

        DateTime accountHistoryLastDate = (account.first[AccountFields.date] as Timestamp).toDate();
        if (endDate!.isBefore(accountHistoryLastDate)) {
          endDate = accountHistoryLastDate;
        }
      }
    }

    List<DateTime> dates = [];

    DateTime loopStartDate = startDate ?? DateTime.now();

    // Build up list of dates for x-axis
    while (!loopStartDate.isAfter(endDate ?? DateTime.now())) {
      dates.add(DateTime(loopStartDate.year, loopStartDate.month));
      loopStartDate = DateTime(loopStartDate.year, loopStartDate.month + 1);
    }
    dates.add(DateTime.now());

    startDate = startDate ?? DateTime.now();
    endDate = DateTime.now();

    // Determine the x-axis type
    if (dates.length < 3) {
      final daysToGenerate = (endDate).difference(startDate).inDays + 1;

      dates = [];
      dates = List.generate(daysToGenerate, (i) => DateTime(startDate!.year, startDate.month, startDate.day + (i)));
    }

    int daysBetweenStartAndEnd = dates.last.difference(dates.first).inDays;

    if (daysBetweenStartAndEnd < 31) {
      intervalType = sf.DateTimeIntervalType.days;
      interval = 5;
    } else if (daysBetweenStartAndEnd < 400) {
      intervalType = sf.DateTimeIntervalType.months;
      interval = 2;
    } else {
      intervalType = sf.DateTimeIntervalType.years;
      interval = 1;
    }

    // Find value in history at a specific date
    double findAmountAtDate(DateTime requestDate, String accountField) {
      double runningTotal = 0;

      for (var account in accountsHistory) {
        for (var update in account) {
          if (!requestDate.isBefore((update[AccountFields.date] as Timestamp).toDate())) {
            runningTotal += update[accountField] as double? ?? 0;
            break;
          }
        }
      }

      return runningTotal;
    }

    // Loop through all the dates and sum up all the account values
    for (var i = 0; i < dates.length; i++) {
      var date = dates[i];
      var value = findAmountAtDate(date, AccountFields.value);
      var deposit = findAmountAtDate(date, AccountFields.deposited);
      chartValueData.add(ChartData(date, value));
      chartDepositData.add(ChartData(date, deposit));
    }

    return {
      "chartValueData": chartValueData,
      "chartDepositData": chartDepositData,
      "intervalType": intervalType,
      "interval": interval,
    };
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    DisplayNotifier displayNotifier = Provider.of<DisplayNotifier>(context, listen: false);
    sf.SplineType splineType = sf.SplineType.monotonic;
    late Map<String, Object>? chartData;
    if (accountNotifier.filteredAccounts != null) {
      if (accountNotifier.filteredAccounts!.isNotEmpty) {
        chartData = _buildChartData(accountNotifier);
      }
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 10),
      height: 400,
      child: accountNotifier.filteredAccounts != null
          ? accountNotifier.filteredAccounts!.isNotEmpty
              ? Center(
                  child: sf.SfCartesianChart(
                    // Allow panning of chart
                    zoomPanBehavior: sf.ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                    ),
                    // Allow click to see extra detail
                    trackballBehavior: sf.TrackballBehavior(
                      enable: true,
                      activationMode: sf.ActivationMode.singleTap,
                    ),
                    // Check where you click and update the value widget
                    onTrackballPositionChanging: (sf.TrackballArgs args) {
                      sf.ChartSeries<dynamic, dynamic> series = args.chartPointInfo.series as sf.ChartSeries;
                      if (series.runtimeType.toString().toLowerCase().contains('area')) {
                        args.chartPointInfo.header = '';
                        args.chartPointInfo.label = '';
                      }
                      // Update the provider for the value widget
                      if (series.name == 'Value') {
                        displayNotifier.setValue = (chartData?["chartValueData"] as List<ChartData>)[args.chartPointInfo.dataPointIndex ?? 0].y;
                      }
                      if (series.name == 'Deposited') {
                        displayNotifier.setDeposited = (chartData?["chartDepositData"] as List<ChartData>)[args.chartPointInfo.dataPointIndex ?? 0].y;
                      }
                    },
                    // When you touch the graph set the widget to show the value of the graph
                    onChartTouchInteractionDown: (tapArgs) {
                      displayNotifier.setShowFromGraph = true;
                    },
                    // When you release set the widget to show the current total
                    onChartTouchInteractionUp: (tapArgs) {
                      displayNotifier.setShowFromGraph = false;
                    },
                    // If you are zooming make sure it doesn't get counted as a touch
                    onZoomStart: (zoomingArgs) {
                      displayNotifier.setShowFromGraph = false;
                    },
                    plotAreaBorderWidth: 0,
                    margin: const EdgeInsets.only(left: 0, right: 10),
                    // Legend only showing info if investment acconut selected
                    legend: sf.Legend(
                      isVisible: (accountNotifier.filter.length == 1 && accountNotifier.filter.contains(AccountTypes.investment)),
                      textStyle: const TextStyle(color: MyColors.lightAccent),
                      position: sf.LegendPosition.top,
                    ),
                    // X axis with the right type of axis type
                    primaryXAxis: sf.DateTimeAxis(
                      borderColor: MyColors.lightAccent,
                      labelStyle: const TextStyle(color: MyColors.lightAccent),
                      majorGridLines: const sf.MajorGridLines(width: 0),
                      interval: chartData?["interval"] as double? ?? 1,
                      intervalType: chartData?["intervalType"] as sf.DateTimeIntervalType? ?? sf.DateTimeIntervalType.auto,
                      enableAutoIntervalOnZooming: true,
                    ),
                    // Y axis with the right number formatting
                    primaryYAxis: sf.NumericAxis(
                      borderColor: MyColors.lightAccent,
                      labelStyle: const TextStyle(color: MyColors.lightAccent),
                      numberFormat: NumberFormat.compact(),
                      majorGridLines: const sf.MajorGridLines(width: 0),
                    ),
                    // Data for chart
                    series: <sf.ChartSeries<ChartData, DateTime>>[
                      // Value of accounts
                      sf.SplineSeries<ChartData, DateTime>(
                        name: 'Value',
                        dataSource: _buildChartData(accountNotifier)?["chartValueData"] as List<ChartData>? ?? [],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: MyColors.blueAccent,
                        animationDuration: 400,
                        splineType: splineType,
                      ),
                      // Area under the line for the value of the accounts
                      sf.SplineAreaSeries<ChartData, DateTime>(
                        name: 'Value area',
                        isVisibleInLegend: false,
                        dataSource: _buildChartData(accountNotifier)?["chartValueData"] as List<ChartData>? ?? [],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: MyColors.blueAccent,
                        animationDuration: 400,
                        opacity: 0.05,
                        splineType: splineType,
                      ),
                      // Deposited line if the investment option is selected
                      sf.SplineSeries<ChartData, DateTime>(
                        name: 'Deposited',
                        dataSource: _buildChartData(accountNotifier)?["chartDepositData"] as List<ChartData>? ?? [],
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                        color: MyColors.lightAccentDarker,
                        animationDuration: 400,
                        width: 0.8,
                        dashArray: const [3, 3],
                        isVisible: (accountNotifier.filter.length == 1 && accountNotifier.filter.contains(AccountTypes.investment)),
                        splineType: splineType,
                      ),
                    ],
                  ),
                )
              : Center(
                  // Show empty chart if no data
                  child: sf.SfCartesianChart(
                    plotAreaBorderWidth: 0,
                    primaryXAxis: sf.DateTimeAxis(
                      borderColor: MyColors.lightAccent,
                      labelStyle: const TextStyle(color: MyColors.lightAccent),
                      majorGridLines: const sf.MajorGridLines(width: 0),
                      maximum: DateTime.now(),
                      minimum: DateTime.now().subtract(const Duration(days: 30)),
                      interval: 10,
                      intervalType: sf.DateTimeIntervalType.days,
                      enableAutoIntervalOnZooming: true,
                    ),
                    primaryYAxis: sf.NumericAxis(
                      borderColor: MyColors.lightAccent,
                      labelStyle: const TextStyle(color: MyColors.lightAccent),
                      numberFormat: NumberFormat.compact(),
                      majorGridLines: const sf.MajorGridLines(width: 0),
                      interval: 1,
                      minimum: 0,
                      maximum: 5,
                    ),
                  ),
                )
          : const Center(child: CircularProgressIndicator()), // If no data then show loading
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
