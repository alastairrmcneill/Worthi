import 'package:flutter/material.dart';
import 'package:moolah/services/services.dart';

// Button for the regsiter screen to trigger user database creation
class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const RegisterButton({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  Future _register(BuildContext context) async {
    await AuthService.registerWithEmail(
      context,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
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
          await _register(context);
        },
        child: const Text('Register'),
      ),
    );
  }
}
