import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class TotalValue extends StatelessWidget {
  const TotalValue({super.key});

  String _buildData(AccountNotifier accountNotifier) {
    if (accountNotifier.filteredAccounts == null) return "0.00";

    List<Account> accounts = accountNotifier.filteredAccounts!;
    double runningTotal = 0;

    for (var account in accounts) {
      if (account.history.isEmpty) continue;
      runningTotal += account.history.first[AccountFields.value];
    }

    return runningTotal.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Container(
      child: Text(_buildData(accountNotifier)),
    );
  }
}
