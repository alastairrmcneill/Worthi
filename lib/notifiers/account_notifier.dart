import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';

class AccountNotifier extends ChangeNotifier {
  List<Account>? _myAccounts;
  List<String> _filter = [];
  List<Account>? _filteredAccounts;
  List<Account>? _filteredArchivedAccounts;
  List<Account>? _filteredNotArchivedAccounts;
  List<Account>? _archivedAccounts;
  Account? _currentAccount;

  List<Account>? get myAccounts => _myAccounts;
  List<Account>? get filteredAccounts => _filteredAccounts;
  List<Account>? get archivedAccounts => _archivedAccounts;
  List<Account>? get filteredArchivedAccounts => _filteredArchivedAccounts;
  List<Account>? get filteredNotArchivedAccounts => _filteredNotArchivedAccounts;
  List<String> get filter => _filter;
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

  set setFilter(List<String> type) {
    _filter = type;
    if (_filter.isEmpty) {
      _filteredAccounts = _myAccounts;
    } else if (_filter != null && _myAccounts != null) {
      _filteredAccounts = _myAccounts!.where((account) => _filter.contains(account.type)).toList();
    }
    _archivedAccounts = _myAccounts!.where((account) => account.archived).toList();
    _filteredNotArchivedAccounts = _filteredAccounts?.where((account) => !account.archived).toList();
    _filteredArchivedAccounts = _filteredAccounts?.where((account) => account.archived).toList();
    notifyListeners();
  }
}
