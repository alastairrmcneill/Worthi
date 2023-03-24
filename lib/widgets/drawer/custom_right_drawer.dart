import 'package:flutter/material.dart';
import 'package:moolah/screens/screens.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/theme.dart';
import 'package:moolah/widgets/widgets.dart';

// Drawer that expands on the right hand side of the screnen
class CustomRightDrawer extends StatelessWidget {
  const CustomRightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Currency drop down
              Row(
                children: const [
                  Text(
                    "Currency - ",
                    style: TextStyle(fontSize: 22),
                  ),
                  CurrencyDropDown(),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              // Archived accounts
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: const Text(
                  'Archived Accounts',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  size: 30,
                  color: MyColors.lightAccent,
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ArchivedAccountsScreen())),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),

              // Sign out button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthService.signOut(context);
                  },
                  child: const Text('Sign out'),
                ),
              ),
              const SizedBox(height: 10),

              // Delete account button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                  onPressed: () => showTwoButtonDialog(
                    context,
                    'Are you sure you want to delete your account?',
                    'OK',
                    () async {
                      await AuthService.delete(context);
                    },
                    'Cancel',
                    () {},
                  ),
                  child: const Text('Delete Account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
