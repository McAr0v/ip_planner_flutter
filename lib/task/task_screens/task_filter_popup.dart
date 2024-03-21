import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/clients/gender_class.dart';
import 'package:ip_planner_flutter/clients/gender_enum.dart';
import 'package:ip_planner_flutter/design/check_boxes/check_box_widget.dart';
import 'package:ip_planner_flutter/task/task_sort.dart';
import 'package:ip_planner_flutter/task/task_sort_enum.dart';
import 'package:ip_planner_flutter/task/task_status.dart';
import 'package:ip_planner_flutter/task/task_status_enum.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';

class TaskFilterWidget extends StatefulWidget {

  final bool boolPendingForFilter;
  final bool boolCancelledForFilter;
  final bool boolInProgressForFilter;
  final bool boolCompletedForFilter;
  final TaskSortEnum taskSortEnumForFilter;

  const TaskFilterWidget({
    super.key,
    required this.boolPendingForFilter,
    required this.boolCancelledForFilter,
    required this.boolInProgressForFilter,
    required this.boolCompletedForFilter,
    required this.taskSortEnumForFilter,
  });

  @override
  TaskFilterWidgetState createState() => TaskFilterWidgetState();

}

class TaskFilterWidgetState extends State<TaskFilterWidget> {

  late bool boolPending;
  late bool boolCancelled;
  late bool boolInProgress;
  late bool boolCompleted;

  late TaskSortEnum _selectedSortingOption = TaskSortEnum.notChosen;

  @override
  void initState() {
    super.initState();

    boolPending = widget.boolPendingForFilter;
    boolCancelled = widget.boolCancelledForFilter;
    boolInProgress = widget.boolInProgressForFilter;
    boolCompleted = widget.boolCompletedForFilter;

    _selectedSortingOption = widget.taskSortEnumForFilter;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.6),
      body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20.0),
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
                                  padding: EdgeInsets.all(0.0),
                                  child: Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      TextCustom(text: 'Фильтр', textState: TextState.headlineSmall,),

                                      SizedBox(height: 10,),

                                      TextCustom(text: 'Вы можете упорядочить свои задачи', textState: TextState.labelMedium,),

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

                      const SizedBox(height: 30.0),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const TextCustom(text: 'Показать задачи со статусом:', textState: TextState.bodyBig, weight: FontWeight.bold, maxLines: 5,),

                          const SizedBox(height: 10,),

                          CheckBoxWidget(
                            text: TaskStatus(taskStatusEnum: TaskStatusEnum.cancelled).getTaskStatusString(needTranslate: true),
                            checkBoxValue: boolCancelled,
                            onChanged: (value) {
                              setState(() {
                                boolCancelled = !boolCancelled;
                              });
                            },
                          ),

                          CheckBoxWidget(
                              text: TaskStatus().getTaskStatusString(needTranslate: true),
                              checkBoxValue: boolPending,
                              onChanged: (value) {
                                setState(() {
                                  boolPending = !boolPending;
                                });
                              },
                          ),

                          CheckBoxWidget(
                            text: TaskStatus(taskStatusEnum: TaskStatusEnum.inProgress).getTaskStatusString(needTranslate: true),
                            checkBoxValue: boolInProgress,
                            onChanged: (value) {
                              setState(() {
                                boolInProgress = !boolInProgress;
                              });
                            },
                          ),

                        ],
                      ),

                      CheckBoxWidget(
                        text: TaskStatus(taskStatusEnum: TaskStatusEnum.completed).getTaskStatusString(needTranslate: true),
                        checkBoxValue: boolCompleted,
                        onChanged: (value) {
                          setState(() {
                            boolCompleted = !boolCompleted;
                          });
                        },
                      ),

                      const SizedBox(height: 30,),

                      const TextCustom(text: 'Сортировать список по:', textState: TextState.bodyBig, weight: FontWeight.bold, maxLines: 5,),

                      const SizedBox(height: 5,),

                      DropdownButton(
                        style: Theme.of(context).textTheme.bodySmall,
                        isExpanded: true,
                        value: _selectedSortingOption,
                        onChanged: (TaskSortEnum? newValue) {
                          setState(() {
                            _selectedSortingOption = newValue!;
                          });
                        },
                        items: TaskSort().getTaskSortingOptionsList(),
                      ),

                      const SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          GestureDetector(
                              child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                              onTap: (){
                                setState(() {
                                  // --- При отмене просто уходим, без аргументов
                                  Navigator.of(context).pop();
                                });
                              }
                          ),

                          const SizedBox(width: 30.0),

                          GestureDetector(
                            child: const TextCustom(text: 'Применить', color: Colors.green,),
                            onTap: (){

                              List<dynamic> returnedList = [
                              boolPending,
                              boolCancelled,
                              boolInProgress,
                              boolCompleted,
                              _selectedSortingOption,
                              ];

                              Navigator.of(context).pop(returnedList);
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }

}