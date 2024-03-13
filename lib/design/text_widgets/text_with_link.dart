import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';

class TextWithLink extends StatelessWidget {
  final String text; // передаваемая переменная
  final String linkedText; // передаваемая переменная
  final String uri; // передаваемая переменная

  const TextWithLink({super.key, this.text = '', required this.linkedText, required this.uri}); // Указываем значения по умолчанию


  // --- ВИДЖЕТ ТЕКСТА С ССЫЛКОЙ ------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != '') TextCustom(text: text, textState: TextState.bodyMedium),

        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, uri);
          },
          child: TextCustom(text: linkedText, textState: TextState.bodyMedium, color: AppColors.yellowLight,)
        ),
      ],
    );
  }
}