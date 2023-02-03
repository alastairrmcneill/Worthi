import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moolah/services/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SignInWithAppleButton(
        onPressed: () async {
          await AuthService.signInWithApple(context);
        },
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      );
    } else {
      return const SizedBox();
    }
  }
}
