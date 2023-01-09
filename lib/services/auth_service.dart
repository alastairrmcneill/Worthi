import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moolah/support/wrapper.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth user stream
  static Stream<User?> get appUserStream {
    return _auth.authStateChanges();
  }

  // Register
  static Future registerWithEmail(BuildContext context, {required String name, required String email, required String password}) async {
    showCircularProgressOverlay(context);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error registering your account.");
    }
  }

  // Sign in
  static Future signInWithEmail(BuildContext context, {required String email, required String password}) async {
    showCircularProgressOverlay(context);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      stopCircularProgressOverlay(context);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error signing in.");
    }
  }

  // Google sign in
  static Future signInWithGoogle(BuildContext context) async {
    OAuthCredential? credential;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } on Exception catch (e) {
      showErrorDialog(context, "There has been an error with Google Sign In.");
    }

    showCircularProgressOverlay(context);
    try {
      if (credential == null) return;
      await _auth.signInWithCredential(credential);
      stopCircularProgressOverlay(context);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error signing in.");
    }
  }

  // Forgot password
  static Future forgotPassword(BuildContext context, {required String email}) async {
    showCircularProgressOverlay(context);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Password retreival email sent');
      stopCircularProgressOverlay(context);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message!);
    }
  }

  // Sign out
  static Future signOut(BuildContext context) async {
    showCircularProgressOverlay(context);
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
    }
    try {
      await _auth.signOut();
      stopCircularProgressOverlay(context);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error signing out.");
    }
  }

  // Delete
  static Future delete(BuildContext context) async {
    showCircularProgressOverlay(context);
    try {
      await _auth.currentUser!.delete();
      stopCircularProgressOverlay(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error deleting your account.");
    }
  }
}
