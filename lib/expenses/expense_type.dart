import 'package:ip_planner_flutter/expenses/expense_type_enum.dart';

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
}