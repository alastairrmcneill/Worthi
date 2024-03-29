import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// Widget for the top of the login screen with app name and icon
class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 15),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            child: Image.asset(
              "lib/icons/logo.png",
              color: MyColors.blueAccent,
            ),
          ),
          const SizedBox(height: 35),
          Text(
            'Worthi',
            style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 5),
          Text(
            'Please enter your details',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
