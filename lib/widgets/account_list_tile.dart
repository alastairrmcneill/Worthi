import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/screens/screens.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AccountListTile extends StatelessWidget {
  final Account account;
  const AccountListTile({super.key, required this.account});

  String _buildReturns() {
    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');
    if (account.type != AccountTypes.investment) return "0.00";

    double totalDepostied = account.history.first[AccountFields.deposited] as double;
    double totalValue = account.history.first[AccountFields.value] as double;

    String returnsString = formatCurrency.format(totalValue - totalDepostied);
    String percentString = (((totalValue - totalDepostied) / totalDepostied) * 100).toStringAsFixed(2);
    return '$returnsString ($percentString%)';
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');
    String name = account.name;
    String value = formatCurrency.format(account.history.first[AccountFields.value] as double);
    String lastUpdated = DateFormat('dd/MM/yy').format((account.history.first[AccountFields.date] as Timestamp).toDate());
    String returns = _buildReturns();

    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: false);
    SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);

    return GestureDetector(
      onTap: () {
        accountNotifier.setCurrentAccount = account;
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountDetailScreen()));
      },
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.lightAccent, width: 0.2))),
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: MyColors.accountColors[account.type],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Image.asset(
                "lib/icons/${account.type.toLowerCase()}.png",
                color: MyColors.accountAccentColors[account.type],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                    maxLines: 1,
                    maxFontSize: 24,
                    minFontSize: 20,
                  ),
                  Text(
                    'Last updated - $lastUpdated',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value[0] == '-' ? '-${settingsNotifier.currency}${value.substring(1)}' : '${settingsNotifier.currency}$value',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                Text(
                  account.type != AccountTypes.investment
                      ? ''
                      : returns[0] == '-'
                          ? '-${settingsNotifier.currency}${returns.substring(1)}'
                          : '${settingsNotifier.currency}$returns',
                  style: TextStyle(
                    color: returns[0] == '-' ? MyColors.redAccent : MyColors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
