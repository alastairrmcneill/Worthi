import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Container(
      height: 50,
      color: Colors.blue,
      width: 150,
      child: DropdownButton(
        value: accountNotifier.filter ?? "Overview",
        items: [
          DropdownMenuItem<String>(value: "Overview", child: Text("Overview")),
          DropdownMenuItem<String>(value: AccountTypes.bank, child: Text(AccountTypes.bank)),
          DropdownMenuItem<String>(value: AccountTypes.credit, child: Text(AccountTypes.credit)),
          DropdownMenuItem<String>(value: AccountTypes.investment, child: Text(AccountTypes.investment)),
          DropdownMenuItem<String>(value: AccountTypes.loan, child: Text(AccountTypes.loan)),
          DropdownMenuItem<String>(value: AccountTypes.pension, child: Text(AccountTypes.pension)),
        ],
        onChanged: (value) {
          if (value == "Overview") {
            accountNotifier.setFilter = null;
            return;
          }
          accountNotifier.setFilter = value as String;
        },
      ),
    );
  }
}
