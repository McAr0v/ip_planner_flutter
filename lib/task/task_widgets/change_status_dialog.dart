import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/task/task_status.dart';
import '../../dates/date_mixin.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../task_status_enum.dart';

class StatusPickerWidget extends StatefulWidget {

  TaskStatus status;

  StatusPickerWidget({super.key, required this.status});

  @override
  StatusPickerWidgetState createState() => StatusPickerWidgetState();

}

class StatusPickerWidgetState extends State<StatusPickerWidget> {

  List<TaskStatusEnum> list = [
    TaskStatusEnum.pending,
    TaskStatusEnum.cancelled,
    TaskStatusEnum.completed,
    TaskStatusEnum.inProgress
  ];

  late TaskStatusEnum chosenStatus;
  int chosenIndex = 0;

  @override
  void initState() {
    super.initState();
    chosenStatus = widget.status.taskStatusEnum;
    chosenIndex = getIndex(chosenStatus);


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
                                  padding: EdgeInsets.all(8.0),
                                  child: Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      TextCustom(text: 'Статус задачи', textState: TextState.headlineSmall,),

                                      SizedBox(height: 10,),

                                      TextCustom(text: 'Выбери статус задачи', textState: TextState.labelMedium,),

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

                      const SizedBox(height: 8.0),

                      Container(
                        height: 300,
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: list.length,
                            itemBuilder: (context, index) {

                              TaskStatus status = TaskStatus(taskStatusEnum: list[index]);

                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    chosenStatus = list[index];
                                    chosenIndex = getIndex(chosenStatus);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: chosenIndex == index ? AppColors.yellowLight : AppColors.black,
                                    borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(text: status.getTaskStatusString(needTranslate: true), color: chosenIndex == index ? AppColors.black : AppColors.white,),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      ),

                      // ---- Кнопки ПРИМЕНИТЬ / Отменить ---

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
                              TaskStatus tempStatus = TaskStatus(taskStatusEnum: chosenStatus);
                              Navigator.of(context).pop(tempStatus);
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

  int getIndex (TaskStatusEnum status) {
    for (int i = 0; i<list.length; i++){
      if (list[i] == status) return i;
    }

    return -1;

  }

}