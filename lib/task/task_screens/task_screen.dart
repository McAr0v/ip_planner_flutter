import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/gender_class.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_screens/create_task_popup.dart';
import 'package:ip_planner_flutter/task/task_screens/task_filter_popup.dart';
import 'package:ip_planner_flutter/task/task_screens/watch_task_popup.dart';
import 'package:ip_planner_flutter/task/task_sort_enum.dart';
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

  bool inProgressForFilter = true;
  bool pendingForFilter = true;
  bool completedForFilter = false;
  bool cancelledForFilter = false;

  TaskSortEnum taskSortEnumForFilter = TaskSortEnum.notChosen;

  int filterCount = 0;



  List<TaskCustom> list = [];
  List<TaskCustom> notSortedList = [];

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

    filterList();

    filterCount = checkFilterAndGetNumber();

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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (filterCount > 0) TextCustom(text: filterCount.toString(), textState: TextState.bodyMedium, color: AppColors.yellowLight,),
              IconButton(
                icon: Icon(FontAwesomeIcons.filter, size: 18, color: filterCount > 0 ? AppColors.yellowLight : AppColors.white,),
                // Переход на страницу создания города
                onPressed: () {
                  _showFilterDialog(context: context);

                },
              ),
            ],
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
                  onTap: (){
                      _showWatchTaskDialog(context: context, task: list[index]);
                  }
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

  int checkFilterAndGetNumber(){

    int result = 0;

    if (!completedForFilter) result++;
    if (!cancelledForFilter) result++;
    if (!inProgressForFilter) result++;
    if (!pendingForFilter) result++;

    //if (taskSortEnumForFilter == TaskSortEnum.notChosen) result++;

    return result;

  }

  Future<void> _showWatchTaskDialog({required BuildContext context, required TaskCustom task}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WatchTaskPopup(task: task,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      filterList();
    }
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
      filterList();
    }
  }

  Future<void> _showFilterDialog({required BuildContext context, TaskCustom? task}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TaskFilterWidget(
          boolCancelledForFilter: cancelledForFilter,
          boolCompletedForFilter: completedForFilter,
          boolInProgressForFilter: inProgressForFilter,
          boolPendingForFilter: pendingForFilter,
          taskSortEnumForFilter: taskSortEnumForFilter,
        ); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {

      /*
      boolPending,
      boolCancelled,
      boolInProgress,
      boolCompleted,
      _selectedSortingOption,
       */

      setState(() {
        pendingForFilter = results[0];
        cancelledForFilter = results[1];
        inProgressForFilter = results[2];
        completedForFilter = results[3];
        taskSortEnumForFilter = results[4];
      });


      filterList();

    }
  }

  void filterList(){
    List<TaskCustom> tempList = DbInfoManager.filterList(pendingForFilter, cancelledForFilter, inProgressForFilter, completedForFilter);

    setState(() {
      list = DbInfoManager.sortList(taskSortEnumForFilter, tempList);
      filterCount = checkFilterAndGetNumber();

    });

  }

  Future<void> deleteTask(TaskCustom task) async {
    bool? confirmed = await exitDialog(context, "Вы действительно хотите удалить задачу? \n \n Вы не сможете восстановить данные" , 'Да', 'Нет', 'Удаление задачи');

    if (confirmed != null && confirmed){

      setState(() {
        deleting = true;
      });

      String result = await task.deleteFromDb(DbInfoManager.currentUser.uid);

      if (result == 'ok') {
        DbInfoManager.removeFromTaskList(task.id);
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