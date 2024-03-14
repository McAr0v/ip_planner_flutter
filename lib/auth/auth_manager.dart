import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../database/database_info_manager.dart';

class AuthManager{

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<String> signOut() async {
    try {

      await auth.signOut();

      DbInfoManager.clearAllInfoInManager();

      return 'ok';
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> signInWithEmailAndPassword(
      String emailAddress,
      String password,
      BuildContext context
      ) async {
    try {

      final credential = await auth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return credential.user?.uid;

    } on FirebaseAuthException catch (e) {

      return e.code;

    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> resetPassword(String emailAddress) async {
    try {
      await auth.sendPasswordResetEmail(
        email: emailAddress,
      );

      return 'ok';

    } on FirebaseAuthException catch (e) {

      return e.code;

    } catch (e) {

      return null;

    }
  }

  static Future<String?> createUserWithEmailAndPassword(String emailAddress, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      User? user = credential.user;

      return user?.uid;

    } on FirebaseAuthException catch (e) {

      return e.code;

    } catch (e) {
      return e.toString();
    }
  }
}