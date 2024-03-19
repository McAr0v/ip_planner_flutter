import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/dates/choose_date_popup.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/date_widgets/date_time_picker.dart';
import 'package:ip_planner_flutter/design/input_fields/input_field_with_add.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import '../../design/app_colors.dart';
import '../../design/buttons/button_state.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../task_status.dart';

class TaskCreateScreen extends StatefulWidget {
  final TaskCustom? task;
  const TaskCreateScreen({super.key, this.task});

  @override
  TaskCreateScreenState createState() => TaskCreateScreenState();

}

class TaskCreateScreenState extends State<TaskCreateScreen> {


  late bool loading;
  late bool showClient;
  late bool showNumber;
  late bool showInstagram;
  late bool showAddress;

  late String id;
  late String clientId;

  late TextEditingController placeController;
  late TextEditingController commentController;
  late TextEditingController labelController;
  late TextEditingController phoneController;
  late TextEditingController instagramController;

  late DateTime startDate;
  late DateTime endDate;

  late TaskStatus status;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {

    loading = true;

    showClient = false;
    showNumber = false;
    showInstagram = false;
    showAddress = false;


    placeController = TextEditingController();
    commentController = TextEditingController();
    labelController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();

    startDate = DateTime(2100);
    endDate = DateTime(2100);

    status = TaskStatus();

    if (widget.task != null) {

      id = widget.task!.id;
      clientId = widget.task!.clientId;

      placeController.text = widget.task!.place;
      commentController.text = widget.task!.comment;
      labelController.text = widget.task!.label;
      phoneController.text = widget.task!.phone;
      instagramController.text = widget.task!.instagram;

      startDate = widget.task!.startDate;
      endDate = widget.task!.endDate;

      if (widget.task!.place.isNotEmpty) {
        showAddress = true;
      }

      if (widget.task!.phone.isNotEmpty) {
        showNumber = true;
      }

      if (widget.task!.instagram.isNotEmpty) {
        showInstagram = true;
      }

    } else {
      id = MixinDatabase.generateKey()!;
      clientId = '';
    }

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.green,
          title: TextCustom(text: widget.task != null ? widget.task!.label : 'Создание задачи', textState: TextState.bodyBig, color: AppColors.white, weight: FontWeight.bold,),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.chevronLeft, size: 18,),

            // Переход на страницу создания города
            onPressed: () {
              goToTasksListScreen();
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
                    controller: labelController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Название задачи (Обязательно)',
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
                    controller: commentController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Комментарий',
                      prefixIcon: Icon(Icons.comment),

                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),

                  const SizedBox(height: 20,),

                  DateTimePickerWidget(
                    date: startDate,
                    desc: "Начало задачи",
                    addDate: () async {
                      DateTime? result = await _showDateDialog(context, startDate);
                      if (result != null) {
                        setState(() {
                          startDate = result;
                        });
                      }
                    },
                    clearDate: (){
                      setState(() {
                        startDate = DateTime(2100);
                      });
                    },
                  ),

                  const SizedBox(height: 20,),

                  DateTimePickerWidget(
                    date: endDate,
                    desc: "Конец задачи",
                    addDate: () async {
                      DateTime? result = await _showDateDialog(context, endDate);
                      if (result != null) {
                        setState(() {
                          endDate = result;
                        });
                      }
                    },
                    clearDate: (){
                      setState(() {
                        endDate = DateTime(2100);
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
                    controller: placeController,
                    label: 'Адрес',
                    headlineAdd: 'Добавить адрес',
                    textInputType: TextInputType.streetAddress,
                    onAddFunction: (){
                      setState(() {
                        showAddress = true;
                      });
                    },
                    onClearFunction: (){
                      setState(() {
                        showAddress = false;
                        placeController.text = '';
                      });
                    },
                    addOrClear: showAddress,
                    icon: FontAwesomeIcons.locationDot,
                    maxLines: 1,
                  ),

                  const SizedBox(height: 40,),

                  CustomButton(
                      buttonText: widget.task != null ? 'Сохранить' : 'Добавить задачу',
                      state: ButtonState.success,
                      onTapMethod: (){
                        _saveTask(
                          label: labelController.text,
                          place: placeController.text,
                          instagram: instagramController.text,
                          startDate: startDate,
                          endDate: endDate,
                          phone: phoneController.text,
                          comment: commentController.text
                        );

                      }
                  ),

                  const SizedBox(height: 20,),

                  CustomButton(
                      buttonText: 'Отменить',
                      state: ButtonState.secondary,
                      onTapMethod: (){
                        goToTasksListScreen();
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

  Future<void> _saveTask ({
    required String label,
    required String place,
    required String phone,
    required String instagram,
    required String comment,
    required DateTime startDate,
    required DateTime endDate
  }) async {

    setState(() {
      loading = true;
    });

    if (label.isNotEmpty){

      TaskCustom tempTask = TaskCustom(
          id: id,
          startDate: startDate,
          endDate: endDate,
          label: label,
          createDate: DateTime.now(),
          status: status,
          place: place,
          instagram: instagram,
          phone: phone,
          clientId: '',
          comment: comment
      );

      String result = await tempTask.publishToDb(DbInfoManager.currentUser.uid);

      if (result == 'ok'){

        if (widget.task != null){
          DbInfoManager.tasksList.removeWhere((element) => element.id == widget.task!.id);
        }

        DbInfoManager.tasksList.add(tempTask);

        showSnackBar('Задача успешно опубликована', Colors.green, 2);

        goToTasksListScreen();

      } else {
        showSnackBar('Произошла ошибка - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        showSnackBar('Название задачи должно быть заполнено!', AppColors.attentionRed, 2);

      });
    }
  }

  void goToTasksListScreen(){
    Navigator.pushReplacementNamed(context, '/tasks');
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}