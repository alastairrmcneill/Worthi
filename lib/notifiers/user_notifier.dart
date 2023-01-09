import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';

class UserNotifier extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  set setCurrentUser(AppUser currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }
}
