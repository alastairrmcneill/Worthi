import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moolah/screens/screens.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      // If user is not logged in then push to login screen
      return LoginScreen();
    } else {
      // If user is logged in then push to home screen
      return const HomeScreen();
    }
  }
}
