import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/account_database.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

// class AccountHistoryListTile extends StatefulWidget {
//   final int index;
//   final Map<String, Object?> entry;
//   const AccountHistoryListTile({super.key, required this.index, required this.entry});

//   @override
//   State<AccountHistoryListTile> createState() => _AccountHistoryListTileState();
// }

// class _AccountHistoryListTileState extends State<AccountHistoryListTile> {
//   GlobalKey editEntryKey = GlobalKey();

//   Widget _buildReturns(SettingsNotifier settingsNotifier, Account account) {
//     if (account.type != AccountTypes.investment) return const SizedBox();

//     final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

//     double totalDepostied = account.history[widget.index][AccountFields.deposited] as double;
//     String depositedString = formatCurrency.format(totalDepostied);
//     double totalValue = account.history[widget.index][AccountFields.value] as double;

//     String returnsString = formatCurrency.format(totalValue - totalDepostied);
//     String percentString = (((totalValue - totalDepostied) / totalDepostied) * 100).toStringAsFixed(2);
//     String returns = '$returnsString ($percentString%)';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         Text(
//           depositedString[0] == '-' ? 'Deposited: -${settingsNotifier.currency}${depositedString.substring(1)}' : 'Deposited:  ${settingsNotifier.currency}$depositedString',
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//         RichText(
//           text: TextSpan(
//             text: 'Returns: ',
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: MyColors.lightAccent),
//             children: [
//               TextSpan(
//                 text: returns[0] == '-' ? '-${settingsNotifier.currency}${returns.substring(1)}' : '${settingsNotifier.currency}$returns',
//                 style: TextStyle(
//                   color: returns[0] == '-' ? MyColors.redAccent : MyColors.greenAccent,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
//     SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
//     DateTime date = (widget.entry[AccountFields.date] as Timestamp).toDate();
//     double value = widget.entry[AccountFields.value] as double;

//     final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');
//     String valueString = formatCurrency.format(value);

//     late SharedPreferences preferences;

//     displayShowcase() async {
//       preferences = await SharedPreferences.getInstance();
//       bool show = preferences.getBool("showEditEntryShowcase") ?? true;
//       if (show) {
//         WidgetsBinding.instance.addPostFrameCallback(
//           (_) => ShowCaseWidget.of(context).startShowCase([
//             editEntryKey,
//           ]),
//         );
//       }
//     }

//     displayShowcase();

//     return Showcase(
//       key: editEntryKey,
//       description: 'Swipe to edit or delete entry.',
//       child: Slidable(
//         endActionPane: ActionPane(
//           motion: const ScrollMotion(),
//           children: [
//             SlidableAction(
//               onPressed: (context) {
//                 Account account = accountNotifier.currentAccount!;
//                 showEditEntryDialog(context, account, widget.index);
//               },
//               backgroundColor: MyColors.greenAccent,
//               foregroundColor: Colors.white,
//               icon: Icons.edit,
//               label: 'Edit',
//             ),
//             SlidableAction(
//               onPressed: (context) async {
//                 Account account = accountNotifier.currentAccount!;
//                 if (account.history.length == 1) {
//                   showSnackBar(context, 'Cannot delete. Must have at least one entry.');
//                   return;
//                 }

//                 account.history.removeAt(widget.index);
//                 await AccountDatabase.updateAccount(context, newAccount: account);
//               },
//               backgroundColor: MyColors.redAccent,
//               foregroundColor: Colors.white,
//               icon: Icons.delete,
//               label: 'Delete',
//             ),
//           ],
//         ),
//         child: Container(
//           decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.lightAccent, width: 0.2))),
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     DateFormat('dd/MM/yy').format(date),
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
//                   ),
//                   Text(
//                     valueString[0] == '-' ? ' -${settingsNotifier.currency}${valueString.substring(1)}' : '${settingsNotifier.currency}$valueString',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
//                   ),
//                 ],
//               ),
//               _buildReturns(settingsNotifier, accountNotifier.currentAccount!),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AccountHistoryListTile extends StatelessWidget {
  final int index;
  final Map<String, Object?> entry;
  AccountHistoryListTile({super.key, required this.index, required this.entry});
  GlobalKey editEntryKey = GlobalKey();

  Widget _buildReturns(SettingsNotifier settingsNotifier, Account account) {
    if (account.type != AccountTypes.investment) return const SizedBox();

    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

    double totalDepostied = account.history[index][AccountFields.deposited] as double;
    String depositedString = formatCurrency.format(totalDepostied);
    double totalValue = account.history[index][AccountFields.value] as double;

    String returnsString = formatCurrency.format(totalValue - totalDepostied);
    String percentString = (((totalValue - totalDepostied) / totalDepostied) * 100).toStringAsFixed(2);
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
    double value = entry[AccountFields.value] as double;

    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');
    String valueString = formatCurrency.format(value);

    late SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool show = preferences.getBool("showEditEntryShowcase") ?? true;
      if (show) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
            editEntryKey,
          ]),
        );
      }
    }

    displayShowcase();

    return Showcase(
      key: editEntryKey,
      description: 'Swipe to edit or delete entry.',
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    valueString[0] == '-' ? ' -${settingsNotifier.currency}${valueString.substring(1)}' : '${settingsNotifier.currency}$valueString',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              _buildReturns(settingsNotifier, accountNotifier.currentAccount!),
            ],
          ),
        ),
      ),
    );
  }
}
