import 'package:flutter/material.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';

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
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
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
                  const AccountTypeFilter(),
                  IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openEndDrawer();
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AccountListView(),
              ),
              Container(
                height: 10,
                width: double.infinity,
                color: MyColors.darkAccent,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: ElevatedButton(
                  onPressed: () => showAddAccountDialog(context),
                  child: const Text('Add Account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
