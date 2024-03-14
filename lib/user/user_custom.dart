import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';

import '../database/mixin_database.dart';

class UserCustom {
  String uid;
  String email;
  String name;

  // Статическая переменная для хранения текущего пользователя
  static UserCustom? currentUser;

  // --- ИНИЦИАЛИЗИРУЕМ БАЗУ ДАННЫХ -----
  //final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  UserCustom({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory UserCustom.empty(String uid, String email) {
    return UserCustom(
        uid: uid,
        email: email,
        name: '',
    );
  }

  Future<String> publishToDb() async {
    String entityPath = '$uid/user_info';

    Map<String, dynamic> data = _generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;

  }

  Map<String, dynamic> _generateEntityDataCode() {

    return <String, dynamic> {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  static Future<String?> resetPassword(String emailAddress) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailAddress,
      );

      // Если успешно отправлено письмо, возвращаем success
      return 'success';

    } on FirebaseAuthException catch (e) {

      // Если ошибки, возвращаем коды ошибок

      if (e.code == 'invalid-email') {
        return e.code;
      } else if (e.code == 'user-not-found') {
        return e.code;
      } else {
        print(e.code);

        return e.code;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> createUserWithEmailAndPassword(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Пользователь успешно создан
      User? user = credential.user;

      // Отправляем письмо с подтверждением
      //await user?.sendEmailVerification();

      // Возвращаем UID
      return user?.uid;

    } on FirebaseAuthException catch (e) {
      // --- Если ошибки, возвращаем коды ошибок ---
      if (e.code == 'weak-password') {
        return e.code;
      } else if (e.code == 'email-already-in-use') {
        return e.code;
      } else if (e.code == 'channel-error') {
        return e.code;
      } else if (e.code == 'invalid-email') {
        return e.code;
      } else {
        print(e.code);
        return null;
      }

    } catch (e) {
      print(e);
      // В случае исключения возвращаем null
      return null;
    }
  }

  static UserCustom getEmptyUser(){
    return UserCustom(uid: '', email: '', name: '');
  }

  static Future<String> signOut() async {
    try {

      await FirebaseAuth.instance.signOut();

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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Если пользователь успешно вошел, обновляем текущего пользователя
      //currentUser = await readUserDataAndWriteCurrentUser(credential.user!.uid);

      // и возвращаем uid
      return credential.user?.uid;

    } on FirebaseAuthException catch (e) {

      // Если ошибки, возвращаем коды ошибок

      //print('Ошибка - Firebase Auth Error: ${e.code} - ${e.message}');

      if (e.code == 'wrong-password') {

        return e.code;

      } else if (e.code == 'user-not-found') {

        return e.code;

      } else if (e.code == 'too-many-requests') {

        return e.code;

      } else if (e.code == 'channel-error') {

        return e.code;

      } else if (e.code == 'invalid-email') {

        return e.code;

      } else {

        print("КОД = ${e.code}");

        return null;

      }

    } catch (e) {
      print("КОД = ${e}");
      return null;
    }
  }

  factory UserCustom.fromSnapshot(DataSnapshot snapshot) {


    return UserCustom(
        uid: snapshot.child('uid').value.toString(),
      email: snapshot.child('email').value.toString(),
      name: snapshot.child('name').value.toString(),
    );
  }
}