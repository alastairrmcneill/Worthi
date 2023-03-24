import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Tile to display the historical entries in the account details
class AccountHistoryListTile extends StatelessWidget {
  final int index;
  final Map<String, Object?> entry;
  AccountHistoryListTile({super.key, required this.index, required this.entry});
  GlobalKey editEntryKey = GlobalKey();

  // Build the data for the return
  Widget _buildReturns(SettingsNotifier settingsNotifier, Account account) {
    if (account.type != AccountTypes.investment) return const SizedBox();

    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

    double? totalDeposited = double.tryParse(account.history[index][AccountFields.deposited].toString());
    totalDeposited ??= EncryptionService.decryptToDouble(account.history[index][AccountFields.deposited] as String);

    String depositedString = formatCurrency.format(totalDeposited);

    double? totalValue = double.tryParse(account.history[index][AccountFields.value].toString());
    totalValue ??= EncryptionService.decryptToDouble(account.history[index][AccountFields.value] as String);

    String returnsString = formatCurrency.format(totalValue - totalDeposited);
    String percentString = (((totalValue - totalDeposited) / totalDeposited) * 100).toStringAsFixed(2);
    if (percentString == "NaN") percentString = "0";
    String returns = '$returnsString ($percentString%)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          depositedString[0] == '-' ? 'Deposited: -${settingsNotifier.currency}${depositedString.substring(1)}' : 'Deposited:  ${settingsNotifier.currency}$depositedString',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Returns: ',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: MyColors.lightAccent),
            children: [
              TextSpan(
                text: returns[0] == '-' ? '-${settingsNotifier.currency}${returns.substring(1)}' : '${settingsNotifier.currency}$returns',
                style: TextStyle(
                  color: returns[0] == '-' ? MyColors.redAccent : MyColors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
    DateTime date = (entry[AccountFields.date] as Timestamp).toDate();

    double? value = double.tryParse(entry[AccountFields.value].toString());
    value ??= EncryptionService.decryptToDouble(entry[AccountFields.value] as String);

    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');
    String valueString = formatCurrency.format(value);

    // Swipe across on the tile to carry out actions
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // Edit option
          SlidableAction(
            onPressed: (context) {
              Account account = accountNotifier.currentAccount!;
              showEditEntryDialog(context, account, index);
            },
            backgroundColor: MyColors.greenAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          // Delete option
          SlidableAction(
            onPressed: (context) async {
              Account account = accountNotifier.currentAccount!;
              if (account.history.length == 1) {
                showSnackBar(context, 'Cannot delete. Must have at least one entry.');
                return;
              }

              Account newAccount = account.copy();

              newAccount.history.removeAt(index);
              await AccountDatabase.updateAccount(context, newAccount: newAccount);
            },
            backgroundColor: MyColors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.lightAccent, width: 0.2))),
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yy').format(date),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
                Text(
                  valueString[0] == '-' ? ' -${settingsNotifier.currency}${valueString.substring(1)}' : '${settingsNotifier.currency}$valueString',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            _buildReturns(settingsNotifier, accountNotifier.currentAccount!),
          ],
        ),
      ),
    );
  }
}
