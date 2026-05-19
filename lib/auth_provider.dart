import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isSignedIn = false;

  // User? get currentUser => _auth.currentUser;
  bool get currentUser => _isSignedIn;

  bool get isSignedIn => _isSignedIn;

  Future<void> signUpWithEmail(String email, String password) async {
    // await _auth.createUserWithEmailAndPassword(
    //   email: email,
    //   password: password,
    // );
    // Mock sign up - just set as signed in
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    // await _auth.signInWithEmailAndPassword(email: email, password: password);
    // Mock sign in - just set as signed in
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // if (googleUser == null) return;

    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // await _auth.signInWithCredential(credential);
    // Mock Google sign in
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    // await _auth.signOut();
    // await _googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
  }
}
