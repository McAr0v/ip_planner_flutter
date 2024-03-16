import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';

class DealCustom with DateMixin implements EntityFromDb{
  String id;
  String headline;
  String desc;
  String place;
  String clientName;
  String phone;
  String instagram;
  DateTime date;
  int price;
  DateTime createDate;

  DealCustom({
    required this.id,
    required this.headline,
    this.desc = '',
    this.place = '',
    this.clientName = '',
    this.phone = '',
    this.instagram = '',
    required this.date,
    required this.price,
    required this.createDate
  });

  @override
  Map<String, dynamic> generateEntityDataCode() {
    asd
    // TODO: implement generateEntityDataCode
    throw UnimplementedError();
  }

  @override
  Future<String> publishToDb(String userId) {
    // TODO: implement publishToDb
    throw UnimplementedError();
  }



}