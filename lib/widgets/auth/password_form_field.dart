import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  const PasswordFormField({Key? key, required this.textEditingController}) : super(key: key);

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: _obscureText ? const Icon(Icons.visibility_off_rounded) : const Icon(Icons.visibility_rounded),
        ),
      ),
      maxLines: 1,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        if (value.length < 5) {
          return 'Password needs to be greater than 6 characters';
        }
      },
      onSaved: (value) {
        widget.textEditingController.text = value!.trim();
      },
    );
  }
}
