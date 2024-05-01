import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/clients/client_widgets/clients_widget.dart';
import 'package:ip_planner_flutter/database/entities_managers/client_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/expenses_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/notes_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/payments_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/design/buttons/buttons_for_popup.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/social_widgets/social_widget.dart';
import 'package:ip_planner_flutter/expenses/expense_class.dart';
import 'package:ip_planner_flutter/note/notes_widgets/note_widget.dart';

import '../../clients/clients_screens/client_create_popup.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../../note/note_class.dart';
import '../../pay/pay_class.dart';
import '../../pay/pay_widgets/pay_credit_widget.dart';
import '../../pay/payments_screens/add_pay_dialog.dart';
import 'deal_create_screen.dart';

class DealViewScreen extends StatefulWidget {
  final DealCustom deal;
  const DealViewScreen({
    super.key,
    required this.deal
  });

  @override
  DealViewScreenState createState() => DealViewScreenState();

}

class DealViewScreenState extends State<DealViewScreen> {

  bool loading = false;
  late ClientCustom client;

  int expenseSum = 0;

  List<Note> notesList = [];
  List<Pay> paymentsList = [];
  List<Expense> expensesList = [];

  bool showPays = false;
  bool showExpenses = false;

  @override
  void initState() {
    super.initState();
    if (widget.deal.clientId.isNotEmpty){
      client = ClientManager.getClientFromList(widget.deal.clientId);
    } else {
      client = ClientCustom.empty();
    }

    notesList = NotesManager.getNotesListForDeal(widget.deal.id);
    notesList.sort((a,b) => a.createDate.compareTo(b.createDate));

    expensesList = ExpensesManager.getExpensesListForDeal(widget.deal.id);
    expensesList.sort((a,b) => a.expenseDate.compareTo(b.expenseDate));

    for (Expense expense in expensesList){
      expenseSum = expenseSum += expense.sum;
    }

    paymentsList = PaymentsManager.getPaymentsListForDeal(widget.deal.id);
    paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackLight,
        title: TextCustom(
          //text: widget.deal.headline,
          text: "Заказ от ${client.name}",
          textState: TextState.bodyBig,
          color: AppColors.white,
          weight: FontWeight.bold,
        ),
        leading: IconButton(
            onPressed: (){},
            icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              size: 18,
            )
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CreateDealScreen(deal: widget.deal)),
                      (route) => false,
                );
              },
              icon: const Icon(
                  Icons.edit
              )
          )
        ],
      ),
      body: Stack(
        children: [
          if (loading) const LoadingScreen()
          else SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: TextCustom(
                        text: client.name,
                        textState: TextState.headlineSmall,
                        maxLines: 3,
                      ),
                    ),

                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: AppColors.blackLight,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextCustom(text: 'Просмотр контакта', textState: TextState.labelMedium, color: AppColors.white,),
                      ),
                      onTap: (){
                        _showCreateClientDialog(context: context, inputClient: client);
                      },
                    )



                  ],
                ),
                if (client.id.isNotEmpty) const SizedBox(height: 20,),

                TextCustom(text: '${DateMixin.getHumanDateFromDateTime(widget.deal.date)} в ${DateMixin.getHumanTimeFromDateTime(widget.deal.date)}', ),

                if (widget.deal.place.isNotEmpty) TextCustom(text: widget.deal.place, maxLines: 100, ),


                if (client.id.isNotEmpty) const SizedBox(height: 20,),

                SocialWidget(
                  whatsapp: client.whatsapp,
                  telegram: client.telegram,
                  instagram: client.instagram,
                  phone: client.phone,
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(text: 'Сумма заказа', textState: TextState.labelMedium, color: AppColors.grey,),
                            SizedBox(height: 5,),
                            TextCustom(
                              text: '${widget.deal.price} тенге',
                              textState: TextState.headlineSmall,
                            ),
                            SizedBox(height: 5,),
                            PayCreditWidget(deal: widget.deal),
                          ],
                        )
                    ),

                    IconButton(
                        onPressed: (){},
                        icon: Column(
                          children: [
                            Icon(FontAwesomeIcons.history, size: 20, ),
                            SizedBox(height: 5,),
                            TextCustom(text: 'История', textState: TextState.labelSmall),
                          ],
                        )
                    ),
                    IconButton(
                        onPressed: () async {
                          Pay? tempPay = await _addPayDialog(context, null);

                          if (tempPay != null) {
                            setState(() {
                              paymentsList.removeWhere((element) => element.id == tempPay.id);
                              paymentsList.add(tempPay);
                              paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));
                            });
                          }
                        },
                        icon: Column(
                          children: [
                            Icon(FontAwesomeIcons.plus, size: 20),
                            SizedBox(height: 5,),
                            TextCustom(text: 'Добавить', textState: TextState.labelSmall),
                          ],
                        )
                    ),

                  ],
                ),

                const SizedBox(height: 20,),

                Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(text: 'Расходы на выполнение заказа', textState: TextState.labelMedium, color: AppColors.grey,),
                            SizedBox(height: 5,),
                            TextCustom(
                              text: expenseSum == 0 ? 'Нет расходов' : '- $expenseSum тенге',
                              textState: TextState.bodyMedium,
                              color: expenseSum == 0 ? AppColors.white : AppColors.attentionRed,
                            ),

                          ],
                        )
                    ),

                    IconButton(
                        onPressed: (){},
                        icon: Column(
                          children: [
                            Icon(FontAwesomeIcons.history, size: 20),
                            SizedBox(height: 5,),
                            TextCustom(text: 'История', textState: TextState.labelSmall, ),
                          ],
                        )
                    ),
                    IconButton(
                        onPressed: (){},
                        icon: Column(
                          children: [
                            Icon(FontAwesomeIcons.plus, size: 20),
                            SizedBox(height: 5,),
                            TextCustom(text: 'Добавить', textState: TextState.labelSmall),
                          ],
                        )
                    ),

                  ],
                ),

                if (widget.deal.desc.isNotEmpty) const SizedBox(height: 20,),
                if (widget.deal.desc.isNotEmpty) TextCustom(text: widget.deal.desc, maxLines: 100,),

                const SizedBox(height: 40,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(text: 'Заметки', textState: TextState.headlineSmall),
                                SizedBox(height: 5,),
                                TextCustom(text: 'Ваши идеи, референсы, фотографии и прочее', textState: TextState.labelMedium),
                              ],
                            )
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(
                                Icons.add
                            )
                        )
                      ],
                    ),

                    if (notesList.isNotEmpty) const SizedBox(height: 20,),
                    if (notesList.isNotEmpty) for (Note note in notesList) NoteWidget(note: note, onTap: (){}, onDelete: (){})
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showCreateClientDialog({required BuildContext context, ClientCustom? inputClient}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClientCreatePopup(client: inputClient,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {

      setState(() {
        loading = true;
        //client = results;
        client = ClientManager.getClientFromList(widget.deal.clientId);
        loading = false;
      });
    }
  }

  Future<Pay?> _addPayDialog(BuildContext context, Pay? pay) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddPayPopup(pay: pay, idEntity: widget.deal.id,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

}