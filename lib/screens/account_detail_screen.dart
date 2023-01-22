import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: true);
    Account account = accountNotifier.currentAccount!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              if (value == MenuItems.item1) {
                showEditNameDialog(context, account);
              } else if (value == MenuItems.item2) {
                showTwoButtonDialog(
                  context,
                  'Are you sure you want to remove this account?',
                  'Delete',
                  () async {
                    await AccountDatabase.deleteAccount(context, id: account.id!).whenComplete(() => Navigator.pop(context));
                  },
                  'Cancel',
                  () {},
                );
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
            Expanded(
              flex: 1,
              child: Container(), //HistoryListView(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: ElevatedButton(
                onPressed: () {
                  showAddEntryDialog(context, account);
                },
                child: const Text('Add Entry'),
              ),
            ),
            const SizedBox(height: 10),
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
