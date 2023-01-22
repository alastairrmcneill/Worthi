import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  List<Series<TimeSeriesTotals, DateTime>> _buildData(AccountNotifier accountNotifier) {
    List<Account> accounts = accountNotifier.filteredAccounts!;
    List<List<dynamic>> accountsHistory = []; // Todo: figure out how to find the first date of the account history
    final DateTime endDate = DateTime.now();
    DateTime startDate = DateTime.now();

    for (var account in accounts) {
      accountsHistory.add(account.history as List<dynamic>);
    }
    for (var account in accountsHistory) {
      if (account.isEmpty) continue;
      DateTime firstDate = (account.last[AccountFields.date] as Timestamp).toDate();
      if (startDate.isAfter(firstDate)) {
        startDate = firstDate;
      }
    }

    final daysToGenerate = endDate.difference(startDate).inDays + 1;
    final dates = List.generate(daysToGenerate, (i) => DateTime(startDate.year, startDate.month, startDate.day + (i)));

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

    final List<TimeSeriesTotals> dataValues = [];
    final List<TimeSeriesTotals> dataDeposits = [];

    for (var i = 0; i < dates.length; i++) {
      var date = dates[i];
      var value = findAmountAtDate(date, AccountFields.value);
      var deposit = findAmountAtDate(date, AccountFields.deposited);
      dataValues.add(TimeSeriesTotals(date, value));
      dataDeposits.add(TimeSeriesTotals(date, deposit));
    }

    if (accountNotifier.filter != AccountTypes.investment) {
      return [
        Series<TimeSeriesTotals, DateTime>(
          id: 'Value',
          data: dataValues,
          domainFn: (TimeSeriesTotals totals, _) => totals.time,
          measureFn: (TimeSeriesTotals totals, _) => totals.total,
          seriesColor: Color(r: MyColors.background.red, g: MyColors.blueAccent.green, b: MyColors.blueAccent.blue),
        ),
      ];
    } else {
      return [
        Series<TimeSeriesTotals, DateTime>(
          id: 'Value',
          data: dataValues,
          domainFn: (TimeSeriesTotals totals, _) => totals.time,
          measureFn: (TimeSeriesTotals totals, _) => totals.total,
          seriesColor: Color(r: MyColors.background.red, g: MyColors.blueAccent.green, b: MyColors.blueAccent.blue),
        ),
        Series<TimeSeriesTotals, DateTime>(
          id: 'Deposited',
          data: dataDeposits,
          domainFn: (TimeSeriesTotals totals, _) => totals.time,
          measureFn: (TimeSeriesTotals totals, _) => totals.total,
          seriesColor: ColorUtil.fromDartColor(Colors.grey),
          dashPatternFn: (datum, index) => [2, 2],
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 0, left: 10),
      height: 400,
      child: accountNotifier.filteredAccounts != null
          ? Center(
              child: TimeSeriesChart(
                _buildData(accountNotifier),
                animate: true,
                domainAxis: DateTimeAxisSpec(
                  renderSpec: SmallTickRendererSpec(
                    labelStyle: TextStyleSpec(
                      color: Color(r: MyColors.lightAccent.red, g: MyColors.lightAccent.green, b: MyColors.lightAccent.blue),
                    ),
                    lineStyle: LineStyleSpec(
                      color: Color(r: MyColors.lightAccent.red, g: MyColors.lightAccent.green, b: MyColors.lightAccent.blue),
                    ),
                  ),
                  tickFormatterSpec: AutoDateTimeTickFormatterSpec(
                    month: TimeFormatterSpec(format: 'MMM', transitionFormat: 'MMM yy'),
                  ),
                ),
                primaryMeasureAxis: NumericAxisSpec(
                  tickFormatterSpec: BasicNumericTickFormatterSpec.fromNumberFormat(NumberFormat.compact()),
                  renderSpec: SmallTickRendererSpec(
                    labelStyle: TextStyleSpec(
                      color: Color(r: MyColors.lightAccent.red, g: MyColors.lightAccent.green, b: MyColors.lightAccent.blue),
                    ),
                    lineStyle: LineStyleSpec(
                      color: Color(r: MyColors.lightAccent.red, g: MyColors.lightAccent.green, b: MyColors.lightAccent.blue),
                    ),
                  ),
                ),
                defaultRenderer: LineRendererConfig(
                  strokeWidthPx: 1,
                  includeArea: true,
                  areaOpacity: 0.05,
                ),
                behaviors: accountNotifier.filter == AccountTypes.investment ? [SeriesLegend()] : [],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
