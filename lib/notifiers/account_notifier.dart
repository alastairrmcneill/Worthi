import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';

class AccountNotifier extends ChangeNotifier {
  List<Account>? _myAccounts;
  Account? _currentAccount;

  List<Account>? get myAccounts => _myAccounts;
  Account? get currentAccount => _currentAccount;

  set setMyAccounts(List<Account>? myAccounts) {
    _myAccounts = myAccounts;
    notifyListeners();
  }

  set setCurrentAccount(Account? currentAccount) {
    _currentAccount = currentAccount;
    notifyListeners();
  }
}
