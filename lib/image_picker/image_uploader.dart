import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// --- ФУНКЦИИ ЗАГРУЗКИ ИЗОБРАЖЕНИЙ В STORAGE ---

class ImageUploader {
  // Инициализируем Storage
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImageInUser(String userId, File pickedFile) async {

    final storageRef = _storage.ref().child(userId).child('avatar').child('avatar_$userId.jpeg');

    // Выгружаем аватар
    final uploadTask = storageRef.putFile(File(pickedFile.path));

    // Дожидаемся завершения загрузки и получием URL загруженного файла
    final TaskSnapshot taskSnapshot = await uploadTask;
    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Возвращаем URL загруженного файла
    return downloadURL;

  }

  static Future<String?> uploadImageInNote(String userId, String noteId, File pickedFile) async {

    final storageRef = _storage.ref().child(userId).child('notes/$noteId').child('noteImage_$noteId.jpeg');

    // Выгружаем аватар
    final uploadTask = storageRef.putFile(File(pickedFile.path));

    // Дожидаемся завершения загрузки и получием URL загруженного файла
    final TaskSnapshot taskSnapshot = await uploadTask;
    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Возвращаем URL загруженного файла
    return downloadURL;

  }

  static Future<String?> deleteImage(String imageUrl) async{

    final reference = _storage.refFromURL(imageUrl);
    try {
      // Удаляем файл
      await reference.delete();
      return 'ok';
    } catch (e) {
      return '$e';
    }

  }


}