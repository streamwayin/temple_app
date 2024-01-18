import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  saveDataToFirestore() {}
  Future signInWithGoogle(BuildContext context, User phoneUser) async {
    // Trigger the authentication flow

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      // link google auth credentials with phone auth
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);

      User user = FirebaseAuth.instance.currentUser!;

      final map = {
        "photoUrl": user.photoURL,
        "email": user.email,
      };
      final database =
          FirebaseFirestore.instance.collection('users').doc(phoneUser.uid);
      await database.update(map);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for this email');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60));
  }

  Future addNameToUserCollection(String name) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final instance =
        await FirebaseFirestore.instance.collection('users').doc(uid);
    User user = FirebaseAuth.instance.currentUser!;
    final phoneNo = user.phoneNumber;

    final database =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    database.set({
      "name": name,
      "phoneNo": phoneNo,
      "uid": user.uid,
    });
  }
}
