import 'package:flutter/material.dart';
import 'package:moolah/screens/screens.dart';

// Button to navigate user to the register screen
class RegisterNowButton extends StatelessWidget {
  const RegisterNowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Not a member? '),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                child: const Text('Register now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
