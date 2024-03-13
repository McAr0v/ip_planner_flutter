import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';

// --- ВИДЖЕТ ВСПЛЫВАЮЩЕГО ОПОВЕЩЕНИЯ ----
SnackBar customSnackBar({
  // Сообщение
  required String message,
  // Время показа в секундах
  int showTime = 2,
  // Цвет фона
  required Color backgroundColor,
}) {
  return SnackBar(
      content: TextCustom(text: message, textState: TextState.bodyMedium, color: AppColors.black,),
      duration: Duration(seconds: showTime),
      backgroundColor: backgroundColor
  );
}