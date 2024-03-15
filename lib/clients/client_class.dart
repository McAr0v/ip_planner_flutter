import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import '../dates/date_mixin.dart';
import 'gender_class.dart';

class ClientCustom with MixinDatabase implements EntityFromDb{

  String name;
  String lastName;
  String phone;
  String instagram;
  String telegram;
  String whatsapp;
  DateTime createDate;
  DateTime birthDay;
  Gender gender;

  ClientCustom({
    required this.name,
    this.lastName = '',
    required this.phone,
    this.instagram = '',
    this.telegram = '',
    this.whatsapp = '',
    required this.createDate,
    required this.birthDay,
    required this.gender

  });

  factory ClientCustom.empty(){
    return ClientCustom(
        name: '',
        phone: '',
        createDate: DateTime(2100),
        birthDay: DateTime(2100),
        gender: Gender()
    );
  }

  factory ClientCustom.fromSnapshot(DataSnapshot snapshot) {

    Gender gender = Gender();
    gender.switchEnumFromString(snapshot.child('gender').value.toString());

    return ClientCustom(
        name: snapshot.child('name').value.toString(),
        lastName: snapshot.child('lastName').value.toString(),
        phone: snapshot.child('phone').value.toString(),
        instagram: snapshot.child('instagram').value.toString(),
        telegram: snapshot.child('telegram').value.toString(),
        whatsapp: snapshot.child('whatsapp').value.toString(),
        createDate: DateMixin.getDateFromString(snapshot.child('createDate').value.toString()),
        birthDay: DateMixin.getDateFromString(snapshot.child('birthDay').value.toString()),
        gender: gender,
    );

  }

  @override
  Map<String, dynamic> generateEntityDataCode() {
    return <String, dynamic> {
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'instagram': instagram,
      'telegram': telegram,
      'whatsapp': whatsapp,
      'createDate': DateMixin.generateDateString(createDate),
      'birthDay': DateMixin.generateDateString(birthDay),
      'gender': gender.getGenderString()
    };
  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/clients/$phone';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;
  }

}