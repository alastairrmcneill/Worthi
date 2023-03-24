import 'package:flutter/material.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';
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
    super.initState();

    // Load data needed for app
    _loadData();
  }

  Future _loadData() async {
    // Load current user from data from database
    await UserDatabase.getCurrentUser(context);

    // Load the user accounts from the database
    await AccountDatabase.readAllAccounts(context);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    late SharedPreferences preferences;

    // Use the showcase package to highlight widgets for user onboarding
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

    // Call method to show user onboarding
    displayShowcase();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const CustomRightDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
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
                    const DividerBox(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: AccountListView(),
                    ),
                    const DividerBox(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
