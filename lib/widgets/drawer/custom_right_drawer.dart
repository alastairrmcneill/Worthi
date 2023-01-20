import 'package:flutter/material.dart';

class CustomRightDrawer extends StatelessWidget {
  const CustomRightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
