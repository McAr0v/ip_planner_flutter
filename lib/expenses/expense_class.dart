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
  String comment;

  Expense({
    required this.id,
    required this.sum,
    required this.payType,
    required this.idEntity,
    required this.expenseType,
    required this.expenseDate,
    required this.comment
  });

  factory Expense.empty(){
    return Expense(
        id: '',
        sum: 0,
        payType: PayType(),
        idEntity: "",
        expenseDate: DateTime(2100),
        expenseType: ExpenseType(),
      comment: ''
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
      'comment': comment
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
        expenseDate: DateMixin.getDateFromString(snapshot.child('expenseDate').value.toString()),
      comment: snapshot.child('comment').value.toString(),
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
  Future<String> deleteFromDb(String userId) async {
    String entityPath = '$userId/expenses/$id';

    String entityDeleteResult = await MixinDatabase.deleteFromDb(entityPath);

    return entityDeleteResult;
  }

}

