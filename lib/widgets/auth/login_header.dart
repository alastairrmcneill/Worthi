import 'package:flutter/material.dart';

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
            backgroundColor: Colors.red,
            // child: Image.asset('assets/images/plant_logo.png'),
          ),
          const SizedBox(height: 35),
          Text(
            'Welcome to Finance Master 3000!',
            style: Theme.of(context).textTheme.headline5,
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
