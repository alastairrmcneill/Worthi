import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? labelText;
  CustomTextInput({super.key, required this.textEditingController, this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText ?? '',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      textInputAction: TextInputAction.next,
      maxLines: 1,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        int atIndex = value.indexOf('@');
        int periodIndex = value.lastIndexOf('.');
        if (!value.contains('@') || atIndex < 1 || periodIndex <= atIndex + 1 || value.length == periodIndex + 1) {
          return 'Not a valid email';
        }
      },
      onSaved: (value) {
        textEditingController.text = value!;
      },
    );
  }
}
