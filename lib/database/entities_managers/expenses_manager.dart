import 'package:firebase_database/firebase_database.dart';
import 'package:ip_planner_flutter/expenses/expense_class.dart';
import 'package:ip_planner_flutter/note/note_class.dart';

import '../../clients/client_class.dart';

class ExpensesManager{

  static List<Expense> expensesList = [];

  static void updateExpenseList(DataSnapshot snapshot){

    expensesList.clear();

    for (var idFolder in snapshot.children){

      Expense tempExpense = Expense.fromSnapshot(idFolder);
      if(tempExpense.id != '') expensesList.add(tempExpense);

    }
  }

  static void replaceChangedExpenseItem(Expense expense){
    for (int i = 0; i<expensesList.length; i++){
      if (expensesList[i].id == expense.id){
        expensesList[i] = expense;
      }
    }
  }

  static void removeFromExpensesList(String id){
    expensesList.removeWhere((element) => element.id == id);
  }

  static Expense getExpenseFromList(String id){
    for (int i = 0; i<expensesList.length; i++){
      if (expensesList[i].id == id) return expensesList[i];
    }
    return Expense.empty();
  }

  static List<Expense> getExpensesListForDeal(String dealId){
    List<Expense> tempList = [];
    for (int i = 0; i<expensesList.length; i++){
      if (expensesList[i].idEntity == dealId) tempList.add(expensesList[i]);
    }
    return tempList;
  }

}