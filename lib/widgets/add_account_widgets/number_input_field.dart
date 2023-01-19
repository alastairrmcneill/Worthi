import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NumberInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  const NumberInputField({super.key, required this.textEditingController, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: 1,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputFormatters: [
// Regex to allow only "numbers", "dot" and "minus".
        FilteringTextInputFormatter(RegExp("[0-9.-]"), allow: true),

        TextInputFormatter.withFunction((TextEditingValue oldValue, TextEditingValue newValue) {
          final newValueText = newValue.text;

          if (newValueText == "-" || newValueText == "-." || newValueText == ".") {
            // Returning new value if text field contains only "." or "-." or ".".
            return newValue;
          } else if (newValueText.isNotEmpty) {
            // If text filed not empty and value updated then trying to parse it as a double.
            try {
              double.parse(newValueText);
              // Here double parsing succeeds so returning that new value.
              return newValue;
            } catch (e) {
              // Here double parsing failed so returning that old value.
              return oldValue;
            }
          } else {
            // Returning new value if text field was empty.
            return newValue;
          }
        }),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        } else {
          try {
            double.parse(value);
            // Here double parsing succeeds so returning that new value.
            return null;
          } catch (e) {
            // Here double parsing failed so returning that old value.
            return 'Please enter watermark rotation angle';
          }
        }
      },
      onSaved: (value) {
        textEditingController.text = value!.trim();
      },
    );
    ;
  }
}
