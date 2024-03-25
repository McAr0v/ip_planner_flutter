import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/pay/pay_widgets/pay_type_widget.dart';
import '../../design/app_colors.dart';
import '../pay_class.dart';

class PayWidget extends StatelessWidget {
  final Pay pay; // Передаваемая переменная
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PayWidget({super.key, required this.pay, required this.onTap, required this.onDelete}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  PayTypeWidget(payType: pay.payType),

                  const SizedBox(height: 10,),

                  TextCustom(text: '+ ${pay.sum.toString()} тенге', textState: TextState.bodyBig, weight: FontWeight.bold, color: Colors.green,),

                  const SizedBox(height: 10,),
                  TextCustom(text: 'Дата оплаты: ${DateMixin.getHumanDateFromDateTime(pay.payDate)}', textState: TextState.labelMedium,),
                ],
              )),
          IconButton(onPressed: onTap, icon: const Icon(Icons.edit, size: 20,)),
          IconButton(onPressed: onDelete, icon: const Icon(FontAwesomeIcons.x, size: 15,)),
        ],
      ),
    );
  }
}