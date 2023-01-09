import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  const NameFormField({Key? key, required this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: const InputDecoration(
        hintText: 'Name',
        prefixIcon: Icon(Icons.person_outline_rounded),
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
