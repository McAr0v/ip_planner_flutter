import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/input_fields/input_field.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import '../../database/mixin_database.dart';
import '../../dates/choose_date_popup.dart';
import '../../design/app_colors.dart';
import '../../design/date_widgets/date_time_picker.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../task_status.dart';


class TaskCreatePopup extends StatefulWidget {

  final TaskCustom? task;
  final bool? isEdit;

  const TaskCreatePopup({super.key, required this.task, this.isEdit});

  @override
  TaskCreatePopupState createState() => TaskCreatePopupState();
}

// -- Виджет отображения фильтра в мероприятиях ---

class TaskCreatePopupState extends State<TaskCreatePopup> {

  late bool loading;
  late bool saving;
  late bool edit;

  late TextEditingController placeController;
  late TextEditingController commentController;
  late TextEditingController labelController;
  late TextEditingController phoneController;
  late TextEditingController instagramController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  late DateTime startDate;
  late DateTime endDate;
  late DateTime createDate;

  late TaskStatus status;

  late String id;
  late String clientId;

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

    labelController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();
    commentController = TextEditingController();
    placeController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();

    startDate = DateTime(2100);
    endDate = DateTime(2100);
    createDate = DateTime.now();

    startDateController.text = 'Начало задачи';
    endDateController.text = 'Конец задачи';

    if (widget.task != null) {

      createDate = widget.task!.createDate;

      id = widget.task!.id;

      labelController.text = widget.task!.label;
      phoneController.text = widget.task!.phone;
      instagramController.text = widget.task!.instagram;
      commentController.text = widget.task!.comment;
      placeController.text = widget.task!.place;

      if (widget.task!.startDate != DateTime(2100)){
        startDate = widget.task!.startDate;
        startDateController.text = DateMixin.getHumanDateFromDateTime(widget.task!.startDate);
      }

      if (widget.task!.endDate != DateTime(2100)){
        endDate = widget.task!.endDate;
        endDateController.text = DateMixin.getHumanDateFromDateTime(widget.task!.endDate);
      }

      status = widget.task!.status;


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

                                    if (!edit) TextCustom(text: widget.task != null ? widget.task!.label : 'Создание задачи', textState: TextState.headlineSmall,),

                                    if (edit) const TextCustom(text: 'Редактирование', textState: TextState.headlineSmall,),

                                    const SizedBox(height: 10,),

                                    if (widget.task == null) const TextCustom(text: 'Заполните поля задачи', textState: TextState.labelMedium,),
                                    if (widget.task != null && !edit) const TextCustom(text: 'Данные о задаче', textState: TextState.labelMedium,),
                                    if (widget.task != null && edit) const TextCustom(text: 'Отредактируйте задачу', textState: TextState.labelMedium,),

                                  ],
                                )
                            ),

                            // --- Иконка ----

                            if (widget.task != null) IconButton(
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
                                controller: labelController,
                                label: widget.task == null || edit  ? 'Заголовок (Обязательно)' : 'Заголовок',
                                textInputType: TextInputType.text,
                                active: widget.task == null || edit ? true : false,
                                icon: Icons.person,
                              ),

                              const SizedBox(height: 20,),

                              InputField(
                                controller: commentController,
                                label: 'Комментарий',
                                textInputType: TextInputType.multiline,
                                active: widget.task == null || edit ? true : false,
                                icon: Icons.person,
                                maxLines: 5,
                              ),

                              const SizedBox(height: 20,),

                              InputField(
                                controller: phoneController,
                                label: 'Телефон',
                                textInputType: TextInputType.phone,
                                active: widget.task == null || edit ? true : false,
                                icon: Icons.phone,
                              ),

                              const SizedBox(height: 20,),

                              InputField(
                                controller: placeController,
                                label: "Место",
                                textInputType: TextInputType.text,
                                active: widget.task == null || edit ? true : false,
                                icon: Icons.place,
                              ),

                              const SizedBox(height: 20,),

                              /*


  String comment;
  String clientId;
  TaskStatus status;
                         */

                              InputField(
                                controller: instagramController,
                                label: 'Instagram',
                                textInputType: TextInputType.text,
                                active: widget.task == null || edit ? true : false,
                                icon: FontAwesomeIcons.instagram,
                              ),

                              const SizedBox(height: 20,),

                              InputField(
                                controller: startDateController,
                                label: 'Старт выполнения задачи',
                                textInputType: TextInputType.datetime,
                                active: false,
                                needButton: widget.task == null || edit ? true : false,
                                onButtonClick: () async {
                                  DateTime? result = await _showDateDialog(context, startDate);
                                  if (result != null) {
                                    setState(() {
                                      startDate = result;
                                      startDateController.text = '${DateMixin.getHumanDateFromDateTime(startDate)} в ${DateMixin.getHumanTimeFromDateTime(startDate)}';
                                    });
                                  }
                                },
                                iconForButton: FontAwesomeIcons.pencil,
                                icon: FontAwesomeIcons.calendarDays,
                                activateButton: widget.task == null || edit ? true : false,

                              ),

                              const SizedBox(height: 20,),

                              InputField(
                                controller: endDateController,
                                label: 'Выполнить до',
                                textInputType: TextInputType.datetime,
                                active: false,
                                needButton: widget.task == null || edit ? true : false,
                                onButtonClick: () async {
                                  DateTime? result = await _showDateDialog(context, startDate);
                                  if (result != null) {
                                    setState(() {
                                      endDate = result;
                                      endDateController.text = '${DateMixin.getHumanDateFromDateTime(endDate)} в ${DateMixin.getHumanTimeFromDateTime(endDate)}';
                                    });
                                  }
                                },
                                iconForButton: FontAwesomeIcons.pencil,
                                icon: FontAwesomeIcons.calendarTimes,
                                activateButton: widget.task == null || edit ? true : false,

                              ),

                            ],
                          ),
                        ),

                        if (widget.task == null || edit) const SizedBox(height: 30.0),

                        if (widget.task == null || edit) Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            GestureDetector(
                              child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                              onTap: (){Navigator.of(context).pop();},
                            ),

                            const SizedBox(width: 30.0),

                            GestureDetector(
                              child: const TextCustom(text: 'Сохранить', color: Colors.green,),
                              onTap: ()async {
                                await _saveTask(
                                    label: labelController.text,
                                    place: placeController.text,
                                    instagram: instagramController.text,
                                    startDate: startDate,
                                    endDate: endDate,
                                    phone: phoneController.text,
                                    comment: commentController.text
                                );
                              },
                            ),
                          ],
                        ),

                        if (widget.task == null || edit) const SizedBox(height: 10.0),

                      ],
                    ),
                  ),
                ],
              )
          ],
        )
    );
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

        //goToTasksListScreen();

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

  /*void returnWithResult(ClientCustom client){
    Navigator.of(context).pop(client);
  }*/

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /*Future<void> _selectDate(BuildContext context, DateTime initial) async {

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
  }*/

}