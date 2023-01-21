import 'package:flutter/material.dart';
import 'package:moolah/services/auth_service.dart';
import 'package:moolah/widgets/widgets.dart';

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
              const SizedBox(height: 20),
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
