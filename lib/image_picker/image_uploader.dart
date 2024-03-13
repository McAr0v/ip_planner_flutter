import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// --- ФУНКЦИИ ЗАГРУЗКИ ИЗОБРАЖЕНИЙ В STORAGE ---

class ImageUploader {
  // Инициализируем Storage
  //final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String?> uploadImageInUser(String userId, File pickedFile) async {

    // Ссылка на ваш объект в Firebase Storage
    // PS - чтобы не забивать память, я решил, что я буду перезаписывать старую аватарку

    FirebaseStorage storage = FirebaseStorage.instance;

    final storageRef = storage.ref().child(userId).child('avatar').child('avatar_$userId.jpeg');

    // Выгружаем аватар
    final uploadTask = storageRef.putFile(File(pickedFile.path));

    // Дожидаемся завершения загрузки и получием URL загруженного файла
    final TaskSnapshot taskSnapshot = await uploadTask;
    final downloadURL = await taskSnapshot.ref.getDownloadURL();

    // Возвращаем URL загруженного файла
    return downloadURL;
  }


}