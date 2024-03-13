import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';

class TextCustom extends StatelessWidget {
  final TextState textState; // передаваемая переменная
  final Color color; // передаваемая переменная
  final String text;
  final bool softWrap;

  const TextCustom({super.key, required this.text, this.textState = TextState.bodyMedium, this.color = AppColors.white, this.softWrap = true}); // Указываем значения по умолчанию

  double _switchSize(TextState state){
    switch (state){
      case TextState.headlineBig: return 50;
      case TextState.headlineMedium: return 35;
      case TextState.headlineSmall: return 30;
      case TextState.bodyBig: return 18;
      case TextState.bodyMedium: return 16;
      case TextState.bodySmall: return 14;
      case TextState.labelBig: return 14;
      case TextState.labelMedium: return 12;
      case TextState.labelSmall: return 10;
    }
  }

  FontWeight _switchWeight(TextState state){
    switch (state){
      case TextState.headlineBig:
      case TextState.headlineMedium:
      case TextState.headlineSmall:
        return FontWeight.bold;
      case TextState.bodyBig:
      case TextState.bodyMedium:
      case TextState.bodySmall:
      case TextState.labelBig:
      case TextState.labelMedium:
      case TextState.labelSmall:
        return FontWeight.normal;
    }
  }


  double _switchHeight(TextState state){
    switch (state){
      case TextState.headlineBig:
      case TextState.headlineMedium:
      case TextState.headlineSmall:
        return 1.0;
      case TextState.bodyBig:
      case TextState.bodyMedium:
      case TextState.bodySmall:
      case TextState.labelBig:
      case TextState.labelMedium:
      case TextState.labelSmall:
        return 1.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'sf_custom',
        height: _switchHeight(textState),
        color: color,
        fontSize: _switchSize(textState),
        fontWeight: _switchWeight(textState)
      ),
      softWrap: softWrap,
    );
  }
}