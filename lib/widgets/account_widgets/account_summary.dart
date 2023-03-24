import 'package:flutter/material.dart';
import 'package:moolah/models/account_model.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Widget for the top fo the account detail screen
class AccountSummary extends StatelessWidget {
  const AccountSummary({super.key});

  // Build the widget for returns
  Widget _buildReturns(SettingsNotifier settingsNotifier, Account account) {
    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

    double? totalDeposited = double.tryParse(account.history.first[AccountFields.deposited].toString());
    totalDeposited ??= EncryptionService.decryptToDouble(account.history.first[AccountFields.deposited] as String);

    String depositedString = formatCurrency.format(totalDeposited);

    double? totalValue = double.tryParse(account.history.first[AccountFields.value].toString());
    totalValue ??= EncryptionService.decryptToDouble(account.history.first[AccountFields.value] as String);

    String returnsString = formatCurrency.format(totalValue - totalDeposited);
    String percentString = (((totalValue - totalDeposited) / totalDeposited) * 100).toStringAsFixed(2);
    if (percentString == "NaN") percentString = "0";
    String returns = '$returnsString ($percentString%)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          depositedString[0] == '-' ? 'Deposited: -${settingsNotifier.currency}${depositedString.substring(1)}' : 'Deposited:  ${settingsNotifier.currency}$depositedString',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        RichText(
          text: TextSpan(
            text: 'Returns: ',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: MyColors.lightAccent),
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
    SettingsNotifier settingsNotifier = Provider.of<SettingsNotifier>(context);
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    Account account = accountNotifier.currentAccount!;

    final NumberFormat formatCurrency = NumberFormat.currency(symbol: '');

    double? balanceNumber = double.tryParse(account.history.first[AccountFields.value].toString());
    balanceNumber ??= EncryptionService.decryptToDouble(account.history.first[AccountFields.value] as String);

    String balance = formatCurrency.format(balanceNumber);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                account.type,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MyColors.lightAccentDarker),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            balance[0] == '-' ? ' -${settingsNotifier.currency}${balance.substring(1)}' : '${settingsNotifier.currency}$balance',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
          account.type != AccountTypes.investment ? const SizedBox() : const SizedBox(height: 20),
          account.type != AccountTypes.investment ? const SizedBox() : _buildReturns(settingsNotifier, account),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
