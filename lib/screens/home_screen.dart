import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moolah/notifiers/user_notifier.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(userNotifier.currentUser?.name ?? ''),
            ElevatedButton(
              child: Text('Sign out'),
              onPressed: () async {
                await AuthService.signOut(context);
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                await AuthService.delete(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
