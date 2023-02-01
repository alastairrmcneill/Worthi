import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TotalValue extends StatelessWidget {
  TotalValue({super.key});
  final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

  String _buildTotal(AccountNotifier accountNotifier) {
    if (accountNotifier.filteredAccounts == null) return "0.00";

    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotal = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotal += account.history.first[AccountFields.value];
    }
    return formatCurrency.format(runningTotal);
  }

  String _buildInvested(AccountNotifier accountNotifier) {
    if (!accountNotifier.filter.contains(AccountTypes.investment) || accountNotifier.filter.length > 1) return "0.00";
    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotal = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotal += account.history.first[AccountFields.deposited];
    }
    return formatCurrency.format(runningTotal);
  }

  String _buildReturns(AccountNotifier accountNotifier) {
    if (!accountNotifier.filter.contains(AccountTypes.investment) || accountNotifier.filter.length > 1) return "0.00";
    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotalDepostied = 0;
    double runningTotalValue = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotalDepostied += account.history.first[AccountFields.deposited];
      runningTotalValue += account.history.first[AccountFields.value];
    }
    String returnsString = formatCurrency.format(runningTotalValue - runningTotalDepostied);
    String percentString = (((runningTotalValue - runningTotalDepostied) / runningTotalDepostied) * 100).toStringAsFixed(2);
    return '$returnsString ($percentString%)';
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
    String total = _buildTotal(accountNotifier);
    String invested = _buildInvested(accountNotifier);
    String returns = _buildReturns(accountNotifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          total[0] == '-' ? ' -${settingsNotifier.currency}${total.substring(1)}' : '${settingsNotifier.currency}$total',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 10),
        accountNotifier.filter.length == 1
            ? accountNotifier.filter[0] == AccountTypes.investment
                ? Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invested',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFE1E7FF).withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${settingsNotifier.currency}$invested',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Returns',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFE1E7FF).withOpacity(0.8),
                            ),
                          ),
                          Text(
                            returns[0] == '-' ? '-${settingsNotifier.currency}${returns.substring(1)}' : '${settingsNotifier.currency}$returns',
                            style: TextStyle(
                              color: returns[0] == '-' ? MyColors.redAccent : MyColors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox()
            : const SizedBox()
      ],
    );
  }
}
