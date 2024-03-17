import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import '../database/mixin_database.dart';

class DealCustom with DateMixin implements EntityFromDb{
  String id;
  String headline;
  String desc;
  String place;
  String clientPhone;
  DateTime date;
  int price;
  DateTime createDate;

  DealCustom({
    required this.id,
    required this.headline,
    this.desc = '',
    this.place = '',
    this.clientPhone = '',
    required this.date,
    required this.price,
    required this.createDate
  });

  factory DealCustom.empty(){
    return DealCustom(
        id: '',
        headline: '',
        date: DateTime(2100),
        price: 0,
        createDate: DateTime(2100),
        desc: '',
        place: '',
        clientPhone: ''
    );
  }

  factory DealCustom.fromSnapshot(DataSnapshot snapshot) {
    return DealCustom(
        id: snapshot.child('id').value.toString(),
        headline: snapshot.child('headline').value.toString(),
        date: DateTime.parse(snapshot.child('date').value.toString()),
        price: int.parse(snapshot.child('price').value.toString()),
        createDate: DateTime.parse(snapshot.child('createDate').value.toString()),
        desc: snapshot.child('desc').value.toString(),
        place: snapshot.child('place').value.toString(),
        clientPhone: snapshot.child('clientPhone').value.toString()
    );

  }

  @override
  Map<String, dynamic> generateEntityDataCode() {

    return <String, dynamic> {
      'id': id,
      'headline': headline,
      'date': date.toString(),
      'price': price,
      'createDate': createDate.toString(),
      'desc': desc,
      'place': place,
      'clientPhone': clientPhone,
    };
  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/deals/$id';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;
  }



}