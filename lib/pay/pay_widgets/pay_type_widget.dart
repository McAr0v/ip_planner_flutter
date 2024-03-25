import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';

class PayTypeWidget extends StatelessWidget {
  final PayType payType; // Передаваемая переменная

  const PayTypeWidget({super.key, required this.payType}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: payType.getPayTypeColor(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextCustom(text: payType.getPayTypeString(needTranslate: true), textState: TextState.labelMedium,),
    );
  }
}