import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// Custom email form field with validation included
class EmailFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  const EmailFormField({Key? key, required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: MyColors.background),
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
        textEditingController.text = value!.trim();
      },
    );
  }
}
