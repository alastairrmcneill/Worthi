import 'package:flutter/material.dart';
import 'package:moolah/support/theme.dart';

// Custom name form field with validation included
class NameFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  const NameFormField({Key? key, required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      style: const TextStyle(color: MyColors.background),
      decoration: const InputDecoration(
        hintText: 'Name',
        prefixIcon: Icon(Icons.person_outline_rounded),
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
  }
}
