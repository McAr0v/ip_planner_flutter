import 'package:firebase_database/firebase_database.dart';

mixin MixinDatabase{

  static FirebaseDatabase instance = FirebaseDatabase.instance;

  static Future<DataSnapshot?> getInfoFromDB(String path) async {
    try {
      final DatabaseReference reference = instance.ref().child(path);
      DataSnapshot snapshot = await reference.get();
      return snapshot;
    } catch (e) {
      return null;
    }
  }

  static Future<String> publishToDB(String path, Map<String, dynamic> data) async {
    try {
      await instance.ref().child(path).set(data);
      return 'ok';
    } catch (e) {
      return 'Ошибка при публикации данных: $e';
    }
  }

  static Map<String, dynamic> generateDataCode(String keyId, dynamic value) {
    return <String, dynamic> {
      keyId: value
    };
  }

  static Future<String> deleteFromDb(String path) async {
    try {
      final DatabaseReference reference = instance.ref().child(path);

      DataSnapshot snapshot = await reference.get();

      if (!snapshot.exists) {
        return 'Данные не найдены';
      }

      await reference.remove();

      return 'ok';

    } catch (error) {
      return 'Ошибка при удалении: $error';
    }
  }

  static String? generateKey() {
    return instance.ref().push().key;
  }
}