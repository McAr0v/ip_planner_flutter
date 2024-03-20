import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/input_fields/input_field.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../database/mixin_database.dart';
import '../../design/app_colors.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../client_class.dart';
import '../gender_class.dart';


class ClientCreatePopup extends StatefulWidget {

  final ClientCustom? client;
  final bool? isEdit;

  const ClientCreatePopup({super.key, required this.client, this.isEdit});

  @override
  ClientCreatePopupState createState() => ClientCreatePopupState();
}

// -- Виджет отображения фильтра в мероприятиях ---

class ClientCreatePopupState extends State<ClientCreatePopup> {

  late bool loading;
  late bool saving;
  late bool edit;

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

    if (widget.isEdit != null) {
      edit = widget.isEdit!;
    } else {
      edit = false;
    }

    loading = true;
    saving = false;

    nameController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();
    telegramController = TextEditingController();
    whatsappController = TextEditingController();
    dateController = TextEditingController();

    birthday = DateTime(2100);
    createDate = DateTime.now();

    gender = Gender();


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
      body: Stack(
        children: [
          if (loading) const LoadingScreen()
          else if (saving) const LoadingScreen(loadingText: 'Идет сохранение',)
          else Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.blackLight,
                  borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                if (!edit) TextCustom(text: widget.client != null ? widget.client!.name : 'Создание клиента', textState: TextState.headlineSmall,),

                                if (edit) const TextCustom(text: 'Редактирование', textState: TextState.headlineSmall,),

                                const SizedBox(height: 10,),

                                if (widget.client == null) const TextCustom(text: 'Введите данные о клиенте', textState: TextState.labelMedium,),
                                if (widget.client != null && !edit) const TextCustom(text: 'Данные клиента', textState: TextState.labelMedium,),
                                if (widget.client != null && edit) const TextCustom(text: 'Отредактируйте данные клиента', textState: TextState.labelMedium,),

                              ],
                            )
                        ),

                        // --- Иконка ----

                        if (widget.client != null) IconButton(
                          icon: const Icon(FontAwesomeIcons.pencil, size: 18,),
                          onPressed: () {
                            setState(() {
                              edit = true;
                            });
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),

                    // ---- Содержимое фильтра -----

                    SingleChildScrollView (
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          InputField(
                              controller: nameController,
                              label: widget.client == null || edit  ? 'Имя (Обязательно)' : 'Имя',
                              textInputType: TextInputType.text,
                              active: widget.client == null || edit ? true : false,
                            icon: Icons.person,
                            needButton: (widget.client == null || edit) && nameController.text != '' && true,
                            activateButton: nameController.text != '',
                            onChanged: (value) {
                              setState(() {
                                nameController.text = value;
                              });
                            },
                            onButtonClick: (){
                              setState(() {
                                nameController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                          ),

                          const SizedBox(height: 20,),

                          InputField(
                            controller: phoneController,
                            label: 'Телефон',
                            textInputType: TextInputType.phone,
                            active: widget.client == null || edit ? true : false,
                            icon: Icons.phone,
                            needButton: (widget.client == null || edit) && phoneController.text != '' && true,
                            activateButton: phoneController.text != '',
                            onChanged: (value) {
                              setState(() {
                                phoneController.text = value;
                              });
                            },
                            onButtonClick: (){
                              setState(() {
                                phoneController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                          ),

                          const SizedBox(height: 20,),

                          InputField(
                            controller: whatsappController,
                            label: 'Whatsapp',
                            textInputType: TextInputType.phone,
                            active: widget.client == null || edit ? true : false,
                            icon: FontAwesomeIcons.whatsapp,
                            needButton: (widget.client == null || edit) && whatsappController.text != '' && true,
                            activateButton: whatsappController.text != '',
                            onChanged: (value) {
                              setState(() {
                                whatsappController.text = value;
                              });
                            },
                            onButtonClick: (){
                              setState(() {
                                whatsappController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                          ),

                          const SizedBox(height: 20,),

                          InputField(
                            controller: instagramController,
                            label: 'Instagram',
                            textInputType: TextInputType.text,
                            active: widget.client == null || edit ? true : false,
                            icon: FontAwesomeIcons.instagram,
                            needButton: (widget.client == null || edit) && instagramController.text != '' && true,
                            activateButton: instagramController.text != '',
                            onChanged: (value) {
                              setState(() {
                                instagramController.text = value;
                              });
                            },
                            onButtonClick: (){
                              setState(() {
                                instagramController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                          ),

                          const SizedBox(height: 20,),

                          InputField(
                            controller: telegramController,
                            label: 'Telegram',
                            textInputType: TextInputType.text,
                            active: widget.client == null || edit ? true : false,
                            icon: FontAwesomeIcons.telegram,
                            needButton: (widget.client == null || edit) && telegramController.text != '' && true,
                            activateButton: telegramController.text != '',
                            onChanged: (value) {
                              setState(() {
                                telegramController.text = value;
                              });
                            },
                            onButtonClick: (){
                              setState(() {
                                telegramController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                          ),

                          const SizedBox(height: 20,),

                          InputField(
                            controller: dateController,
                            label: 'День рождения',
                            textInputType: TextInputType.datetime,
                            active: widget.client == null || edit ? true : false,
                            needButton: (widget.client == null || edit) && birthday != DateTime(2100) ? true : false,
                            onFieldClick: () async {
                              _selectDate(context, birthday != DateTime(2100) ? birthday : DateTime.now());
                            },
                            onButtonClick: (){
                              setState(() {
                                birthday = DateTime(2100);
                                dateController.text = '';
                              });
                            },
                            iconForButton: FontAwesomeIcons.x,
                            icon: FontAwesomeIcons.calendarDays,
                            activateButton: widget.client == null || edit ? true : false,

                          ),

                        ],
                      ),
                    ),

                    if (widget.client == null || edit) const SizedBox(height: 30.0),

                    if (widget.client == null || edit) Row(
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

                            if (nameController.text.isNotEmpty){

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
                            } else {
                              showSnackBar('Имя должно быть обязательно заполнено!', AppColors.attentionRed, 2);
                            }

                            setState(() {
                              saving = false;
                            });

                          },
                        ),
                      ],
                    ),

                    if (widget.client == null || edit) const SizedBox(height: 10.0),

                  ],
                ),
              ),
            ],
          )
        ],
      )
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