import 'package:flutter/material.dart';
import 'package:moolah/services/services.dart';

// Button for login page to trigger auth service
class SignInButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const SignInButton({Key? key, required this.formKey, required this.emailController, required this.passwordController}) : super(key: key);

  // Method to trigger the login functionality of the auth service
  Future _login(BuildContext context) async {
    await AuthService.signInWithEmail(
      context,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) {
            return;
          }
          formKey.currentState!.save();
          await _login(context);
        },
        child: const Text('Sign In'),
      ),
    );
  }
}
