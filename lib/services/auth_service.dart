// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moolah/models/app_user_model.dart';
import 'package:moolah/services/services.dart';
import 'package:moolah/support/wrapper.dart';
import 'package:moolah/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth user stream
  static Stream<User?> get appUserStream {
    return _auth.authStateChanges();
  }

  // Get current user id
  static String? get userId {
    return _auth.currentUser?.uid;
  }

  // Register
  static Future registerWithEmail(BuildContext context, {required String name, required String email, required String password}) async {
    showCircularProgressOverlay(context);
    try {
      // Create user credential in firebase auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) return;

      AppUser appUser = AppUser(
        id: userCredential.user!.uid,
        name: name,
      );

      // Write this user to the database
      await UserDatabase.create(context, appUser: appUser);

      stopCircularProgressOverlay(context);

      // Push back to the wrapper
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error registering your account.");
    }
  }

  // Sign in
  static Future signInWithEmail(BuildContext context, {required String email, required String password}) async {
    showCircularProgressOverlay(context);

    // Sign in to firebase auth with email and password
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

    // Get google sign in credentials
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

    // Use the google auth to sign in to Firebase Auth
    try {
      if (credential == null) return;
      UserCredential result = await _auth.signInWithCredential(credential);

      AppUser appUser = AppUser(
        id: result.user!.uid,
        name: result.user!.displayName!,
      );

      // Write user to database
      await UserDatabase.create(context, appUser: appUser);
    } on FirebaseAuthException catch (error) {
      showErrorDialog(context, error.message ?? "There has been an error signing in.");
    }
  }

  // Apple sign in
  static Future signInWithApple(BuildContext context) async {
    // Get apple sign in credentials
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      OAuthCredential credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      // Sign in to Firebase Auth with those credentials
      UserCredential result = await _auth.signInWithCredential(credential);

      // Store correct name to firebase auth
      if (result.user!.displayName == null) {
        await result.user!
            .updateDisplayName(
              "${appleIdCredential.givenName ?? ""} ${appleIdCredential.familyName ?? ""}",
            )
            .whenComplete(
              () => result.user!.reload(),
            );
      }

      AppUser appUser = AppUser(
        id: result.user!.uid,
        name: result.user!.displayName!,
      );

      // Write to database
      await UserDatabase.create(context, appUser: appUser);
    } on FirebaseAuthException catch (error) {
      showErrorDialog(context, error.message ?? "There has been an error signing in.");
    } on Exception catch (_) {
      showErrorDialog(context, "There has been an error with Apple Sign In.");
    }
  }

  // Forgot password
  static Future forgotPassword(BuildContext context, {required String email}) async {
    showCircularProgressOverlay(context);

    // Use firebase auth to trigger password recovery email
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

    // If logged in with google sign in then sign out of google
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
    }
    try {
      // Sign out from Firebase Auth
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
      // Check if someone is logged in
      User? user = _auth.currentUser;
      if (user == null) return; // If not then return

      // Remove user from database
      await UserDatabase.deleteUser(context, id: user.uid);

      // Sign out from firebase auth
      await user.delete();

      stopCircularProgressOverlay(context);

      // Push back to wrapper
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()), (_) => false);
    } on FirebaseAuthException catch (error) {
      stopCircularProgressOverlay(context);
      showErrorDialog(context, error.message ?? "There has been an error deleting your account.");
    }
  }
}
