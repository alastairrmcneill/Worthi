import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              if (value == MenuItems.item1) {
                showEditNameDialog(context, accountNotifier.currentAccount!);
              } else if (value == MenuItems.item2) {
                await AccountDatabase.deleteAccount(context, id: accountNotifier.currentAccount!.id!).whenComplete(() => Navigator.pop(context));
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: MenuItems.item1,
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: MenuItems.item2,
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: HistoryListView(),
            ),
            ElevatedButton(
              onPressed: () {
                showAddEntryDialog(context, accountNotifier.currentAccount!);
              },
              child: const Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuItems {
  item1,
  item2,
  item3;
}
