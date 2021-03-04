import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:pluks_chat_app/models/user.dart';

class AuthClass {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User userFromFirebaseUser(auth.User user) {
    if (user != null) {
      return User(id: user.uid);
    } else {
      return null;
    }
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      auth.User firebaseUser = result.user;

      // Save user info to shared preference

      return userFromFirebaseUser(firebaseUser);
    } catch (e) {
      String errorMessage = e.toString();
      return errorMessage;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User firebaseUser = result.user;

      return userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
