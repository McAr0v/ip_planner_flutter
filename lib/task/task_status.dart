import 'dart:ui';

import 'package:ip_planner_flutter/task/task_status_enum.dart';

import '../design/app_colors.dart';

class TaskStatus {
  TaskStatusEnum taskStatusEnum;

  TaskStatus({this.taskStatusEnum = TaskStatusEnum.pending});

  void switchEnumFromString(String taskStatus){
    switch (taskStatus) {
      case "inProgress": taskStatusEnum = TaskStatusEnum.inProgress;
      case "completed": taskStatusEnum = TaskStatusEnum.completed;
      case "cancelled": taskStatusEnum = TaskStatusEnum.cancelled;
      default: taskStatusEnum = TaskStatusEnum.pending;
    }
  }

  String getTaskStatusString({bool needTranslate = false}){
    switch (taskStatusEnum) {
      case TaskStatusEnum.cancelled: return needTranslate == false ? "cancelled" : "Отменено";
      case TaskStatusEnum.pending: return needTranslate == false ? "pending": "В ожидании";
      case TaskStatusEnum.inProgress: return needTranslate == false ? "inProgress": "В процессе";
      case TaskStatusEnum.completed: return needTranslate == false ? "completed": "Завершено";
    }
  }

  Color getTaskStatusColor(){
    switch (taskStatusEnum) {
      case TaskStatusEnum.cancelled: return AppColors.cancelled;
      case TaskStatusEnum.pending: return AppColors.waiting;
      case TaskStatusEnum.inProgress: return AppColors.inProgress;
      case TaskStatusEnum.completed: return AppColors.completed;
    }
  }

}