import 'package:flutter/material.dart';
import 'package:moolah/screens/screens.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
          child: const Text('Forgot Password'),
        ),
      ],
    );
  }
}
