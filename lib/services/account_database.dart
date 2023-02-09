import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/services/auth_service.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _usersRef = _db.collection('users');

  // Create account
  static Future create(BuildContext context, {required Account account}) async {
    String? userId = AuthService.userId;
    if (userId == null) {
      showErrorDialog(context, "Error: Logout and log back in to reset");
      return;
    }

    try {
      showCircularProgressOverlay(context);
      final DocumentReference ref = _usersRef.doc(userId).collection('accounts').doc();

      Account newAccount = account.copy(id: ref.id);

      Account encryptedAccount = newAccount.encryptData();

      await ref.set(encryptedAccount.toJSON());
      await readAllAccounts(context);
      stopCircularProgressOverlay(context);
      showSnackBar(context, 'Account added.');
    } on FirebaseException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message!);
    }
  }

  // Read account
  static Future readAccount(BuildContext context, {required String id}) async {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: false);
    Account? account;

    String? userId = AuthService.userId;
    if (userId == null) {
      showErrorDialog(context, "Error: Logout and log back in to reset");
      return;
    }

    try {
      DocumentReference ref = _usersRef.doc(userId).collection('accounts').doc(id);

      DocumentSnapshot docSnapshot = await ref.get();
      if (docSnapshot.exists) {
        account = Account.fromJSON(docSnapshot.data());
      }
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
    accountNotifier.setCurrentAccount = account;
  }

  // Read all accounts
  static Future readAllAccounts(BuildContext context) async {
    AccountNotifier accountNotifier = Provider.of<AccountNotifier>(context, listen: false);

    List<Account> accountsList = [];
    String? userId = AuthService.userId;
    if (userId == null) {
      showErrorDialog(context, "Error: Logout and log back in to reset");
      return;
    }

    try {
      Query ref = _usersRef.doc(userId).collection('accounts').orderBy(AccountFields.name, descending: false);

      QuerySnapshot querySnapshot = await ref.get();

      for (var account in querySnapshot.docs) {
        Account _account = Account.fromJSON(account.data());
        accountsList.add(_account);
      }
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
    accountNotifier.setMyAccounts = accountsList;
  }

  // Update account
  static Future updateAccount(BuildContext context, {required Account newAccount}) async {
    String? userId = AuthService.userId;
    if (userId == null) {
      showErrorDialog(context, "Error: Logout and log back in to reset");
      return;
    }
    try {
      DocumentReference ref = _usersRef.doc(userId).collection('accounts').doc(newAccount.id!);

      Account encryptedAccount = newAccount.encryptData();
      await ref.update(encryptedAccount.toJSON());
      await readAllAccounts(context);

      // await readAccount(context, id: newAccount.id!);
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
  }

  // Delete account
  static Future deleteAccount(BuildContext context, {required String id}) async {
    String? userId = AuthService.userId;
    if (userId == null) {
      showErrorDialog(context, "Error: Logout and log back in to reset");
      return;
    }
    try {
      DocumentReference ref = _usersRef.doc(userId).collection('accounts').doc(id);
      await ref.delete();
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
    await readAllAccounts(context);
    await readAccount(context, id: id);
  }
}
