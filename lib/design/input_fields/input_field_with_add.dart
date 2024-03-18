import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../app_colors.dart';
import '../text_widgets/text_custom.dart';

class InputFieldWithAdd extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? icon;
  final int? maxLines;
  final String label;
  final String headlineAdd;
  final VoidCallback onAddFunction;
  final VoidCallback onClearFunction;
  final bool addOrClear;

  const InputFieldWithAdd({
    super.key,
    required this.controller,
    required this.label,
    required this.headlineAdd,
    required this.textInputType,
    required this.onAddFunction,
    required this.onClearFunction,
    required this.addOrClear,
    this.icon,
    this.maxLines
  }); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!addOrClear)  Row(
            children: [
              Expanded(
                child: TextCustom(
                  text: headlineAdd,
                  textState: TextState.bodyMedium,
                ),
              ),

              const SizedBox(width: 20,),

              IconButton(

                  onPressed: onAddFunction,
                  icon: const Icon(FontAwesomeIcons.plus, size: 18, color: AppColors.white,)
              ),
            ],
          ),
          if (addOrClear) Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontFamily: 'sf_custom',
                    fontWeight: FontWeight.normal,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    labelText: label,
                    prefixIcon: icon != null ? Icon(icon) : null,

                  ),
                  keyboardType: textInputType,
                  maxLines: maxLines,
                ),
              ),
              const SizedBox(width: 20,),
              IconButton(
                  onPressed: onClearFunction,
                  icon: const Icon(FontAwesomeIcons.x, size: 18, color: AppColors.attentionRed,)
              ),
            ],
          ),
        ],
      ),
    );
  }
}