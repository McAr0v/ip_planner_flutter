import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../pay/pay_widgets/pay_type_widget.dart';
import '../expense_class.dart';

class ExpenseWidget extends StatelessWidget {
  final Expense expense; // Передаваемая переменная
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpenseWidget({super.key, required this.expense, required this.onTap, required this.onDelete}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
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

                  PayTypeWidget(payType: expense.payType),

                  const SizedBox(height: 10,),

                  TextCustom(text: '- ${expense.sum.toString()} тенге', textState: TextState.bodyBig, weight: FontWeight.bold, color: AppColors.attentionRed,),
                  TextCustom(text: expense.expenseType.getExpenseTypeString(needTranslate: true), textState: TextState.labelMedium, maxLines: 35,),
                  if (expense.comment.isNotEmpty) const SizedBox(height: 10,),
                  if (expense.comment.isNotEmpty) TextCustom(text: expense.comment, textState: TextState.labelMedium,),
                  const SizedBox(height: 10,),
                  TextCustom(text: 'Дата оплаты: ${DateMixin.getHumanDateFromDateTime(expense.expenseDate)}', textState: TextState.labelMedium,),
                ],
              )),
          IconButton(onPressed: onTap, icon: const Icon(Icons.edit, size: 20,)),
          IconButton(onPressed: onDelete, icon: const Icon(FontAwesomeIcons.x, size: 15,)),
        ],
      ),
    );
  }
}