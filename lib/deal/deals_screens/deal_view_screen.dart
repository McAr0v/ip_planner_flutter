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
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/expenses/expense_class.dart';
import 'package:ip_planner_flutter/note/notes_widgets/note_widget.dart';

import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../../note/note_class.dart';
import '../../pay/pay_class.dart';
import '../../pay/pay_widgets/pay_credit_widget.dart';

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

    paymentsList = PaymentsManager.getPaymentsListForDeal(widget.deal.id);
    paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackLight,
        title: TextCustom(text: widget.deal.headline, textState: TextState.bodyBig, color: AppColors.white, weight: FontWeight.bold,),
        leading: IconButton(
            onPressed: (){},
            icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              size: 18,
            )
        ),
        actions: [
          IconButton(
              onPressed: (){},
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
                TextCustom(text: widget.deal.headline, textState: TextState.headlineMedium, maxLines: 100,),
                const SizedBox(height: 10,),
                TextCustom(text: '${DateMixin.getHumanDateFromDateTime(widget.deal.date)} в ${DateMixin.getHumanTimeFromDateTime(widget.deal.date)}', textState: TextState.labelMedium),

                if (widget.deal.desc.isNotEmpty) const SizedBox(height: 20,),
                if (widget.deal.desc.isNotEmpty) TextCustom(text: widget.deal.desc, maxLines: 100,),

                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.blackLight,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(text: '${widget.deal.price.toString()} тенге', textState: TextState.bodyBig),
                                  //SizedBox(height: 5,),
                                  PayCreditWidget(deal: widget.deal),
                                  //TextCustom(text: 'Список всех оплат клиента', textState: TextState.labelMedium),
                                ],
                              )
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                  Icons.add
                              )
                          ),
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  showPays = !showPays;
                                });
                              },
                              icon: Icon(
                                showPays ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronRight,
                                size: 18,
                              )
                          )
                        ],
                      ),

                      if (showPays) const SizedBox(height: 20,),

                      if (showPays) Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          if (paymentsList.isEmpty) TextCustom(text: 'Оплат не поступало'),
                          if (paymentsList.isNotEmpty) for (Pay pay in paymentsList) Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              TextCustom(text: '+ ${pay.sum.toString()} тенге', color: Colors.green, textState:  TextState.bodyMedium,),
                              TextCustom(text: DateMixin.getHumanDateFromDateTime(pay.payDate), textState: TextState.labelMedium,),
                              const SizedBox(height: 10,),
                            ],
                          )
                        ],
                      )

                    ],
                  ),
                ),

                //const SizedBox(height: 20,),
                //TextCustom(text: '${widget.deal.price.toString()} тенге', textState: TextState.bodyBig, weight: FontWeight.bold,),
                //PayCreditWidget(deal: widget.deal),

                if (client.id.isNotEmpty) const SizedBox(height: 20,),
                if (client.id.isNotEmpty) ClientWidget(client: client, onDelete: (){}, onEdit: (){}),



                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.blackLight,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(text: 'Расходы', textState: TextState.headlineSmall),
                                  SizedBox(height: 5,),
                                  TextCustom(text: 'Список всех расходов на осуществление сделки', textState: TextState.labelMedium),
                                ],
                              )
                          ),
                          IconButton(
                              onPressed: (){},
                              icon: const Icon(
                                  Icons.add
                              )
                          ),
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  showExpenses = !showExpenses;
                                });
                              },
                              icon: Icon(
                                showExpenses ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronRight,
                                size: 18,
                              )
                          )
                        ],
                      ),

                      if (showExpenses) const SizedBox(height: 20,),

                      if (showExpenses) Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          if (expensesList.isEmpty) TextCustom(text: 'Оплат не поступало'),
                          if (expensesList.isNotEmpty) for (Expense expense in expensesList) Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              TextCustom(text: '- ${expense.sum.toString()} тенге', color: AppColors.attentionRed, textState:  TextState.bodyBig,),
                              TextCustom(text: '${DateMixin.getHumanDateFromDateTime(expense.expenseDate)}, ${expense.expenseType.getExpenseTypeString(needTranslate: true)}', textState: TextState.labelMedium,),
                              const SizedBox(height: 10,),
                            ],
                          )
                        ],
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.blackLight,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
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
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}