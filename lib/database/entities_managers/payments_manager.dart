import 'package:firebase_database/firebase_database.dart';

import '../../pay/pay_class.dart';

class PaymentsManager {
  static List<Pay> paymentsList = [];

  static void updatePaymentsList(DataSnapshot snapshot){

    paymentsList.clear();

    for (var idFolder in snapshot.children){

      Pay tempPay = Pay.fromSnapshot(idFolder);
      if(tempPay.id != '') paymentsList.add(tempPay);

    }
  }

  static void replaceChangedPaymentItem(Pay pay){
    for (int i = 0; i<paymentsList.length; i++){
      if (paymentsList[i].id == pay.id){
        paymentsList[i] = pay;
      }
    }
  }

  static void removeFromPaymentsList(String id){
    paymentsList.removeWhere((element) => element.id == id);
  }

  static List<Pay> getPaymentsListForDeal(String dealId){
    List<Pay> tempList = [];
    for (int i = 0; i<paymentsList.length; i++){
      if (paymentsList[i].idEntity == dealId) tempList.add(paymentsList[i]);
    }
    return tempList;
  }

}