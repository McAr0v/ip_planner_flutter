import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/abstract_classes/entity_from_db.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import '../database/mixin_database.dart';

class Note with DateMixin implements EntityFromDb{

  String id;
  String headline;
  String desc;
  String imageUrl;
  String idEntity;
  DateTime createDate;

  Note({required this.id, required this.headline, this.desc = '', this.idEntity = '', this.imageUrl = '', required this.createDate});

  factory Note.empty(){
    return Note(id: '', headline: '', createDate: DateTime(2100));
  }

  @override
  Map<String, dynamic> generateEntityDataCode() {
    return <String, dynamic> {
      'id': id,
      'headline': headline,
      'desc': desc,
      'imageUrl': imageUrl,
      'idEntity': idEntity,
      'createDate': DateMixin.generateDateString(createDate),
    };
  }

  factory Note.fromSnapshot(DataSnapshot snapshot) {

    return Note(
        id: snapshot.child('id').value.toString(),
        headline: snapshot.child('headline').value.toString(),
        createDate: DateMixin.getDateFromString(snapshot.child('createDate').value.toString()),
        idEntity: snapshot.child('idEntity').value.toString(),
        imageUrl: snapshot.child('imageUrl').value.toString(),
        desc: snapshot.child('desc').value.toString(),
    );

  }

  @override
  Future<String> publishToDb(String userId) async {
    String entityPath = '$userId/notes/$id';

    Map<String, dynamic> data = generateEntityDataCode();

    String entityPublishResult = await MixinDatabase.publishToDB(entityPath, data);

    return entityPublishResult;
  }

  @override
  Future<String> deleteFromDb(String userId) async {
    String entityPath = '$userId/notes/$id';

    String entityDeleteResult = await MixinDatabase.deleteFromDb(entityPath);

    return entityDeleteResult;
  }

}