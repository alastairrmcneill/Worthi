import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Widget at the top fo the home screen
class TotalValue extends StatelessWidget {
  TotalValue({super.key});
  final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

  // Determine what to show in the total
  String _buildTotal(AccountNotifier accountNotifier, DisplayNotifier displayNotifier) {
    // If there are no filters then return nothing
    if (accountNotifier.filteredAccounts == null) return "0.00";

    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotal = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotal += account.history.first[AccountFields.value];
    }

    if (displayNotifier.showFromGraph) {
      runningTotal = displayNotifier.value;
    }

    return formatCurrency.format(runningTotal);
  }

  // Determine total that has been invested
  String _buildInvested(AccountNotifier accountNotifier, DisplayNotifier displayNotifier) {
    // Return nothing if no acconuts selected that are investment accounts
    if (!accountNotifier.filter.contains(AccountTypes.investment) || accountNotifier.filter.length > 1) return "0.00";
    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotal = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotal += account.history.first[AccountFields.deposited];
    }

    if (displayNotifier.showFromGraph) {
      runningTotal = displayNotifier.deposited;
    }

    return formatCurrency.format(runningTotal);
  }

  // Determine returns on what has been invested
  String _buildReturns(AccountNotifier accountNotifier, DisplayNotifier displayNotifier) {
    // Return nothing if no investment accounts have been selected
    if (!accountNotifier.filter.contains(AccountTypes.investment) || accountNotifier.filter.length > 1) return "0.00";
    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotalDepostied = 0;
    double runningTotalValue = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotalDepostied += account.history.first[AccountFields.deposited];
      runningTotalValue += account.history.first[AccountFields.value];
    }

    if (displayNotifier.showFromGraph) {
      runningTotalValue = displayNotifier.value;
      runningTotalDepostied = displayNotifier.deposited;
    }

    String returnsString = formatCurrency.format(runningTotalValue - runningTotalDepostied);
    String percentString = (((runningTotalValue - runningTotalDepostied) / runningTotalDepostied) * 100).toStringAsFixed(2);
    return '$returnsString ($percentString%)';
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
    DisplayNotifier displayNotifier = Provider.of<DisplayNotifier>(context);

    // Update information
    String total = _buildTotal(accountNotifier, displayNotifier);
    String invested = _buildInvested(accountNotifier, displayNotifier);
    String returns = _buildReturns(accountNotifier, displayNotifier);

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
