import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';

class CustomButton extends StatelessWidget {
  final ButtonState state;
  final String buttonText;
  final VoidCallback onTapMethod;

  const CustomButton({super.key, this.state = ButtonState.primary, required this.buttonText, required this.onTapMethod}); // Указываем значения по умолчанию

  // --- ВИДЖЕТ КАСТОМНОЙ КНОПКИ ------

  @override
  Widget build(BuildContext context) {

    // Выбор цвета кнопки в зависимости от переданного состояния кнопки

    Color getButtonColor() {
      switch (state) {
        case ButtonState.primary:
          return AppColors.yellowLight;
        case ButtonState.success:
          return Colors.green;
        case ButtonState.error:
          return AppColors.attentionRed;
        case ButtonState.secondary:
          return AppColors.white;
      }
    }

    // Выбор цвета границы в зависимости от переданного состояния кнопки

    Color getBorderColor() {
      switch (state) {
        case ButtonState.primary:
          return AppColors.yellowLight;
        case ButtonState.success:
          return Colors.green;
        case ButtonState.error:
          return AppColors.attentionRed;
        case ButtonState.secondary:
          return AppColors.white;
      }
    }

    // Выбор цвета текста в зависимости от передаваемого состояния

    Color getTextAndIconColor() {
      switch (state) {
        case ButtonState.primary:
          return AppColors.black;
        case ButtonState.success:
          return Colors.black;
        case ButtonState.error:
          return AppColors.black;
        case ButtonState.secondary:
          return AppColors.black;
      }
    }

    var iconColor = getTextAndIconColor();

    // --- САМА КНОПКА ----

    return GestureDetector(
        onTap: onTapMethod,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            color: getButtonColor(),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: getBorderColor()),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              TextCustom(text: buttonText, color: getTextAndIconColor())
            ],
          ),
        )
    );
  }
}