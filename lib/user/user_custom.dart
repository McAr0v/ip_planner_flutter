import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import '../database/mixin_database.dart';

class UserCustom implements EntityFromDb {
  String uid;
  String email;
  String name;

  UserCustom({
    required this.uid,
    required this.email,
    required this.name,
  });

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/user_info';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;

  }

  @override
  Map<String, dynamic> generateEntityDataCode() {

    return <String, dynamic> {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory UserCustom.empty(){
    return UserCustom(uid: '', email: '', name: '');
  }

  factory UserCustom.fromSnapshot(DataSnapshot snapshot) {

    return UserCustom(
        uid: snapshot.child('uid').value.toString(),
      email: snapshot.child('email').value.toString(),
      name: snapshot.child('name').value.toString(),
    );

  }

  @override
  Future<String> deleteFromDb(String userId) {
    // TODO: implement deleteFromDb
    throw UnimplementedError();
  }
}