import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/pay/pay_type_enum.dart';
import '../design/text_widgets/text_custom.dart';

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

  Color getPayTypeColor() {
    switch (payType) {
      case PayTypeEnum.cash:
        return Colors.green; // Зеленый для наличных
      case PayTypeEnum.kaspi:
        return AppColors.kaspi; // Цвет Kaspi
      case PayTypeEnum.card:
        return Colors.blue; // Синий для оплаты картой
      case PayTypeEnum.invoice:
        return Colors.orange; // Оранжевый для счета на оплату
      case PayTypeEnum.notChosen:
        return Colors.grey; // Серый для не выбранного типа
      default:
        return Colors.black; // Черный по умолчанию
    }
  }

  List<DropdownMenuItem<PayTypeEnum>> getPaySortingOptionsList(){
    return [
      const DropdownMenuItem(
        value: PayTypeEnum.notChosen,
        child: TextCustom(text: 'Не выбрано'),
      ),
      const DropdownMenuItem(
        value: PayTypeEnum.invoice,
        child: TextCustom(text: 'Счет на оплату'),
      ),
      const DropdownMenuItem(
        value: PayTypeEnum.card,
        child: TextCustom(text: 'Картой'),
      ),

      const DropdownMenuItem(
        value: PayTypeEnum.kaspi,
        child: TextCustom(text: 'На Каспи'),
      ),
      const DropdownMenuItem(
        value: PayTypeEnum.cash,
        child: TextCustom(text: 'Наличными'),
      ),
    ];
  }

}