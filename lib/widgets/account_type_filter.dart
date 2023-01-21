import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class AccountTypeFilter extends StatelessWidget {
  const AccountTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);

    List<PopupMenuItem<String>> items = [
      PopupMenuItem(value: AccountTypes.all, child: Text(AccountTypes.all, style: const TextStyle(color: Color(0xFF363844)))),
      PopupMenuItem(value: AccountTypes.bank, child: Text(AccountTypes.bank, style: const TextStyle(color: Color(0xFF363844)))),
      PopupMenuItem(value: AccountTypes.credit, child: Text(AccountTypes.credit, style: const TextStyle(color: Color(0xFF363844)))),
      PopupMenuItem(value: AccountTypes.investment, child: Text(AccountTypes.investment, style: const TextStyle(color: Color(0xFF363844)))),
      PopupMenuItem(value: AccountTypes.loan, child: Text(AccountTypes.loan, style: const TextStyle(color: Color(0xFF363844)))),
      PopupMenuItem(value: AccountTypes.pension, child: Text(AccountTypes.pension, style: const TextStyle(color: Color(0xFF363844)))),
    ];
    return PopupMenuButton(
      itemBuilder: (context) => items,
      onSelected: (value) {
        if (value == AccountTypes.all) {
          accountNotifier.setFilter = null;
          return;
        }
        accountNotifier.setFilter = value as String;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            accountNotifier.filter ?? AccountTypes.all,
            style: const TextStyle(fontSize: 20, color: Color(0xFFE1E7FF)),
          ),
          const Icon(
            Icons.arrow_drop_down,
            size: 28,
          ),
        ],
      ),
    );
  }
}
