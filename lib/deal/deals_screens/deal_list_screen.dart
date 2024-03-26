import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/deal/deals_screens/deal_create_screen.dart';
import 'package:ip_planner_flutter/deal/deals_screens/deal_view_screen.dart';
import 'package:ip_planner_flutter/deal/deals_widgets/deal_widget.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_sort_enum.dart';
import '../../design/snackBars/custom_snack_bar.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  DealsScreenState createState() => DealsScreenState();

}

class DealsScreenState extends State<DealsScreen> {

  bool loading = true;
  bool deleting = false;

  bool inProgressForFilter = true;
  bool pendingForFilter = true;
  bool completedForFilter = false;
  bool cancelledForFilter = false;

  TaskSortEnum taskSortEnumForFilter = TaskSortEnum.notChosen;

  int filterCount = 0;



  List<DealCustom> list = [];
  //List<DealCustom> notSortedList = [];

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  Future<void> initializeScreen() async {

    setState(() {
      loading = true;
    });

    list = DealManager.dealsList;

    list.sort((a, b) => a.date.compareTo(b.date));

    //filterList();

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
              TextCustom(text: 'Сделки', textState: TextState.headlineSmall, color: AppColors.white,),
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
                    //_showFilterDialog(context: context);

                  },
                ),
              ],
            ),

            IconButton(

              icon: const Icon(Icons.add),

              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/create_deal',
                      (route) => false,
                );
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
                    return DealWidget(
                        deal: list[index],
                      onEdit: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => CreateDealScreen(deal: list[index])),
                              (route) => false,
                        );
                      },
                      onDelete: (){

                      },
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DealViewScreen(deal: list[index]))
                        );

                        if (result != null) {

                        }
                      },
                    );
                  }
              )
              else const Center(
                  child: TextCustom(text: 'Список сделок пуст',),
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

  /*Future<void> _showWatchTaskDialog({required BuildContext context, required TaskCustom task}) async {
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
  }*/

  /*Future<void> _showFilterDialog({required BuildContext context, TaskCustom? task}) async {
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
  }*/

  /*void filterList(){
    List<TaskCustom> tempList = TaskManager.filterList(pendingForFilter, cancelledForFilter, inProgressForFilter, completedForFilter);

    setState(() {
      list = TaskManager.sortList(taskSortEnumForFilter, tempList);
      filterCount = checkFilterAndGetNumber();

    });

  }*/

  /*Future<void> deleteTask(TaskCustom task) async {
    bool? confirmed = await exitDialog(context, "Вы действительно хотите удалить задачу? \n \n Вы не сможете восстановить данные" , 'Да', 'Нет', 'Удаление задачи');

    if (confirmed != null && confirmed){

      setState(() {
        deleting = true;
      });

      String result = await task.deleteFromDb(DbInfoManager.currentUser.uid);

      if (result == 'ok') {
        TaskManager.removeFromTaskList(task.id);
        list.removeWhere((element) => element.id == task.id);

        showSnackBar('Удаление прошло успешно!', Colors.green, 2);

      } else {
        showSnackBar('Произошла ошибка удаления - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        deleting = false;
      });

    }

  }*/

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}