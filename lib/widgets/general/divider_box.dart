import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// Dark box to divide widgets
class DividerBox extends StatelessWidget {
  const DividerBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: double.infinity,
      color: MyColors.darkAccent,
    );
  }
}
