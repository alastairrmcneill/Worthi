import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey addAccountKey = GlobalKey();
  final GlobalKey filterAccountsKey = GlobalKey();
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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    late SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool show = preferences.getBool("showHomePageShowcase") ?? true;
      if (show) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
            addAccountKey,
            filterAccountsKey,
          ]),
        );
      }
    }

    displayShowcase();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const CustomRightDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 75),
                  Showcase(
                    key: filterAccountsKey,
                    description: 'Then filter for the type you want to show.',
                    child: const AccountTypeFilter(),
                  ),
                  IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                      icon: const Icon(Icons.menu, size: 24)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TotalValue(),
                  ],
                ),
              ),
              const Chart(),
              Container(
                height: 10,
                width: double.infinity,
                color: MyColors.darkAccent,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: AccountListView(),
              ),
              Container(
                height: 10,
                width: double.infinity,
                color: MyColors.darkAccent,
              ),
              const SizedBox(height: 10),
              Showcase(
                key: addAccountKey,
                description: 'Start by adding an account.',
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                    onPressed: () => showAddAccountDialog(context),
                    child: const Text('Add Account'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
