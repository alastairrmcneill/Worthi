import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    await UserDatabase.getCurrentUser(context);
    await AccountDatabase.readAllAccounts(context);
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            accountNotifier.myAccounts == null
                ? Text("Loading")
                : Column(
                    children: [
                      ...accountNotifier.myAccounts!.map(
                        (e) {
                          return Text(e.name);
                        },
                      ).toList(),
                    ],
                  ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () async {
                await AccountDatabase.create(context, account: Account(name: 'Trading212', type: 'Invest', deposited: 500, value: 500, date: DateTime(2023, 1, 13), history: []));
              },
            ),
          ],
        ),
      ),
    );
  }
}
