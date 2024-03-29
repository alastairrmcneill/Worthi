import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

// List view of all the accounts that this user has
class AccountListView extends StatelessWidget {
  const AccountListView({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
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
          accountNotifier.filteredNotArchivedAccounts == null
              // If database hasn't loaded then show loading icon
              ? const SizedBox(height: 50, child: Center(child: CircularProgressIndicator()))
              : accountNotifier.filteredNotArchivedAccounts!.isEmpty
                  // Show message if list is empty
                  ? const SizedBox(height: 50, child: Center(child: Text('No accounts.')))
                  // Otherwise show list of account tiles
                  : Column(
                      children: [
                        ...accountNotifier.filteredNotArchivedAccounts!
                            .map(
                              (account) => AccountListTile(account: account),
                            )
                            .toList(),
                      ],
                    ),
        ],
      ),
    );
  }
}
