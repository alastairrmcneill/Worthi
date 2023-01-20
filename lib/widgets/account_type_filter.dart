import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class AccountTypeFilter extends StatelessWidget {
  const AccountTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Container(
      child: DropdownButton(
        alignment: AlignmentDirectional.center,
        underline: const SizedBox(),
        value: accountNotifier.filter ?? AccountTypes.all,
        items: [
          DropdownMenuItem<String>(value: AccountTypes.all, child: Text(AccountTypes.all)),
          DropdownMenuItem<String>(value: AccountTypes.bank, child: Text(AccountTypes.bank)),
          DropdownMenuItem<String>(value: AccountTypes.credit, child: Text(AccountTypes.credit)),
          DropdownMenuItem<String>(value: AccountTypes.investment, child: Text(AccountTypes.investment)),
          DropdownMenuItem<String>(value: AccountTypes.loan, child: Text(AccountTypes.loan)),
          DropdownMenuItem<String>(value: AccountTypes.pension, child: Text(AccountTypes.pension)),
        ],
        onChanged: (value) {
          if (value == AccountTypes.all) {
            accountNotifier.setFilter = null;
            return;
          }
          accountNotifier.setFilter = value as String;
        },
      ),
    );
  }
}
