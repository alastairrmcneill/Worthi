import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

// List of historical entries for the account
class AccountHistoryListView extends StatelessWidget {
  const AccountHistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);

    // If there isn't an account selected then show loading icon
    if (accountNotifier.currentAccount == null) return const Center(child: CircularProgressIndicator());

    // Show a list view of the history tiles
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 3),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.blueAccent, width: 3))),
          child: const Text(
            "History",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 15),
        ...accountNotifier.currentAccount!.history.asMap().entries.map((e) {
          final index = e.key;
          final entry = e.value;

          return AccountHistoryListTile(index: index, entry: entry);
        }).toList(),
      ],
    );
  }
}
