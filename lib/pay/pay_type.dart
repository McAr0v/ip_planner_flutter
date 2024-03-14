import 'package:ip_planner_flutter/pay/pay_type_enum.dart';

class PayType {
  PayTypeEnum payType;

  PayType({this.payType = PayTypeEnum.notChosen});

  void switchEnumFromString(String payType){
    switch (payType) {
      case "cash": this.payType = PayTypeEnum.cash;
      case "kaspi": this.payType = PayTypeEnum.kaspi;
      case "card": this.payType = PayTypeEnum.card;
      case "invoice": this.payType = PayTypeEnum.invoice;
      default: this.payType = PayTypeEnum.notChosen;
    }
  }

  String getPayTypeString({bool needTranslate = false}){
    switch (payType) {
      case PayTypeEnum.cash: return needTranslate == false ? "cash" : "Наличные";
      case PayTypeEnum.kaspi: return needTranslate == false ? "kaspi": "Оплата Kaspi";
      case PayTypeEnum.card: return needTranslate == false ? "card": "Карта";
      case PayTypeEnum.invoice: return needTranslate == false ? "invoice": "Счет на оплату";
      case PayTypeEnum.notChosen: return needTranslate == false ? "notChosen": "Не выбрано";
    }
  }

}