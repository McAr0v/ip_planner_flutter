import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/database/entities_managers/client_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/expenses_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/notes_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/payments_manager.dart';
import '../user/user_custom.dart';
import 'entities_managers/task_manager.dart';
import 'mixin_database.dart';

class DbInfoManager {

  static UserCustom currentUser = UserCustom.empty();

  static Future<void> getInfoFromDbAndUpdate(String uid) async {

    DataSnapshot? dbSnapshot = await MixinDatabase.getInfoFromDB(uid);

    if (dbSnapshot != null){

      currentUser = UserCustom.fromSnapshot(dbSnapshot.child('user_info'));
      TaskManager.updateTaskList(dbSnapshot.child('tasks'));
      ClientManager.updateClientList(dbSnapshot.child('clients'));
      PaymentsManager.updatePaymentsList(dbSnapshot.child('payments'));
      DealManager.updateDealList(dbSnapshot.child('deals'));
      NotesManager.updateNoteList(dbSnapshot.child('notes'));
      ExpensesManager.updateExpenseList(dbSnapshot.child('expenses'));

    }

  }

  static void clearAllInfoInManager() {
    currentUser = UserCustom.empty();
    TaskManager.tasksList.clear();
    ClientManager.clientsList.clear();
    PaymentsManager.paymentsList.clear();
    DealManager.dealsList.clear();
    NotesManager.notesList.clear();
    ExpensesManager.expensesList.clear();
  }








}