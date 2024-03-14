import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';

class Pay implements EntityFromDb{

  String id;
  int sum;
  PayType payType;
  String idEntity;
  DateTime payDate;

  Pay({required this.id, required this.sum, required this.payType, required this.idEntity, required this.payDate});

  @override
  Map<String, dynamic> generateEntityDataCode() {
    // TODO: implement generateEntityDataCode
    throw UnimplementedError();
  }

  @override
  Future<String> publishToDb() {
    // TODO: implement publishToDb
    throw UnimplementedError();
  }

}