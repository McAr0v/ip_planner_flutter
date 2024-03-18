import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../../database/mixin_database.dart';
import '../../design/app_colors.dart';
import '../../design/buttons/custom_button.dart';
import '../../design/date_widgets/date_time_picker.dart';
import '../../design/input_fields/input_field_with_add.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../client_class.dart';
import '../gender_class.dart';


class ClientCreatePopup extends StatefulWidget {

  final ClientCustom? client;

  const ClientCreatePopup({super.key, required this.client});

  @override
  ClientCreatePopupState createState() => ClientCreatePopupState();
}

// -- Виджет отображения фильтра в мероприятиях ---

class ClientCreatePopupState extends State<ClientCreatePopup> {

  late bool loading;
  late bool saving;
  late bool showNumber;
  late bool showInstagram;
  late bool showTelegram;
  late bool showWhatsapp;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController instagramController;
  late TextEditingController telegramController;
  late TextEditingController whatsappController;
  late TextEditingController dateController;
  late DateTime birthday;
  late DateTime createDate;
  late Gender gender;

  late String id;

  @override
  void initState() {
    super.initState();

    _initializeData();

  }

  Future<void> _initializeData() async {

    loading = true;
    saving = false;

    showNumber = false;
    showInstagram = false;
    showWhatsapp = false;
    showTelegram = false;

    nameController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();
    telegramController = TextEditingController();
    whatsappController = TextEditingController();
    dateController = TextEditingController();

    birthday = DateTime(2100);
    createDate = DateTime.now();

    gender = Gender();

    dateController.text = 'День рождения не выбран';

    if (widget.client != null) {

      createDate = widget.client!.createDate;

      id = widget.client!.id;

      nameController.text = widget.client!.name;
      phoneController.text = widget.client!.phone;
      instagramController.text = widget.client!.instagram;
      telegramController.text = widget.client!.telegram;
      whatsappController.text = widget.client!.whatsapp;

      if (widget.client!.birthDay != DateTime(2100)){
        dateController.text = DateMixin.getHumanDateFromDateTime(widget.client!.birthDay);
      }


      birthday = widget.client!.birthDay;

      gender = widget.client!.gender;

      if (widget.client!.phone.isNotEmpty){
        showNumber = true;
      }
      if (widget.client!.instagram.isNotEmpty){
        showInstagram = true;
      }
      if (widget.client!.telegram.isNotEmpty){
        showTelegram = true;
      }


      if (widget.client!.whatsapp.isNotEmpty){
        showWhatsapp = true;
      }


    } else {
      id = MixinDatabase.generateKey()!;

    }

    loading = false;
  }

  // ---- САМ ЭКРАН ФИЛЬТРА -----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black.withOpacity(0.6),
      body: Center(
        child: Stack(
          children: [
            if (saving) const Expanded(
                child: LoadingScreen()
            ),

            if (!saving) Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.blackLight,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---- Заголовок фильтра и иконка ---


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                TextCustom(text: 'Создание клиента', textState: TextState.headlineSmall,),

                                SizedBox(height: 10,),

                                TextCustom(text: 'Введи данные о клиенте', textState: TextState.labelMedium,),

                              ],
                            )
                        )
                    ),

                    // --- Иконка ----

                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8.0),

                // ---- Содержимое фильтра -----



                 Expanded(
                  child: SingleChildScrollView (
                    child: Container (
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.blackLight,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: nameController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Имя (Обязательно)',
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 20,),

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: phoneController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Телефон',
                              prefixIcon: Icon(Icons.phone),

                            ),
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 20,),

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: whatsappController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Whatsapp',
                              prefixIcon: Icon(FontAwesomeIcons.whatsapp),

                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 20,),

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: instagramController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Instagram',
                              prefixIcon: Icon(FontAwesomeIcons.instagram),

                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 20,),

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: telegramController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Telegram',
                              prefixIcon: Icon(FontAwesomeIcons.telegram),

                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 20,),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                    fontFamily: 'sf_custom',
                                    fontWeight: FontWeight.normal,
                                  ),
                                  controller: dateController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    labelText: 'День рождения',
                                    prefixIcon: Icon(FontAwesomeIcons.cakeCandles),

                                  ),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              const SizedBox(width: 10.0),

                              GestureDetector(
                                onTap: (){
                                  _selectDate(context, birthday != DateTime(2100) ? birthday : DateTime.now());
                                },
                                child: Card(
                                  color: AppColors.yellowLight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Icon(FontAwesomeIcons.pencil, size: 18, color: AppColors.black,),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    GestureDetector(
                      child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                      onTap: (){Navigator.of(context).pop();},
                    ),

                    const SizedBox(width: 30.0),

                    GestureDetector(
                      child: const TextCustom(text: 'Сохранить', color: Colors.green,),
                      onTap: () async {

                        setState(() {
                          saving = true;
                        });

                        ClientCustom tempClient = ClientCustom(
                            id: id,
                            name: nameController.text,
                            phone: phoneController.text,
                            createDate: createDate,
                            birthDay: birthday,
                            gender: gender,
                            whatsapp: whatsappController.text,
                            instagram: instagramController.text,
                            telegram: telegramController.text

                        );

                        String result = await tempClient.publishToDb(DbInfoManager.currentUser.uid);

                        if (result == 'ok'){

                          if (widget.client != null) {
                            DbInfoManager.clientsList.removeWhere((element) => element.id == tempClient.id);
                          }

                          DbInfoManager.clientsList.add(tempClient);

                          showSnackBar('Клиент успешно опубликован!', Colors.green, 2);

                          returnWithResult(tempClient);

                        } else {

                          showSnackBar('Произошла ошибка - $result', AppColors.attentionRed, 2);

                        }

                        setState(() {
                          saving = false;
                        });

                      },
                    ),

                    const SizedBox(width: 10.0),

                  ],
                ),

                const SizedBox(height: 10.0),

              ],
            ),
          ),]
        ),
      ),
    );
  }

  void returnWithResult(ClientCustom client){
    Navigator.of(context).pop(client);
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _selectDate(BuildContext context, DateTime initial) async {

    final DateTime? picked = await showDatePicker(

      //locale: const Locale('ru', 'RU'),
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
      helpText: 'Выбери дату',
      cancelText: 'Отмена',
      confirmText: 'Подтвердить',
      keyboardType: TextInputType.datetime,
      currentDate: DateTime.now(),
    );

    if (picked != null){
      setState(() {
        birthday = picked;
        dateController.text = DateMixin.getHumanDateFromDateTime(birthday);

      });
    }
  }

}