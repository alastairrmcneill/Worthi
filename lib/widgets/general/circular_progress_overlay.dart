import 'package:flutter/material.dart';

// Show the loading icon overlay
showCircularProgressOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
}

// Stop showing the loading icon overlay
stopCircularProgressOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
