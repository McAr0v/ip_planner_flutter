import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';
import '../database/mixin_database.dart';
import 'expense_type.dart';

class Expense with DateMixin implements EntityFromDb{

  String id;
  int sum;
  PayType payType;
  ExpenseType expenseType;
  String idEntity;
  DateTime expenseDate;

  Expense({
    required this.id,
    required this.sum,
    required this.payType,
    required this.idEntity,
    required this.expenseType,
    required this.expenseDate
  });

  factory Expense.empty(){
    return Expense(
        id: '',
        sum: 0,
        payType: PayType(),
        idEntity: "",
        expenseDate: DateTime(2100),
        expenseType: ExpenseType(),
    );
  }

  @override
  Map<String, dynamic> generateEntityDataCode() {
    return <String, dynamic> {
      'id': id,
      'sum': sum,
      'payType': payType.getPayTypeString(),
      'idEntity': idEntity,
      'expenseDate': DateMixin.generateDateString(expenseDate),
      'expenseType': expenseType.getExpenseTypeString(),
    };
  }

  factory Expense.fromSnapshot(DataSnapshot snapshot) {

    PayType payType = PayType();
    payType.switchEnumFromString(snapshot.child('payType').value.toString());

    ExpenseType expenseType = ExpenseType();
    expenseType.switchEnumFromString(snapshot.child('expenseType').value.toString());

    return Expense(
        id: snapshot.child('id').value.toString(),
        sum: int.parse(snapshot.child('sum').value.toString()),
        payType: payType,
        idEntity: snapshot.child('idEntity').value.toString(),
        expenseType: expenseType,
        expenseDate: DateMixin.getDateFromString(snapshot.child('expenseDate').value.toString())
    );

  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/expenses/$id';

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

