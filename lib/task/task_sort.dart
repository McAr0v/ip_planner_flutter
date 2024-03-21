import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/task/task_sort_enum.dart';
import 'package:ip_planner_flutter/task/task_status_enum.dart';

import '../design/app_colors.dart';

class TaskSort {
  TaskSortEnum taskSortEnum;

  TaskSort({this.taskSortEnum = TaskSortEnum.notChosen});

  String getTaskStatusString(){
    switch (taskSortEnum) {
      case TaskSortEnum.notChosen: return "Не выбрано";
      case TaskSortEnum.nameAsc: return "По имени (А-Я)";
      case TaskSortEnum.nameDesc: return "По имени (Я-А)";
      case TaskSortEnum.statusAsc: return "По статусу (А-Я)";
      case TaskSortEnum.statusDesc: return "По статусу (Я-А)";
      case TaskSortEnum.startDateAsc: return "По дате начала (А-Я)";
      case TaskSortEnum.startDateDesc: return "По дате начала (Я-А)";
      case TaskSortEnum.endDateAsc: return "По дате завершения (А-Я)";
      case TaskSortEnum.endDateDesc: return "По дате завершения (Я-А)";
    }
  }

  List<DropdownMenuItem<TaskSortEnum>> getTaskSortingOptionsList(){
    return [
      const DropdownMenuItem(
        value: TaskSortEnum.notChosen,
        child: TextCustom(text: 'Не сортировать'),
      ),
      const DropdownMenuItem(
        value: TaskSortEnum.nameAsc,
        child: TextCustom(text: 'По имени (А-Я)'),
      ),
      const DropdownMenuItem(
        value: TaskSortEnum.nameDesc,
        child: TextCustom(text: 'По имени (Я-А)'),
      ),

      const DropdownMenuItem(
        value: TaskSortEnum.statusAsc,
        child: TextCustom(text: 'По статусу (А-Я)'),
      ),
      const DropdownMenuItem(
        value: TaskSortEnum.statusDesc,
        child: TextCustom(text: 'По статусу (Я-А)'),
      ),

      const DropdownMenuItem(
        value: TaskSortEnum.startDateAsc,
        child: TextCustom(text: 'По дате начала (А-Я)'),
      ),
      const DropdownMenuItem(
        value: TaskSortEnum.startDateDesc,
        child: TextCustom(text: 'По дате начала (Я-А)'),
      ),

      const DropdownMenuItem(
        value: TaskSortEnum.endDateAsc,
        child: TextCustom(text: 'По дате завершения (А-Я)'),
      ),
      const DropdownMenuItem(
        value: TaskSortEnum.endDateDesc,
        child: TextCustom(text: 'По дате завершения (Я-А)'),
      ),
    ];
  }

  List<TaskSortEnum> getTaskSortItemsList(){
    return [
      TaskSortEnum.notChosen,
      TaskSortEnum.nameAsc,
      TaskSortEnum.nameDesc,
      TaskSortEnum.statusAsc,
      TaskSortEnum.statusDesc,
      TaskSortEnum.startDateAsc,
      TaskSortEnum.startDateDesc,
      TaskSortEnum.endDateAsc,
      TaskSortEnum.endDateDesc
    ];
  }

}