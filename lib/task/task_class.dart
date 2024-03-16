import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/task/task_status.dart';
import '../database/mixin_database.dart';

class TaskCustom with DateMixin implements EntityFromDb{

  String id;
  String place;
  DateTime startDate;
  DateTime endDate;
  String comment;
  String label;
  String phone;
  String instagram;
  String clientId;
  DateTime createDate;
  TaskStatus status;

  TaskCustom({
    required this.id,
    this.place = '',
    required this.startDate,
    required this.endDate,
    this.comment = '',
    required this.label,
    this.phone = '',
    this.instagram = '',
    this.clientId = '',
    required this.createDate,
    required this.status
  });

  factory TaskCustom.empty(){
    return TaskCustom(
        id: '',
        startDate: DateTime(2100),
        endDate: DateTime(2100),
        label: '',
        createDate: DateTime(2100),
        status: TaskStatus()
    );
  }

  factory TaskCustom.fromSnapshot(DataSnapshot snapshot) {

    TaskStatus status = TaskStatus();
    status.switchEnumFromString(snapshot.child('status').value.toString());

    return TaskCustom(
        id: snapshot.child('id').value.toString(),
        startDate: DateTime.parse(snapshot.child('startDate').value.toString()),
        endDate: DateTime.parse(snapshot.child('endDate').value.toString()),
        label: snapshot.child('label').value.toString(),
        createDate: DateTime.parse(snapshot.child('createDate').value.toString()),
        place: snapshot.child('place').value.toString(),
        comment: snapshot.child('comment').value.toString(),
        phone: snapshot.child('phone').value.toString(),
        instagram: snapshot.child('instagram').value.toString(),
        clientId: snapshot.child('clientId').value.toString(),
        status: status
    );

  }

  @override
  Map<String, dynamic> generateEntityDataCode() {
    return <String, dynamic> {
      'id': id,
      'place': place,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'comment': comment,
      'label': label,
      'phone': phone,
      'instagram': instagram,
      'clientId': clientId,
      'createDate': createDate.toString(),
      'status': status.getTaskStatusString(),
    };
  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/tasks/$id';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;
  }

}