import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';
import '../database/mixin_database.dart';

class Pay with DateMixin implements EntityFromDb{

  String id;
  int sum;
  PayType payType;
  String idEntity;
  DateTime payDate;

  Pay({required this.id, required this.sum, required this.payType, required this.idEntity, required this.payDate});

  factory Pay.empty(){
    return Pay(id: '', sum: 0, payType: PayType(), idEntity: "", payDate: DateTime(2100));
  }

  @override
  Map<String, dynamic> generateEntityDataCode() {
    return <String, dynamic> {
      'id': id,
      'sum': sum,
      'payType': payType.getPayTypeString(),
      'idEntity': idEntity,
      'payDate': DateMixin.generateDateString(payDate)
    };
  }

  factory Pay.fromSnapshot(DataSnapshot snapshot) {

    PayType payType = PayType();
    payType.switchEnumFromString(snapshot.child('payType').value.toString());

    return Pay(
        id: snapshot.child('id').value.toString(),
        sum: int.parse(snapshot.child('sum').value.toString()),
        payType: payType,
        idEntity: snapshot.child('idEntity').value.toString(),
        payDate: DateMixin.getDateFromString(snapshot.child('payDate').value.toString()),
    );

  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/payments/$id';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;
  }

  @override
  Future<String> deleteFromDb(String userId) {
    // TODO: implement deleteFromDb
    throw UnimplementedError();
  }

}