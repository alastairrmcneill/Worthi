import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ArchivedAccountsScreen extends StatelessWidget {
  const ArchivedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archived Accounts',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: accountNotifier.archivedAccounts == null
              ? const SizedBox(height: 50, child: Center(child: CircularProgressIndicator())) // Show loading if the database hasn't loaded yet
              : accountNotifier.archivedAccounts!.isEmpty
                  ? const SizedBox(height: 50, child: Center(child: Text('No accounts.'))) // Show message if this secion is empty
                  : Column(
                      children: [
                        ...accountNotifier.archivedAccounts!
                            .map(
                              (account) => AccountListTile(account: account),
                            )
                            .toList(),
                      ],
                    ),
        ),
      ),
    );
  }
}
