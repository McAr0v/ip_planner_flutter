import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserCustom {
  String uid;
  String email;
  String name;
  String lastname;
  String phone;
  String gender;
  String avatar;

  // Статическая переменная для хранения текущего пользователя
  static UserCustom? currentUser;

  // --- ИНИЦИАЛИЗИРУЕМ БАЗУ ДАННЫХ -----
  //final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  UserCustom({
    required this.uid,
    required this.email,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.gender,
    required this.avatar,
  });

  factory UserCustom.empty(String uid, String email) {
    return UserCustom(
        uid: uid,
        email: email,
        name: '',
        lastname: '',
        phone: '',
        gender: '',
        avatar: 'https://firebasestorage.googleapis.com/v0/b/dvij-flutter.appspot.com/o/avatars%2Fdvij_unknow_user.jpg?alt=media&token=b63ea5ef-7bdf-49e9-a3ef-1d34d676b6a7',
    );
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
      await user?.sendEmailVerification();

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

  static Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      currentUser = null; // Обнуляем текущего пользователя при выходе

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

}