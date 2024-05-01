import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/database/entities_managers/client_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/pay/pay_widgets/pay_credit_widget.dart';

import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';

class DealWidget extends StatelessWidget {
  final DealCustom deal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const DealWidget({super.key, required this.deal, required this.onDelete, required this.onEdit, required this.onTap}); // Указываем значения по умолчанию


  // Содержание контейнера

  @override
  Widget build(BuildContext context) {

    ClientCustom client = ClientManager.getClientFromList(deal.clientId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: AppColors.blackLight,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(text: '${DateMixin.getHumanDateFromDateTime(deal.date)} в ${DateMixin.getHumanTimeFromDateTime(deal.date)}', textState: TextState.labelMedium),
                        const SizedBox(height: 5,),
                        //TextCustom(text: deal.headline, textState: TextState.bodyBig, weight: FontWeight.bold),
                        TextCustom(text: client.name, textState: TextState.bodyBig, weight: FontWeight.bold),
                      ],
                    )
                ),
                IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                      FontAwesomeIcons.x,
                    size: 15,
                  ),
                ),
              ],
            ),

            if (deal.desc.isNotEmpty) const SizedBox(height: 10,),
            if (deal.desc.isNotEmpty) TextCustom(text: deal.desc, textState: TextState.bodyMedium),
            const SizedBox(height: 10,),
            TextCustom(text: '${deal.price.toString()} тенге', textState: TextState.bodyMedium),
            PayCreditWidget(deal: deal)

          ],
        ),
      ),
    );
  }
}