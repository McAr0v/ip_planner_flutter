import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';

class DealManager{
  static List<DealCustom> dealsList = [];

  static void updateDealList(DataSnapshot snapshot){

    dealsList.clear();

    for (var idFolder in snapshot.children){

      DealCustom tempDeal = DealCustom.fromSnapshot(idFolder);
      if(tempDeal.id != '') dealsList.add(tempDeal);

    }
  }

  static void replaceChangedDealItem(DealCustom deal){
    for (int i = 0; i<dealsList.length; i++){
      if (dealsList[i].id == deal.id){
        dealsList[i] = deal;
      }
    }
  }

  static void removeFromDealList(String id){
    dealsList.removeWhere((element) => element.id == id);
  }

  static DealCustom getDeal(String id){
    for (DealCustom deal in dealsList){
      if (deal.id == id) return deal;
    }
    return DealCustom.empty();
  }

  /*static List<DealCustom> filterList (
      bool boolPending,
      bool boolCancelled,
      bool boolInProgress,
      bool boolCompleted,
      ){
    List<DealCustom> tempList = [];
    for (int i = 0; i < dealsList.length; i++){
      bool isAdd = dealsList[i].checkFilter(boolPending, boolCancelled, boolInProgress, boolCompleted);
      if (isAdd) tempList.add(dealsList[i]);
    }

    return tempList;
  }*/

  /*static List<DealCustom> sortList (TaskSortEnum taskSortEnumForFilter, List<TaskCustom> list) {

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

  }*/
}