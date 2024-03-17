import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import '../user/user_custom.dart';
import 'mixin_database.dart';

class DbInfoManager {

  static UserCustom currentUser = UserCustom.empty();

  static List<TaskCustom> tasksList = [];

  static Future<void> getInfoFromDbAndUpdate(String uid) async {

    DataSnapshot? dbSnapshot = await MixinDatabase.getInfoFromDB(uid);

    if (dbSnapshot != null){

      currentUser = UserCustom.fromSnapshot(dbSnapshot.child('user_info'));
      updateTaskList(dbSnapshot.child('tasks'));

    }

  }

  static void clearAllInfoInManager() {
    currentUser = UserCustom.empty();
  }

  static void updateTaskList(DataSnapshot snapshot){

    tasksList.clear();

    for (var idFolder in snapshot.children){

      TaskCustom tempTask = TaskCustom.fromSnapshot(idFolder);
      if(tempTask.id != '') tasksList.add(tempTask);

    }
  }


}