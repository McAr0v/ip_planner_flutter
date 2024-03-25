import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import '../app_colors.dart';

class ButtonsForPopup extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ButtonsForPopup({super.key, required this.cancelText, required this.confirmText, required this.onCancel, required this.onConfirm}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        GestureDetector(
            onTap: onCancel,
            child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,)
        ),

        const SizedBox(width: 30.0),

        GestureDetector(
          onTap: onConfirm,
          child: const TextCustom(text: 'Применить', color: Colors.green,),
        ),
      ],
    );
  }
}