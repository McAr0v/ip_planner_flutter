import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';
import '../text_widgets/text_with_link.dart';

class CheckBoxWidget extends StatelessWidget {
  final TextState textState; // передаваемая переменная
  final Color color; // передаваемая переменная
  final String text;
  final bool softWrap;
  final FontWeight? weight;
  final int? maxLines;
  final bool underLine;
  final bool withLink;
  final String textForLink;
  final String link;
  final bool checkBoxValue;
  final ValueChanged<bool?> onChanged;

  const CheckBoxWidget({
    super.key,
    required this.text,
    this.textState = TextState.bodyMedium,
    this.color = AppColors.white,
    this.softWrap = true, this.weight,
    this.maxLines,
    this.underLine = false,
    this.withLink = false,
    this.textForLink = '',
    this.link = '',
    required this.checkBoxValue,
    required this.onChanged
  }); // Указываем значения по умолчанию

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checkBoxValue,
          onChanged: onChanged,
        ),
        if (withLink) Expanded(
          //width: MediaQuery.of(context).size.width*0.75,
          child: TextWithLink(
            linkedText: textForLink,
            uri: link,
            text: text,
          ),
        )
        else Expanded(
          child: TextCustom(
              text: text,
              textState: textState,
              color: color,
              softWrap: softWrap,
              maxLines: maxLines,
              underLine: underLine,
          ),
        )
      ],
    );
  }
}