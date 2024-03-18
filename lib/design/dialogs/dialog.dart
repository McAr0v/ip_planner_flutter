import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import '../app_colors.dart';
import '../text_widgets/text_state.dart';

Future<bool?> exitDialog(BuildContext context, String message, String confirmText, String cancelText, String headline) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.black,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextCustom(text: headline, textState: TextState.headlineSmall,),

            const SizedBox(height: 20,),

            TextCustom(text: message, maxLines: 1000,),

          ],
        ),

        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
              padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
                    (Set<MaterialState> states) {
                  return const EdgeInsets.fromLTRB(20, 0, 0, 20);
                },
              ),
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                    (Set<MaterialState> states) {
                  return const TextStyle(
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                      height: 1.3
                  );
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.attentionRed;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (Set<MaterialState> states) {
                  return const BorderSide(
                    color: Colors.transparent, // Цвет границы
                    width: 0.0, // Толщина границы
                  );
                },
              ),
              minimumSize: MaterialStateProperty.resolveWith<Size?>(
                    (Set<MaterialState> states) {
                  return Size(0, 0); // Задайте минимальную ширину и высоту
                },
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // Закрыть диалог и вернуть `false`
            },
            child: Text(
              cancelText,
              style: const TextStyle(
                color: Colors.red, // Устанавливаем цвет текста для кнопки "Нет"
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
              padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
                    (Set<MaterialState> states) {
                  return const EdgeInsets.fromLTRB(20, 0, 0, 20);
                },
              ),
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                    (Set<MaterialState> states) {
                  return const TextStyle(
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                      height: 1.3
                  );
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.attentionRed;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (Set<MaterialState> states) {
                  return const BorderSide(
                    color: Colors.transparent, // Цвет границы
                    width: 0.0, // Толщина границы
                  );
                },
              ),
              minimumSize: MaterialStateProperty.resolveWith<Size?>(
                    (Set<MaterialState> states) {
                  return Size(0, 0); // Задайте минимальную ширину и высоту
                },
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(true); // Закрыть диалог и вернуть `true`
            },
            child: Text(
              confirmText,
              style: const TextStyle(
                color: Colors.green, // Устанавливаем цвет текста для кнопки "Да"
              ),
            ),
          ),
        ],
      );
    },
  );
}