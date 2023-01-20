import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountListView extends StatelessWidget {
  const AccountListView({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Accounts"),
          ],
        ),
        accountNotifier.filteredAccounts == null
            ? const CircularProgressIndicator()
            : accountNotifier.filteredAccounts!.isEmpty
                ? const SizedBox(height: 50, child: Center(child: Text('Press the + to create an account')))
                : Column(
                    children: [
                      ...accountNotifier.filteredAccounts!.map((account) => AccountListTile(account: account)).toList(),
                    ],
                  ),
      ],
    );
  }
}
