import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HistoryListTile extends StatelessWidget {
  final int index;
  final Map<String, Object?> entry;
  const HistoryListTile({super.key, required this.index, required this.entry});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return GestureDetector(
      onTap: () async {
        Account account = accountNotifier.currentAccount!;

        account.history.removeAt(index);
        await AccountDatabase.updateAccount(context, newAccount: account);
      },
      onLongPress: () {
        Account account = accountNotifier.currentAccount!;
        showEditEntryDialog(context, account, index);
      },
      child: Container(
        color: Colors.purple,
        height: 100,
        child: Column(
          children: [
            Text(entry[AccountFields.date].toString()),
            Text(entry[AccountFields.value].toString()),
          ],
        ),
      ),
    );
  }
}
