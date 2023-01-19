import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/screens/screens.dart';
import 'package:provider/provider.dart';

class AccountListTile extends StatelessWidget {
  final Account account;
  const AccountListTile({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: false);
    return GestureDetector(
      onTap: () {
        accountNotifier.setCurrentAccount = account;
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountDetailScreen()));
      },
      child: Container(
        height: 100,
        width: double.infinity,
        color: Colors.green,
        child: Text("${account.name} - ${account.type}"),
      ),
    );
  }
}
