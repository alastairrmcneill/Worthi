import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class AccountHistoryListView extends StatefulWidget {
  const AccountHistoryListView({
    super.key,
  });

  @override
  State<AccountHistoryListView> createState() => _AccountHistoryListViewState();
}

class _AccountHistoryListViewState extends State<AccountHistoryListView> {
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    if (accountNotifier.currentAccount == null) return const Center(child: CircularProgressIndicator());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 5, left: 3, right: 3),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MyColors.blueAccent, width: 3))),
          child: const Text(
            "History",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 15),
        ...accountNotifier.currentAccount!.history.asMap().entries.map((e) {
          final index = e.key;
          final entry = e.value;

          return ShowCaseWidget(
            builder: Builder(builder: (_) => AccountHistoryListTile(index: index, entry: entry)),
            onFinish: () {
              prefs.setBool('showEditEntryShowcase', false);
            },
          );
        }).toList(),
      ],
    );
  }
}
