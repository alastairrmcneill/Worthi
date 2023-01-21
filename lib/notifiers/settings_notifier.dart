import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends ChangeNotifier {
  late SharedPreferences prefs;
  late String _currency;

  SettingsNotifier({required String currency}) {
    _currency = currency;
  }

  String get currency => _currency;

  Future<void> setCurrency(String currency) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    _currency = currency;
    notifyListeners();
  }
}
