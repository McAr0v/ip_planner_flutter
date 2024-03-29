import 'package:flutter/material.dart';
import '../app_colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final IconData? icon;
  final IconData? iconForButton;
  final int? maxLines;
  final int? maxLength;
  final String label;
  final bool active;
  final bool needButton;
  final bool activateButton;
  final VoidCallback? onFieldClick;
  final VoidCallback? onButtonClick;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.textInputType,
    required this.active,
    this.icon,
    this.iconForButton,
    this.maxLines = 1,
    this.needButton = false,
    this.activateButton = false,
    this.onFieldClick,
    this.onButtonClick,
    this.onChanged,
    this.maxLength
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              prefixIcon: Icon(icon),
            ),
            keyboardType: textInputType,
            enabled: active,
            maxLines: maxLines,
            onChanged: onChanged,
            onTap: onFieldClick,
            readOnly: onFieldClick != null ? true : false,
            maxLength: maxLength,

          ),
        ),

        if (activateButton && needButton) const SizedBox(width: 10.0),

        if (activateButton && needButton) GestureDetector(
          onTap: onButtonClick,
          child: Card(
            color: AppColors.attentionRed,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(iconForButton, size: 15, color: AppColors.black,),
            ),
          ),
        ),


      ],
    );
  }
}