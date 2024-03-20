import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';

class ScrollableText extends StatelessWidget {
  final TextState textState; // передаваемая переменная
  final Color color; // передаваемая переменная
  final String text;
  final FontWeight? weight;

  const ScrollableText({super.key, required this.text, this.textState = TextState.bodyMedium, this.color = AppColors.white, this.weight}); // Указываем значения по умолчанию

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (text.length > 200 || countLines(text) > 6) SizedBox(
            height: 125,
            child: SingleChildScrollView(
                child:
                TextCustom(
                  text: text,
                  textState: textState,
                  softWrap: true,
                  maxLines: 100,
                )
            )
        )
        else TextCustom(
          text: text,
          textState: textState,
          softWrap: true,
          maxLines: 100,
        ),
      ],
    );
  }

  int countLines(String text) {
    List<String> lines = text.split('\n'); // Разбиваем текст на строки по символу новой строки
    return lines.length; // Возвращаем количество строк
  }

}