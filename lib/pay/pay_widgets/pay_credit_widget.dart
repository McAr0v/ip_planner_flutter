import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/database/entities_managers/payments_manager.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../../design/app_colors.dart';
import '../pay_class.dart';

class PayCreditWidget extends StatefulWidget {
  final DealCustom deal;

  const PayCreditWidget({
    super.key,
    required this.deal
  });

  @override
  PayCreditWidgetState createState() => PayCreditWidgetState();

}

class PayCreditWidgetState extends State<PayCreditWidget> {

  late List<Pay> paymentsList;
  int paymentsSum = 0;
  int credit = 0;

  @override
  void initState() {

    paymentsList = PaymentsManager.getPaymentsListForDeal(widget.deal.id);

    for (Pay pay in paymentsList) {
      paymentsSum += pay.sum;
    }

    credit = widget.deal.price - paymentsSum;

    super.initState();
  }

  Color switchColor(int credit){
    if (credit < 0) {
      return AppColors.telegram;
    } else if (credit == 0) {
      return Colors.green;
    } else {
      return AppColors.attentionRed;
    }
  }

  String switchText(int credit){
    if (credit < 0) {
      return 'Переплата $credit тенге';
    } else if (credit == 0) {
      return 'Оплачено';
    } else {
      return 'Долг клиента - $credit тенге';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextCustom(text: switchText(credit), textState: TextState.labelMedium, color: switchColor(credit),);
  }
}