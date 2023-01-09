import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/models.dart';
import 'package:moolah/notifiers/notifiers.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UserDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _usersRef = _db.collection('users');

  // Create user
  static Future create(BuildContext context, {required AppUser appUser}) async {
    try {
      DocumentReference ref = _usersRef.doc(appUser.id!);
      await ref.set(appUser.toJSON());
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
  }

  // Read current user
  static Future getCurrentUser(BuildContext context) async {
    final User? user = Provider.of<User?>(context, listen: false);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

    if (user == null) return;

    try {
      DocumentReference ref = _usersRef.doc(user.uid);
      DocumentSnapshot snapshot = await ref.get();

      // Create app user
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        AppUser user = AppUser.fromJSON(data);

        // Update notifier
        userNotifier.setCurrentUser = user;
      }
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
  }

  // Read specfific user
  static Future<AppUser?> getSpecificUser(BuildContext context, {required String id}) async {
    AppUser? user;
    try {
      DocumentReference ref = _usersRef.doc(id);
      DocumentSnapshot snapshot = await ref.get();

      // Create app user
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
        AppUser user = AppUser.fromJSON(data);
        return user;
      }
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
    return null;
  }

  // Update user
  static Future updateUser(BuildContext context, {required AppUser newAppUser}) async {
    try {
      DocumentReference ref = _usersRef.doc(newAppUser.id);
      await ref.update(newAppUser.toJSON());
      await getCurrentUser(context);
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
  }

  // Delete user
  static Future deleteUser(BuildContext context, {required String id}) async {
    try {
      // Read database
      DocumentReference ref = _usersRef.doc(id);
      await ref.delete();
    } on FirebaseException catch (error) {
      showErrorDialog(context, error.message!);
    }
  }
}
