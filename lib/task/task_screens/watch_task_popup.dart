import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/social_widgets/social_widget.dart';
import 'package:ip_planner_flutter/design/text_widgets/scrollable_text.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import 'package:ip_planner_flutter/task/task_widgets/change_status_dialog.dart';
import '../../database/database_info_manager.dart';
import '../../design/app_colors.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../task_status.dart';
import 'create_task_popup.dart';

class WatchTaskPopup extends StatefulWidget {

  final TaskCustom task;

  const WatchTaskPopup({super.key, required this.task, });

  @override
  WatchTaskPopupState createState() => WatchTaskPopupState();
}

class WatchTaskPopupState extends State<WatchTaskPopup> {

  TaskCustom task = TaskCustom.empty();
  ClientCustom client = ClientCustom.empty();
  TaskStatus chosenStatus = TaskStatus();
  bool loading = true;
  bool saving = false;
  bool needRefresh = true;
  bool statusChangeInView = false;

  @override
  void initState() {
    super.initState();

    _initializeData();

  }

  Future<void> _initializeData() async {
    setState(() {
      loading = true;
    });

    task = widget.task;

    if (task.clientId.isNotEmpty){
      client = client.getClientFromList(widget.task.clientId);
    }

    chosenStatus = task.status;

    setState(() {
      loading = false;
    });

  }

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
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: chosenStatus.getTaskStatusColor(),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15),), // настройте радиус скругления углов для контейнера
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      _showStatusDialog(context: context, status: chosenStatus);
                                    },
                                    child: Column (
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        TextCustom(text: task.label, textState: TextState.headlineSmall),
                                        const SizedBox(height: 5,),
                                        TextCustom(text: chosenStatus.getTaskStatusString(needTranslate: true), textState: TextState.bodySmall, underLine: true,),
                                      ],
                                    ),
                                  )
                              ),

                              IconButton(
                                icon: const Icon(FontAwesomeIcons.pencil, size: 18, ),
                                onPressed: () {
                                  _showCreateTaskDialog(context: context, inputTask: task);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: (){
                                  returnWithResult(needRefresh);
                                },
                              ),
                            ],
                          ),
                        ),

                        SingleChildScrollView (
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              TextCustom(
                                  text: task.label,
                                  textState: TextState.bodyBig,
                                weight: FontWeight.bold,
                                maxLines: 100,
                              ),

                              const SizedBox(height: 20,),

                              if (task.comment.isNotEmpty ) ScrollableText(text: task.comment),

                              if (task.comment.isNotEmpty ) const SizedBox(height: 20,),

                              if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) const TextCustom(text: 'Сроки:', textState: TextState.bodyBig, weight: FontWeight.bold,),

                              if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) const SizedBox(height: 10,),
                              if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (task.startDate != DateTime(2100)) Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                          text: '${DateMixin.getHumanDateFromDateTime(task.startDate)}, в ${DateMixin.getHumanTimeFromDateTime(task.startDate)}',
                                          textState: TextState.bodySmall
                                      ),
                                      const TextCustom(
                                          text: 'Начать выполнение',
                                          textState: TextState.labelMedium,
                                          color: AppColors.greyLight,
                                      ),
                                    ],
                                  ),

                                  if (task.endDate != DateTime(2100)) Column(
                                    crossAxisAlignment: task.startDate != DateTime(2100) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                          text: '${DateMixin.getHumanDateFromDateTime(task.endDate)}, в ${DateMixin.getHumanTimeFromDateTime(task.endDate)}',
                                          textState: TextState.bodySmall
                                      ),
                                      const TextCustom(
                                        text: 'Завершить выполнение',
                                        textState: TextState.labelMedium,
                                        color: AppColors.greyLight,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              if (client.id.isNotEmpty) const SizedBox(height: 20,),

                              if (client.id.isNotEmpty)  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  TextCustom(
                                    text: client.name,
                                    textState: TextState.bodyBig,
                                    weight: FontWeight.bold,
                                  ),
                                  if (
                                  client.whatsapp.isNotEmpty ||
                                      client.telegram.isNotEmpty ||
                                      client.instagram.isNotEmpty ||
                                      client.phone.isNotEmpty
                                  ) const TextCustom(
                                    text: 'Контакты клиента',
                                    textState: TextState.labelMedium,
                                    color: AppColors.greyLight,
                                  ),

                                  if (
                                  client.whatsapp.isNotEmpty ||
                                      client.telegram.isNotEmpty ||
                                      client.instagram.isNotEmpty ||
                                      client.phone.isNotEmpty
                                  ) const SizedBox(height: 10,),

                                  if (
                                  client.whatsapp.isNotEmpty ||
                                      client.telegram.isNotEmpty ||
                                      client.instagram.isNotEmpty ||
                                      client.phone.isNotEmpty
                                  ) SocialWidget(
                                    whatsapp: client.whatsapp,
                                    telegram: client.telegram,
                                    instagram: client.instagram,
                                    phone: client.phone,
                                  ),
                                ],
                              ),

                              if (task.instagram.isNotEmpty || task.phone.isNotEmpty || task.place.isNotEmpty) Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20,),
                                  const TextCustom(text: 'Контактная информация:', textState: TextState.bodyBig, weight: FontWeight.bold,),
                                  const TextCustom(
                                    text: 'Дополнительно указанные контакты',
                                    textState: TextState.labelMedium,
                                    color: AppColors.greyLight,
                                  ),
                                  const SizedBox(height: 10,),
                                  if (task.place.isNotEmpty) TextCustom(text: task.place, textState: TextState.bodyMedium),
                                  if (task.instagram.isNotEmpty || task.phone.isNotEmpty) const SizedBox(height: 10,),
                                  if (task.instagram.isNotEmpty || task.phone.isNotEmpty) SocialWidget(instagram: task.instagram, phone: task.phone,),
                                ],
                              )

                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: AppColors.blackLight,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15),), // настройте радиус скругления углов для контейнера
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              if (!statusChangeInView) GestureDetector(
                                child: const TextCustom(text: 'Закрыть', color: AppColors.attentionRed,),
                                onTap: (){
                                  returnWithResult(needRefresh);
                                },
                              ),

                              if (statusChangeInView) GestureDetector(
                                child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                                onTap: (){
                                  returnWithResult(needRefresh);
                                  },
                              ),

                              if (statusChangeInView) const SizedBox(width: 30.0),

                              if (statusChangeInView) GestureDetector(
                                child: const TextCustom(text: 'Сохранить', color: Colors.green,),
                                onTap: () async {

                                  _saveTask(status: chosenStatus, task: task);

                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        )
    );
  }



  Future<void> _showCreateTaskDialog({required BuildContext context, required TaskCustom inputTask}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TaskCreatePopup(task: inputTask, isEdit: true,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {

      setState(() {
        loading = true;
        needRefresh = true;
        task = results;

        if (task.status != chosenStatus){
          chosenStatus = task.status;
        }

        if (task.clientId.isNotEmpty) {
          client = client.getClientFromList(task.clientId);
        } else {
          client = ClientCustom.empty();
        }
        loading = false;
      });
    }
  }

  void returnWithResult(bool refresh){
    if (refresh) {
      Navigator.of(context).pop(refresh);
    } else {
      Navigator.of(context).pop();
    }
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _showStatusDialog({required BuildContext context, required TaskStatus status}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatusPickerWidget(status: status,);
      },
    );

    if (results != null) {

      setState(() {
        loading = true;
        needRefresh = true;
        statusChangeInView = true;
        task.status = results;
        chosenStatus = results;
        loading = false;
      });

    }
  }

  Future<void> _saveTask ({
    required TaskStatus status,
    required TaskCustom task,
  }) async {

    setState(() {
      loading = true;
    });

    TaskCustom tempTask = task;

    tempTask.status = chosenStatus;

    String result = await tempTask.publishToDb(DbInfoManager.currentUser.uid);

    if (result == 'ok'){

      DbInfoManager.replaceChangedTaskItem(tempTask);

      showSnackBar('Задача успешно сохранена', Colors.green, 2);

      returnWithResult(true);

    } else {
      showSnackBar('Произошла ошибка - $result', AppColors.attentionRed, 2);
    }

    setState(() {
      loading = false;
    });

  }

}