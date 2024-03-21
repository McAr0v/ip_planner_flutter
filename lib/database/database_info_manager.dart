import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import 'package:ip_planner_flutter/task/task_status.dart';
import 'package:ip_planner_flutter/task/task_status_enum.dart';
import '../task/task_sort_enum.dart';
import '../user/user_custom.dart';
import 'mixin_database.dart';

class DbInfoManager {

  static UserCustom currentUser = UserCustom.empty();

  static List<TaskCustom> tasksList = [];
  static List<ClientCustom> clientsList = [];

  static Future<void> getInfoFromDbAndUpdate(String uid) async {

    DataSnapshot? dbSnapshot = await MixinDatabase.getInfoFromDB(uid);

    if (dbSnapshot != null){

      currentUser = UserCustom.fromSnapshot(dbSnapshot.child('user_info'));
      updateTaskList(dbSnapshot.child('tasks'));
      updateClientList(dbSnapshot.child('clients'));

    }

  }

  static void clearAllInfoInManager() {
    currentUser = UserCustom.empty();
    tasksList.clear();
    clientsList.clear();
  }

  static void updateTaskList(DataSnapshot snapshot){

    tasksList.clear();

    for (var idFolder in snapshot.children){

      TaskCustom tempTask = TaskCustom.fromSnapshot(idFolder);
      if(tempTask.id != '') tasksList.add(tempTask);

    }
  }

  static void replaceChangedTaskItem(TaskCustom task){
    for (int i = 0; i<tasksList.length; i++){
      if (tasksList[i].id == task.id){
        tasksList[i] = task;
      }
    }
  }

  static void removeFromTaskList(String id){
    tasksList.removeWhere((element) => element.id == id);
  }

  static List<TaskCustom> filterList (
      bool boolPending,
      bool boolCancelled,
      bool boolInProgress,
      bool boolCompleted,
      ){
    List<TaskCustom> tempList = [];
    for (int i = 0; i < tasksList.length; i++){
      bool isAdd = tasksList[i].checkFilter(boolPending, boolCancelled, boolInProgress, boolCompleted);
      if (isAdd) tempList.add(tasksList[i]);
    }

    return tempList;
  }

  static List<TaskCustom> sortList (TaskSortEnum taskSortEnumForFilter, List<TaskCustom> list) {

    List<TaskCustom> tempList = list;

    switch (taskSortEnumForFilter) {
      case TaskSortEnum.notChosen: tempList;
      case TaskSortEnum.nameAsc: tempList.sort((a,b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));
      case TaskSortEnum.nameDesc: tempList.sort((a,b) => b.label.toLowerCase().compareTo(a.label.toLowerCase()));
      case TaskSortEnum.statusAsc: tempList.sort((a,b) => a.status.getTaskStatusString(needTranslate: true).toLowerCase().compareTo(b.status.getTaskStatusString(needTranslate: true).toLowerCase()));
      case TaskSortEnum.statusDesc: tempList.sort((a,b) => b.status.getTaskStatusString(needTranslate: true).toLowerCase().compareTo(a.status.getTaskStatusString(needTranslate: true).toLowerCase()));
      case TaskSortEnum.startDateAsc: tempList.sort((a,b) => a.startDate.compareTo(b.startDate));
      case TaskSortEnum.startDateDesc: tempList.sort((a,b) => b.startDate.compareTo(a.startDate));
      case TaskSortEnum.endDateAsc: tempList.sort((a,b) => a.endDate.compareTo(b.endDate));
      case TaskSortEnum.endDateDesc: tempList.sort((a,b) => b.endDate.compareTo(a.endDate));
    }

    return tempList;

  }

  static void updateClientList(DataSnapshot snapshot){

    clientsList.clear();

    for (var idFolder in snapshot.children){

      ClientCustom tempClient = ClientCustom.fromSnapshot(idFolder);
      if(tempClient.id != '') clientsList.add(tempClient);

    }
  }

  static void replaceChangedClientItem(ClientCustom client){
    for (int i = 0; i<clientsList.length; i++){
      if (clientsList[i].id == client.id){
        clientsList[i] = client;
      }
    }
  }

  static void removeFromClientList(String id){
    clientsList.removeWhere((element) => element.id == id);
  }


}