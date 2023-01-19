import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    if (accountNotifier.currentAccount == null) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: accountNotifier.currentAccount!.history.length,
      itemBuilder: (context, index) {
        final entry = accountNotifier.currentAccount!.history[index];
        return HistoryListTile(index: index, entry: entry);
      },
    );
  }
}
