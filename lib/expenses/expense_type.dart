import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/expenses/expense_type_enum.dart';
import '../design/text_widgets/text_custom.dart';

class ExpenseType {
  ExpenseTypeEnum expenseType;

  ExpenseType({this.expenseType = ExpenseTypeEnum.notChosen});

  void switchEnumFromString(String expenseType){
    switch (expenseType) {
      case "equipmentPurchase":
        this.expenseType = ExpenseTypeEnum.equipmentPurchase;
        break;
      case "supplies":
        this.expenseType = ExpenseTypeEnum.supplies;
        break;
      case "advertisingAndMarketing":
        this.expenseType = ExpenseTypeEnum.advertisingAndMarketing;
        break;
      case "rentExpense":
        this.expenseType = ExpenseTypeEnum.rentExpense;
        break;
      case "utilities":
        this.expenseType = ExpenseTypeEnum.utilities;
        break;
      case "insurance":
        this.expenseType = ExpenseTypeEnum.insurance;
        break;
      case "professionalDevelopment":
        this.expenseType = ExpenseTypeEnum.professionalDevelopment;
        break;
      case "transportation":
        this.expenseType = ExpenseTypeEnum.transportation;
        break;
      case "websiteHostingAndMaintenance":
        this.expenseType = ExpenseTypeEnum.websiteHostingAndMaintenance;
        break;
      case "softwareSubscriptions":
        this.expenseType = ExpenseTypeEnum.softwareSubscriptions;
        break;
      case "taxes":
        this.expenseType = ExpenseTypeEnum.taxes;
        break;
      case "professionalMemberships":
        this.expenseType = ExpenseTypeEnum.professionalMemberships;
        break;
      case "clientEntertainment":
        this.expenseType = ExpenseTypeEnum.clientEntertainment;
        break;
      case "officeSupplies":
        this.expenseType = ExpenseTypeEnum.officeSupplies;
        break;
      case "legalAndAccountingServices":
        this.expenseType = ExpenseTypeEnum.legalAndAccountingServices;
        break;
      case "other":
        this.expenseType = ExpenseTypeEnum.other;
        break;
      default:
        this.expenseType = ExpenseTypeEnum.notChosen;
        break;
    }
  }

  String getExpenseTypeString({bool needTranslate = false}) {
    switch (expenseType) {
      case ExpenseTypeEnum.equipmentPurchase:
        return needTranslate ? "Покупка оборудования" : "equipmentPurchase";
      case ExpenseTypeEnum.supplies:
        return needTranslate ? "Материалы" : "supplies";
      case ExpenseTypeEnum.advertisingAndMarketing:
        return needTranslate ? "Реклама и маркетинг" : "advertisingAndMarketing";
      case ExpenseTypeEnum.rentExpense:
        return needTranslate ? "Арендная плата" : "rentExpense";
      case ExpenseTypeEnum.utilities:
        return needTranslate ? "Коммунальные услуги" : "utilities";
      case ExpenseTypeEnum.insurance:
        return needTranslate ? "Страхование" : "insurance";
      case ExpenseTypeEnum.professionalDevelopment:
        return needTranslate ? "Профессиональное развитие" : "professionalDevelopment";
      case ExpenseTypeEnum.transportation:
        return needTranslate ? "Транспортные расходы" : "transportation";
      case ExpenseTypeEnum.websiteHostingAndMaintenance:
        return needTranslate ? "Хостинг и поддержка веб-сайта" : "websiteHostingAndMaintenance";
      case ExpenseTypeEnum.softwareSubscriptions:
        return needTranslate ? "Подписки на программное обеспечение" : "softwareSubscriptions";
      case ExpenseTypeEnum.taxes:
        return needTranslate ? "Налоги" : "taxes";
      case ExpenseTypeEnum.professionalMemberships:
        return needTranslate ? "Членские взносы в профессиональные организации" : "professionalMemberships";
      case ExpenseTypeEnum.clientEntertainment:
        return needTranslate ? "Развлечение клиентов" : "clientEntertainment";
      case ExpenseTypeEnum.officeSupplies:
        return needTranslate ? "Офисные принадлежности" : "officeSupplies";
      case ExpenseTypeEnum.legalAndAccountingServices:
        return needTranslate ? "Юридические и бухгалтерские услуги" : "legalAndAccountingServices";
      case ExpenseTypeEnum.other:
        return needTranslate ? "Прочее" : "other";
      default:
        return needTranslate ? "Не выбрано" : "notChosen";
    }
  }

  List<DropdownMenuItem<ExpenseTypeEnum>> getExpenseSortingOptionsList(){
    return [
      const DropdownMenuItem(
        value: ExpenseTypeEnum.notChosen,
        child: TextCustom(text: 'Не выбрано'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.equipmentPurchase,
        child: TextCustom(text: 'Покупка оборудования'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.supplies,
        child: TextCustom(text: 'Материалы'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.advertisingAndMarketing,
        child: TextCustom(text: 'Реклама и маркетинг'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.rentExpense,
        child: TextCustom(text: 'Арендная плата'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.utilities,
        child: TextCustom(text: 'Коммунальные услуги'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.insurance,
        child: TextCustom(text: 'Страхование'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.professionalDevelopment,
        child: TextCustom(text: 'Профессиональное развитие'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.transportation,
        child: TextCustom(text: 'Транспортные расходы'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.websiteHostingAndMaintenance,
        child: TextCustom(text: 'Хостинг и поддержка веб-сайта'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.softwareSubscriptions,
        child: TextCustom(text: 'Подписки на программное обеспечение'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.taxes,
        child: TextCustom(text: 'Налоги'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.professionalMemberships,
        child: TextCustom(text: 'Членские взносы'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.clientEntertainment,
        child: TextCustom(text: 'Развлечение клиентов'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.officeSupplies,
        child: TextCustom(text: 'Офисные принадлежности'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.legalAndAccountingServices,
        child: TextCustom(text: 'Юридические и бухгалтерские услуги'),
      ),
      const DropdownMenuItem(
        value: ExpenseTypeEnum.other,
        child: TextCustom(text: 'Прочее'),
      ),
    ];
  }

}