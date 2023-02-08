import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/support/wrapper.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({super.key});

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: true);
    if (accountNotifier.currentAccount == null) return const Center(child: CircularProgressIndicator());

    Account account = accountNotifier.currentAccount!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert_rounded),
            onSelected: (value) async {
              if (value == MenuItems.item1) {
                // Edit
                showEditNameDialog(context, account);
              } else if (value == MenuItems.item2) {
                // Archive/Restore
                Account newAccount = account.copy(archived: !account.archived);
                await AccountDatabase.updateAccount(context, newAccount: newAccount);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Wrapper()), (_) => false);
              } else if (value == MenuItems.item3) {
                // Delete
                showTwoButtonDialog(
                  context,
                  'Are you sure you want to remove this account?',
                  'Delete',
                  () async {
                    Navigator.pop(context);
                    await AccountDatabase.deleteAccount(context, id: account.id!);
                  },
                  'Cancel',
                  () {},
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuItems.item1,
                child: Text('Edit', style: TextStyle(color: Color(0xFF363844))),
              ),
              PopupMenuItem(
                value: MenuItems.item2,
                child: Text(account.archived ? 'Restore' : 'Archive', style: const TextStyle(color: Color(0xFF363844))),
              ),
              const PopupMenuItem(
                value: MenuItems.item3,
                child: Text('Delete', style: TextStyle(color: Color(0xFF363844))),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AccountSummary(),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: MyColors.darkAccent,
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: AccountHistoryListView()),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: MyColors.darkAccent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
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
