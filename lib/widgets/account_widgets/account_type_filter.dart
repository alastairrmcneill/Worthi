import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

// Filter for the different types of accounts
class AccountTypeFilter extends StatelessWidget {
  const AccountTypeFilter({super.key});

  // Show the dialog for selecting multiple
  void _showMultiSelect(BuildContext context, AccountNotifier accountNotifier) async {
    final List<String> items = AccountTypes.allTypes();

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
          items: items,
          preSelectedItems: accountNotifier.filter,
        );
      },
    );

    // Update UI
    if (results != null) {
      accountNotifier.setFilter = results;
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return GestureDetector(
      onTap: () {
        // Show the dialog box when filter clicked
        _showMultiSelect(context, accountNotifier);
      },
      // Show text and dropdown icon
      child: Row(
        children: [
          Text(
            accountNotifier.filter.isEmpty || accountNotifier.filter.length == 5 ? 'All' : '${accountNotifier.filter.length} selected',
            style: const TextStyle(fontSize: 20),
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
