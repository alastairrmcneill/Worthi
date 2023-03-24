import 'package:flutter/material.dart';

// Show custom snack bar with message input
showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
