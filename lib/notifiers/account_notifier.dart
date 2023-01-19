import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';

class AccountNotifier extends ChangeNotifier {
  List<Account>? _myAccounts;
  String? _filter;
  List<Account>? _filteredAccounts;
  Account? _currentAccount;

  List<Account>? get myAccounts => _myAccounts;
  List<Account>? get filteredAccounts => _filteredAccounts;
  String? get filter => _filter;
  Account? get currentAccount => _currentAccount;

  set setMyAccounts(List<Account>? myAccounts) {
    _myAccounts = myAccounts;
    setFilter = _filter;
    notifyListeners();
  }

  set setCurrentAccount(Account? currentAccount) {
    _currentAccount = currentAccount;
    notifyListeners();
  }

  set setFilter(String? type) {
    _filter = type;
    if (_filter == null) {
      _filteredAccounts = _myAccounts;
    } else if (_filter != null && _myAccounts != null) {
      _filteredAccounts = _myAccounts!.where((account) => account.type == _filter).toList();
    }
    notifyListeners();
  }
}
