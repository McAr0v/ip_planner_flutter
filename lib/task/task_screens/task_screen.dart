import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_screens/create_task_popup.dart';
import 'package:ip_planner_flutter/task/task_screens/create_task_screen.dart';
import 'package:ip_planner_flutter/task/task_widgets/task_widget.dart';

import '../../design/dialogs/dialog.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../task_class.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  TaskScreenState createState() => TaskScreenState();

}

class TaskScreenState extends State<TaskScreen> {

  bool loading = true;
  bool deleting = false;

  List<TaskCustom> list = [];
  
  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  Future<void> initializeScreen() async {
    
    setState(() {
      loading = true;
    });
    
    list = DbInfoManager.tasksList;

    setState(() {
      loading = false;
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackLight,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(text: 'Задачи', textState: TextState.headlineSmall, color: AppColors.white,),
          ],
        ),
        actions: [

          IconButton(
            icon: const Icon(FontAwesomeIcons.filter, size: 18,),

            // Переход на страницу создания города
            onPressed: () {

            },
          ),

          IconButton(

            icon: const Icon(Icons.add),

            // Переход на страницу создания города
            onPressed: () {
              _showCreateTaskDialog(context: context);
            },
          ),



        ],
      ),
      body: Stack(
        children: [
          if (loading) const LoadingScreen()
          else if (deleting) const LoadingScreen(loadingText: "Подождите, идет удаление",)
          else if (list.isNotEmpty) ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return TaskWidget(
                    task: list[index],
                  onDelete: (){
                    deleteTask(list[index]);
                  },
                );
              }
          )
          else const Center(
                child: TextCustom(text: 'Список задач пуст',),
              )
        ],
      )
    );
  }

  Future<void> _showCreateTaskDialog({required BuildContext context, TaskCustom? task}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TaskCreatePopup(task: task,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {

      setState(() {
        loading = true;
        //list = DbInfoManager.clientsList;
        //sortList(sort);
        loading = false;
      });
    }
  }

  Future<void> deleteTask(TaskCustom task) async {
    bool? confirmed = await exitDialog(context, "Вы действительно хотите удалить задачу? \n \n Вы не сможете восстановить данные" , 'Да', 'Нет', 'Удаление задачи');

    if (confirmed != null && confirmed){

      setState(() {
        deleting = true;
      });

      String result = await task.deleteFromDb(DbInfoManager.currentUser.uid);

      if (result == 'ok') {
        DbInfoManager.tasksList.removeWhere((element) => element.id == task.id);
        list.removeWhere((element) => element.id == task.id);

        showSnackBar('Удаление прошло успешно!', Colors.green, 2);

      } else {
        showSnackBar('Произошла ошибка удаления - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        deleting = false;
      });

    }

  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}