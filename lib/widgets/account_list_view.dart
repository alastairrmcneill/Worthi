import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/support/theme.dart';
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
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 3),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.blueAccent, width: 3))),
          child: const Text(
            "Accounts",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 15),
        accountNotifier.filteredAccounts == null
            ? const Center(child: CircularProgressIndicator())
            : accountNotifier.filteredAccounts!.isEmpty
                ? const SizedBox(height: 50, child: Center(child: Text('Add an account to get started')))
                : Column(
                    children: [
                      ...accountNotifier.filteredAccounts!.map((account) => AccountListTile(account: account)).toList(),
                    ],
                  ),
      ],
    );
  }
}
