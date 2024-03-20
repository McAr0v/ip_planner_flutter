import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/clients/clients_screens/client_search_popup.dart';
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
  late TextEditingController clientController;

  late DateTime startDate;
  late DateTime endDate;
  late DateTime createDate;

  late TaskStatus status;

  late String id;
  late String clientId;

  late ClientCustom client;

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

    client = ClientCustom.empty();

    labelController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();
    commentController = TextEditingController();
    placeController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    clientController = TextEditingController();

    startDate = DateTime(2100);
    endDate = DateTime(2100);
    createDate = DateTime.now();

    status = TaskStatus();

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

      if (widget.task!.clientId.isNotEmpty){
        client = client.getClientFromList(widget.task!.clientId);
        clientController.text = client.name;
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
                  Expanded(
                    child: Container(
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
                    
                          Expanded(
                            child: SingleChildScrollView (
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  const SizedBox(height: 10.0),
                                                
                                  InputField(
                                    controller: labelController,
                                    label: widget.task == null || edit  ? 'Заголовок (Обязательно)' : 'Заголовок',
                                    textInputType: TextInputType.text,
                                    active: widget.task == null || edit ? true : false,
                                    icon: Icons.person,
                                    needButton: (widget.task == null || edit) && labelController.text != '' && true,
                                    activateButton: labelController.text != '',
                                    onChanged: (value) {
                                      setState(() {
                                        labelController.text = value;
                                      });
                                    },
                                    onButtonClick: (){
                                      setState(() {
                                        labelController.text = '';
                                      });
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                  ),
                                                
                                  const SizedBox(height: 20,),
                                                
                                  InputField(
                                    controller: commentController,
                                    label: 'Комментарий',
                                    textInputType: TextInputType.multiline,
                                    active: widget.task == null || edit ? true : false,
                                    icon: Icons.person,
                                    maxLines: null,
                                    needButton: (widget.task == null || edit) && commentController.text != '' && true,
                                    activateButton: commentController.text != '',
                                    onChanged: (value) {
                                      setState(() {
                                        commentController.text = value;
                                      });
                                    },
                                    onButtonClick: (){
                                      setState(() {
                                        commentController.text = '';
                                      });
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                  ),
                                                
                                  const SizedBox(height: 20,),

                                  InputField(
                                    controller: clientController,
                                    label: 'Клиент',
                                    textInputType: TextInputType.text,
                                    active: widget.task == null || edit ? true : false,
                                    needButton: (widget.task == null || edit) && client.id.isNotEmpty ? true : false,
                                    onFieldClick: () async {
                                      ClientCustom? tempClient = await _showChooseClientDialog(context: context);

                                      if (tempClient != null) {
                                        setState(() {
                                          client = tempClient;
                                          clientController.text = client.name;
                                        });
                                      }
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                    icon: FontAwesomeIcons.user,
                                    activateButton: widget.task == null || edit ? true : false,
                                    onButtonClick: (){
                                      setState(() {
                                        client = ClientCustom.empty();
                                        clientController.text = '';
                                      });
                                    },

                                  ),

                                  const SizedBox(height: 20,),

                                  InputField(
                                    controller: placeController,
                                    label: "Место",
                                    textInputType: TextInputType.text,
                                    active: widget.task == null || edit ? true : false,
                                    icon: Icons.place,
                                    needButton: (widget.task == null || edit) && placeController.text != '' && true,
                                    activateButton: placeController.text != '',
                                    onChanged: (value) {
                                      setState(() {
                                        placeController.text = value;
                                      });
                                    },
                                    onButtonClick: (){
                                      setState(() {
                                        placeController.text = '';
                                      });
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                  ),

                                  const SizedBox(height: 20,),

                                  InputField(
                                    controller: startDateController,
                                    label: 'Начать выполнение задачи...',
                                    textInputType: TextInputType.datetime,
                                    active: widget.task == null || edit ? true : false,
                                    needButton: (widget.task == null || edit) && startDate != DateTime(2100) ? true : false,
                                    onFieldClick: () async {
                                      DateTime? result = await _showDateDialog(context, startDate);
                                      if (result != null) {
                                        setState(() {
                                          startDate = result;
                                          startDateController.text = '${DateMixin.getHumanDateFromDateTime(startDate)} в ${DateMixin.getHumanTimeFromDateTime(startDate)}';
                                        });
                                      }
                                    },
                                    onButtonClick: (){
                                      setState(() {
                                        startDate = DateTime(2100);
                                        startDateController.text = '';
                                      });
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                    icon: FontAwesomeIcons.calendarDays,
                                    activateButton: widget.task == null || edit ? true : false,
                                                
                                  ),
                                                
                                  const SizedBox(height: 20,),

                                  InputField(
                                    controller: endDateController,
                                    label: 'Завершить задачу до...',
                                    textInputType: TextInputType.datetime,
                                    active: widget.task == null || edit ? true : false,
                                    needButton: (widget.task == null || edit) && endDate != DateTime(2100) ? true : false,
                                    onFieldClick: () async {
                                      DateTime? result = await _showDateDialog(context, endDate);
                                      if (result != null) {
                                        setState(() {
                                          endDate = result;
                                          endDateController.text = '${DateMixin.getHumanDateFromDateTime(endDate)} в ${DateMixin.getHumanTimeFromDateTime(endDate)}';
                                        });
                                      }
                                    },
                                    onButtonClick: (){
                                      setState(() {
                                        endDate = DateTime(2100);
                                        endDateController.text = '';
                                      });
                                    },
                                    iconForButton: FontAwesomeIcons.x,
                                    icon: FontAwesomeIcons.calendarDays,
                                    activateButton: widget.task == null || edit ? true : false,

                                  ),

                                  const SizedBox(height: 20,),

                                  InputField(
                                    controller: phoneController,
                                    label: "Телефон",
                                    textInputType: TextInputType.phone,
                                    active: widget.task == null || edit ? true : false,
                                    icon: Icons.phone,
                                    needButton: (widget.task == null || edit) && phoneController.text != '' && true,
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
                                    controller: instagramController,
                                    label: "Instagram",
                                    textInputType: TextInputType.phone,
                                    active: widget.task == null || edit ? true : false,
                                    icon: FontAwesomeIcons.instagram,
                                    needButton: (widget.task == null || edit) && instagramController.text != '' && true,
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

                                ],
                              ),
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
                                      status: status,
                                      label: labelController.text,
                                      place: placeController.text,
                                      instagram: instagramController.text,
                                      startDate: startDate,
                                      endDate: endDate,
                                      phone: phoneController.text,
                                      comment: commentController.text,
                                      client: client
                                  );
                                },
                              ),
                            ],
                          ),
                    
                          if (widget.task == null || edit) const SizedBox(height: 10.0),
                    
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        )
    );
  }

  Future<void> _saveTask ({
    required TaskStatus status,
    required String label,
    required String place,
    required String phone,
    required String instagram,
    required String comment,
    required DateTime startDate,
    required DateTime endDate,
    required ClientCustom client
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
          clientId: client.id,
          comment: comment
      );

      String result = await tempTask.publishToDb(DbInfoManager.currentUser.uid);

      if (result == 'ok'){

        if (widget.task != null){
          DbInfoManager.tasksList.removeWhere((element) => element.id == widget.task!.id);
        }

        DbInfoManager.tasksList.add(tempTask);

        showSnackBar('Задача успешно опубликована', Colors.green, 2);

        returnWithResult(tempTask);

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

  void returnWithResult(TaskCustom task){
    Navigator.of(context).pop(task);
  }

  Future<ClientCustom?> _showChooseClientDialog({required BuildContext context}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ClientSearchPopup(); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}