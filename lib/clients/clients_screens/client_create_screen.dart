import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/dates/choose_date_popup.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/date_widgets/date_time_picker.dart';
import 'package:ip_planner_flutter/design/input_fields/input_field_with_add.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import '../../design/app_colors.dart';
import '../../design/buttons/button_state.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../gender_class.dart';

class ClientCreateScreen extends StatefulWidget {
  final ClientCustom? client;
  const ClientCreateScreen({super.key, this.client});

  @override
  ClientCreateScreenState createState() => ClientCreateScreenState();

}

class ClientCreateScreenState extends State<ClientCreateScreen> {



  late bool loading;
  late bool showNumber;
  late bool showInstagram;
  late bool showTelegram;
  late bool showWhatsapp;

  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController instagramController;
  late TextEditingController telegramController;
  late TextEditingController whatsappController;
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

    showNumber = false;
    showInstagram = false;
    showWhatsapp = false;

    nameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();
    telegramController = TextEditingController();
    whatsappController = TextEditingController();

    birthday = DateTime(2100);
    createDate = DateTime.now();

    gender = Gender();

    if (widget.client != null) {

      createDate = widget.client!.createDate;

      id = widget.client!.id;

      nameController.text = widget.client!.name;
      lastNameController.text = widget.client!.lastName;
      phoneController.text = widget.client!.phone;
      instagramController.text = widget.client!.instagram;
      telegramController.text = widget.client!.telegram;
      whatsappController.text = widget.client!.whatsapp;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.green,
          title: TextCustom(text: widget.client != null ? widget.client!.name : 'Создание клиента', textState: TextState.bodyBig, color: AppColors.white, weight: FontWeight.bold,),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.chevronLeft, size: 18,),

            // Переход на страницу создания города
            onPressed: () {
              goToClientsListScreen();
            },
          ),
        ),
        body: Stack(
          children: [
            if (loading) const LoadingScreen()
            else SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
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
                        prefixIcon: Icon(Icons.task),

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
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        labelText: 'Фамилия',
                        prefixIcon: Icon(Icons.comment),

                      ),
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 20,),

                    DateTimePickerWidget(
                      date: birthday,
                      desc: "Дата рождения",
                      addDate: () async {
                        DateTime? result = await _showDateDialog(context, birthday);
                        if (result != null) {
                          setState(() {
                            birthday = result;
                          });
                        }
                      },
                      clearDate: (){
                        setState(() {
                          birthday = DateTime(2100);
                        });
                      },
                    ),

                    const SizedBox(height: 20,),

                    InputFieldWithAdd(
                      controller: phoneController,
                      label: 'Телефон',
                      headlineAdd: 'Добавить контактный телефон',
                      textInputType: TextInputType.phone,
                      onAddFunction: (){
                        setState(() {
                          showNumber = true;
                        });
                      },
                      onClearFunction: (){
                        setState(() {
                          showNumber = false;
                          phoneController.text = '';
                        });
                      },
                      addOrClear: showNumber,
                      icon: Icons.phone,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20,),

                    InputFieldWithAdd(
                      controller: instagramController,
                      label: 'Instagram',
                      headlineAdd: 'Добавить instagram',
                      textInputType: TextInputType.text,
                      onAddFunction: (){
                        setState(() {
                          showInstagram = true;
                        });
                      },
                      onClearFunction: (){
                        setState(() {
                          showInstagram = false;
                          instagramController.text = '';
                        });
                      },
                      addOrClear: showInstagram,
                      icon: FontAwesomeIcons.instagram,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20,),

                    InputFieldWithAdd(
                      controller: instagramController,
                      label: 'Whatsapp',
                      headlineAdd: 'Добавить Whatsapp',
                      textInputType: TextInputType.text,
                      onAddFunction: (){
                        setState(() {
                          showWhatsapp = true;
                        });
                      },
                      onClearFunction: (){
                        setState(() {
                          showWhatsapp = false;
                          instagramController.text = '';
                        });
                      },
                      addOrClear: showWhatsapp,
                      icon: FontAwesomeIcons.whatsapp,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20,),

                    InputFieldWithAdd(
                      controller: telegramController,
                      label: 'Telegram',
                      headlineAdd: 'Добавить Telegram',
                      textInputType: TextInputType.text,
                      onAddFunction: (){
                        setState(() {
                          showTelegram = true;
                        });
                      },
                      onClearFunction: (){
                        setState(() {
                          showTelegram = false;
                          telegramController.text = '';
                        });
                      },
                      addOrClear: showTelegram,
                      icon: FontAwesomeIcons.telegram,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 40,),

                    CustomButton(
                        buttonText: widget.client != null ? 'Сохранить' : 'Добавить клиента',
                        state: ButtonState.success,
                        onTapMethod: (){
                          _saveClient(
                              id: id,
                              name: nameController.text,
                              lastName: lastNameController.text,
                              phone: phoneController.text,
                              instagram: instagramController.text,
                              telegram: telegramController.text,
                              whatsapp: whatsappController.text,
                              birthday: birthday,
                              createDate: createDate,
                              gender: gender
                          );

                        }
                    ),

                    const SizedBox(height: 20,),

                    CustomButton(
                        buttonText: 'Отменить',
                        state: ButtonState.secondary,
                        onTapMethod: (){
                          goToClientsListScreen();
                        }
                    ),

                  ],
                )
            ),
          ],
        )
    );
  }

  // ---- Функция отображения диалога фильтра ----

  Future<DateTime?> _showDateDialog(BuildContext context, DateTime date) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ChooseDatePopup(date: date); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

  Future<void> _saveClient ({
    required String id,
    required String name,
    required String lastName,
    required String phone,
    required String instagram,
    required String telegram,
    required String whatsapp,
    required DateTime birthday,
    required DateTime createDate,
    required Gender gender,

  }) async {

    setState(() {
      loading = true;
    });

    if (name.isNotEmpty){

      ClientCustom tempClient = ClientCustom(
          id: id,
          name: name,
          phone: phone,
          createDate: createDate,
          birthDay: birthday,
          gender: gender,
          whatsapp: whatsapp,
          lastName: lastName,
          instagram: instagram,
          telegram: telegram
      );

      String result = await tempClient.publishToDb(DbInfoManager.currentUser.uid);

      if (result == 'ok'){

        if (widget.client != null){
          DbInfoManager.clientsList.removeWhere((element) => element.id == widget.client!.id);
        }

        DbInfoManager.clientsList.add(tempClient);

        showSnackBar('Клиент успешно опубликован', Colors.green, 2);

        goToClientsListScreen();

      } else {
        showSnackBar('Произошла ошибка - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        showSnackBar('Имя должно быть заполнено!', AppColors.attentionRed, 2);

      });
    }





  }

  void goToClientsListScreen(){
    Navigator.pushReplacementNamed(context, '/tasks');
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}