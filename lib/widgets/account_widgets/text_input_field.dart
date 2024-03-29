import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// Custom text input form field with validation
class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  const TextInputField({super.key, required this.textEditingController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: MyColors.background),
      textCapitalization: TextCapitalization.words,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: 1,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
      },
      onSaved: (value) {
        textEditingController.text = value!.trim();
      },
    );
    ;
  }
}
