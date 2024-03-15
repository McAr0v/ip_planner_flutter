import 'package:ip_planner_flutter/clients/gender_enum.dart';

class Gender {
  GenderEnum gender;

  Gender({this.gender = GenderEnum.notChosen});

  void switchEnumFromString(String gender){
    switch (gender) {
      case "male": this.gender = GenderEnum.male;
      case "female": this.gender = GenderEnum.female;
      default: this.gender = GenderEnum.notChosen;
    }
  }

  String getGenderString({bool needTranslate = false}){
    switch (gender) {
      case GenderEnum.male: return needTranslate == false ? "male": "Мужчина";
      case GenderEnum.female: return needTranslate == false ? "female": "Женщина";
      case GenderEnum.notChosen: return needTranslate == false ? "notChosen": "Не выбрано";
    }
  }

}