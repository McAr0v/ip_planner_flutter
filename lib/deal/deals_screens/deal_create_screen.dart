import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/database/entities_managers/client_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/expenses_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/notes_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/payments_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/expenses/expense_class.dart';
import 'package:ip_planner_flutter/expenses/expenses_screens/add_expense_popup.dart';
import 'package:ip_planner_flutter/expenses/expenses_widgets/expense_widget.dart';
import 'package:ip_planner_flutter/pay/pay_widgets/pay_widget.dart';
import 'package:ip_planner_flutter/pay/payments_screens/add_pay_dialog.dart';
import '../../clients/clients_screens/client_search_popup.dart';
import '../../database/database_info_manager.dart';
import '../../dates/choose_date_popup.dart';
import '../../design/app_colors.dart';
import '../../design/dialogs/dialog.dart';
import '../../design/input_fields/input_field.dart';
import '../../design/loading/loading_screen.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../../note/note_class.dart';
import '../../pay/pay_class.dart';

class CreateDealScreen extends StatefulWidget {
  final DealCustom? deal;

  const CreateDealScreen({
    super.key, this.deal,
  });

  @override
  CreateDealScreenState createState() => CreateDealScreenState();

}

class CreateDealScreenState extends State<CreateDealScreen> {

  bool loading = true;
  bool saving = false;

  late String id;

  late TextEditingController headlineController;
  late TextEditingController descController;
  late TextEditingController placeController;
  late TextEditingController priceController;
  late TextEditingController dateController;
  late TextEditingController clientController;
  late DateTime createDate;
  late DateTime date;
  late ClientCustom client;

  List<Note> notesList = [];
  List<Expense> expensesList = [];
  List<Pay> paymentsList = [];

  @override
  void initState() {
    initializeScreen();
    super.initState();
  }

  Future<void> initializeScreen() async {
    setState(() {
      loading = true;
    });

    headlineController = TextEditingController();
    descController = TextEditingController();
    placeController = TextEditingController();
    priceController = TextEditingController();
    dateController = TextEditingController();
    clientController = TextEditingController();

    if (widget.deal != null) {
      id = widget.deal!.id;
      headlineController.text = widget.deal!.headline;
      descController.text = widget.deal!.desc;
      placeController.text = widget.deal!.place;
      priceController.text = widget.deal!.price.toString();
      dateController.text = '${DateMixin.getHumanDateFromDateTime(widget.deal!.date)} в ${DateMixin.getHumanTimeFromDateTime(widget.deal!.date)}';
      createDate = widget.deal!.createDate;
      date = widget.deal!.date;
      client = ClientManager.getClientFromList(widget.deal!.clientId);
      clientController.text = client.name;
      notesList = NotesManager.getNotesListForDeal(widget.deal!.id);
      expensesList = ExpensesManager.getExpensesListForDeal(widget.deal!.id);
      paymentsList = PaymentsManager.getPaymentsListForDeal(widget.deal!.id);

    } else {
      id = MixinDatabase.generateKey()!;
      createDate = DateTime.now();
      date = DateTime(2100);
      client = ClientCustom.empty();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackLight,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(text: widget.deal == null ? 'Создание сделки': 'Редактирование сделки', textState: TextState.headlineSmall, color: AppColors.white,),
          ],
        ),
        leading: IconButton(

          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: AppColors.white,
            size: 18,
          ),

          // Переход на страницу создания города
          onPressed: () {
            returnToDeals();
          },
        ),
      ),
      body: Stack(
        children: [
          if (loading) const LoadingScreen()
          else if (saving) const LoadingScreen(loadingText: 'Идет сохранение',)
          else Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        InputField(
                          controller: headlineController,
                          label: widget.deal == null ? 'Название сделки (Обязательно)' : 'Название сделки',
                          textInputType: TextInputType.text,
                          active: true,
                          icon: Icons.person,
                          needButton: headlineController.text.isNotEmpty,
                          activateButton: headlineController.text.isNotEmpty,
                          onChanged: (value) {
                            setState(() {
                              headlineController.text = value;
                            });
                          },
                          onButtonClick: (){
                            setState(() {
                              headlineController.text = '';
                            });
                          },
                          iconForButton: FontAwesomeIcons.x,
                        ),

                        const SizedBox(height: 20,),

                        InputField(
                          controller: priceController,
                          label: widget.deal == null ? 'Сумма сделки (Обязательно)' : 'Сумма сделки',
                          textInputType: TextInputType.number,
                          active: true,
                          icon: Icons.monetization_on,
                          needButton: priceController.text.isNotEmpty,
                          activateButton: priceController.text.isNotEmpty,
                          onChanged: (value) {
                            setState(() {
                              priceController.text = value;
                            });
                          },
                          onButtonClick: (){
                            setState(() {
                              priceController.text = '';
                            });
                          },
                          iconForButton: FontAwesomeIcons.x,
                        ),

                        const SizedBox(height: 20,),

                        InputField(
                          controller: descController,
                          label: 'Комментарий',
                          textInputType: TextInputType.multiline,
                          active: true,
                          icon: Icons.comment,
                          maxLines: null,
                          needButton: descController.text.isNotEmpty,
                          activateButton: descController.text != '',
                          onChanged: (value) {
                            setState(() {
                              descController.text = value;
                            });
                          },
                          onButtonClick: (){
                            setState(() {
                              descController.text = '';
                            });
                          },
                          iconForButton: FontAwesomeIcons.x,
                        ),

                        const SizedBox(height: 20,),

                        InputField(
                          controller: placeController,
                          label: 'Место',
                          textInputType: TextInputType.text,
                          active: true,
                          icon: Icons.place,
                          needButton: placeController.text.isNotEmpty,
                          activateButton: placeController.text.isNotEmpty,
                          onChanged: (value) {
                            setState(() {
                              placeController.text = value;
                            });
                          },
                          onButtonClick: (){
                            setState(() {
                              placeController.text = '';
                            });
                          },
                          iconForButton: FontAwesomeIcons.x,
                        ),

                        const SizedBox(height: 20,),

                        InputField(
                          controller: dateController,
                          label: 'Дата',
                          textInputType: TextInputType.datetime,
                          active: true,
                          needButton: true,
                          onFieldClick: () async {
                            DateTime? result = await _showDateDialog(context, date);
                            if (result != null) {
                              setState(() {
                                date = result;
                                dateController.text = '${DateMixin.getHumanDateFromDateTime(date)} в ${DateMixin.getHumanTimeFromDateTime(date)}';
                              });
                            }
                          },
                          onButtonClick: (){
                            setState(() {
                              date = DateTime(2100);
                              dateController.text = '';
                            });
                          },
                          iconForButton: FontAwesomeIcons.x,
                          icon: FontAwesomeIcons.calendarDays,
                          activateButton: date != DateTime(2100) ? true : false,

                        ),

                        const SizedBox(height: 20,),

                        InputField(
                          controller: clientController,
                          label: 'Клиент',
                          textInputType: TextInputType.text,
                          active: true,
                          needButton: true,
                          onFieldClick: () async {
                            ClientCustom? tempClient = await _showChooseClientDialog(context: context);

                            if (tempClient != null) {
                              setState(() {
                                client = tempClient;
                                clientController.text = client.name;
                              });
                            }
                          },
                          iconForButton: FontAwesomeIcons.x,
                          icon: Icons.person,
                          activateButton: client.id.isNotEmpty ? true : false,
                          onButtonClick: (){
                            setState(() {
                              client = ClientCustom.empty();
                              clientController.text = '';
                            });
                          },

                        ),

                        const SizedBox(height: 20,),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.blackLight,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextCustom(text: 'Список оплат клиента', textState: TextState.bodyBig, weight: FontWeight.bold,),
                              const SizedBox(height: 5,),
                              const TextCustom(text: 'Добавьте оплату от клиента', textState: TextState.labelMedium,),
                              SizedBox(height: paymentsList.isNotEmpty ? 10 : 20,),
                              if (paymentsList.isNotEmpty) for (Pay pay in paymentsList) PayWidget(
                                  pay: pay,
                                  onTap: () async {
                                    Pay? tempPay = await _addPayDialog(context, pay);

                                    if (tempPay != null) {
                                      setState(() {
                                        paymentsList.removeWhere((element) => element.id == tempPay.id);
                                        paymentsList.add(tempPay);
                                        paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));
                                      });
                                    }
                                  },
                                  onDelete: () async {
                                    await deletePay(pay);
                                  }
                              ),

                              if (paymentsList.isEmpty) const TextCustom(text: 'Оплата от клиента еще не поступила('),

                              const SizedBox(height: 20,),

                              CustomButton(
                                  buttonText: 'Добавить оплату',
                                  onTapMethod: () async {
                                    Pay? tempPay = await _addPayDialog(context, null);

                                    if (tempPay != null) {
                                      setState(() {
                                        paymentsList.add(tempPay);
                                        paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));
                                      });
                                    }
                                  }
                              ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextCustom(text: 'Затраты на совершение сделки', textState: TextState.bodyBig, weight: FontWeight.bold,),
                              const SizedBox(height: 5,),
                              const TextCustom(text: 'Добавьте расходы, которые вы понесете при выполнении работы', textState: TextState.labelMedium, maxLines: 10,),
                              SizedBox(height: expensesList.isNotEmpty ? 10 : 20,),
                              if (expensesList.isNotEmpty) for (Expense expense in expensesList) ExpenseWidget(
                                  expense: expense,
                                  onTap: () async {
                                    Expense? tempExpense = await _addExpenseDialog(context, expense);

                                    if (tempExpense != null) {
                                      setState(() {
                                        expensesList.removeWhere((element) => element.id == tempExpense.id);
                                        expensesList.add(tempExpense);
                                        expensesList.sort((a,b) => a.expenseDate.compareTo(b.expenseDate));
                                      });
                                    }
                                  },
                                  onDelete: () async {
                                    await deleteExpense(expense);
                                  }
                              ),

                              if (expensesList.isEmpty) const TextCustom(text: 'Нет затрат'),

                              const SizedBox(height: 20,),

                              CustomButton(
                                  buttonText: 'Добавить затраты',
                                  onTapMethod: () async {
                                    Expense? tempExpense = await _addExpenseDialog(context, null);

                                    if (tempExpense != null) {
                                      setState(() {
                                        expensesList.add(tempExpense);
                                        expensesList.sort((a,b) => a.expenseDate.compareTo(b.expenseDate));
                                      });
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50,),

                        CustomButton(
                            buttonText: 'Сохранить',
                            onTapMethod: (){
                              _saveDeal();
                            }
                        ),

                        const SizedBox(height: 20,),

                        CustomButton(
                            buttonText: 'Отменить',
                            state: ButtonState.secondary,
                            onTapMethod: (){
                              returnToDeals();
                            }
                        )

                      ],
                    ),
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deletePay(Pay pay) async {
    bool? confirmed = await exitDialog(
        context,
        "Вы действительно хотите удалить оплату? \n \n Вы не сможете восстановить данные" ,
        'Да',
        'Нет',
        'Удаление оплаты'
    );

    if (confirmed != null && confirmed){

      setState(() {
        loading = true;
      });
      String deletePay = await pay.deleteFromDb(DbInfoManager.currentUser.uid);
      if (deletePay == 'ok' || deletePay == 'Данные не найдены'){
        setState((){
          paymentsList.removeWhere((element) => element.id == pay.id);
          PaymentsManager.paymentsList.removeWhere((element) => element.id == pay.id);
          paymentsList.sort((a,b) => a.payDate.compareTo(b.payDate));
        });
        showSnackBar('Платеж успешно удален', Colors.green, 2);
      }
      setState(() {
        loading = false;
      });

    }
  }

  Future<void> deleteExpense(Expense expense) async {
    bool? confirmed = await exitDialog(
        context,
        "Вы действительно хотите удалить расход? \n \n Вы не сможете восстановить данные" ,
        'Да',
        'Нет',
        'Удаление расхода'
    );

    if (confirmed != null && confirmed){

      setState(() {
        loading = true;
      });
      String deleteExpense = await expense.deleteFromDb(DbInfoManager.currentUser.uid);
      if (deleteExpense == 'ok' || deleteExpense == 'Данные не найдены'){
        setState((){
          expensesList.removeWhere((element) => element.id == expense.id);
          ExpensesManager.expensesList.removeWhere((element) => element.id == expense.id);
          expensesList.sort((a,b) => a.expenseDate.compareTo(b.expenseDate));
        });
        showSnackBar('Расход успешно удален', Colors.green, 2);
      }
      setState(() {
        loading = false;
      });

    }
  }

  void returnToDeals(){
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/orders',
          (route) => false,
    );
  }

  Future<void> _saveDeal () async {

    setState(() {
      loading = true;
    });

    if (headlineController.text.isNotEmpty && priceController.text.isNotEmpty){

      DealCustom tempDeal = DealCustom(
          id: id,
          headline: headlineController.text,
          date: date,
          price: int.parse(priceController.text),
          createDate: createDate,
        place: placeController.text,
        desc: descController.text,
        clientId: client.id
      );

      String result = await tempDeal.publishToDb(DbInfoManager.currentUser.uid);

      for(Pay tempPay in paymentsList){
        String payResult = await tempPay.publishToDb(DbInfoManager.currentUser.uid);
        if (payResult == 'ok'){
          PaymentsManager.paymentsList.removeWhere((element) => element.id == tempPay.id);
          PaymentsManager.paymentsList.add(tempPay);

        }
      }

      for(Expense tempExpense in expensesList){
        String expenseResult = await tempExpense.publishToDb(DbInfoManager.currentUser.uid);
        if (expenseResult == 'ok'){
          ExpensesManager.expensesList.removeWhere((element) => element.id == tempExpense.id);
          ExpensesManager.expensesList.add(tempExpense);

        }
      }

      if (result == 'ok'){

        if (widget.deal != null){
          DealManager.replaceChangedDealItem(tempDeal);
        } else {
          DealManager.dealsList.add(tempDeal);
        }

        showSnackBar('Сделка успешно опубликована', Colors.green, 2);

        returnToDeals();

      } else {
        showSnackBar('Произошла ошибка - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        loading = false;
      });
    } else if (headlineController.text.isEmpty) {
      setState(() {
        loading = false;
        showSnackBar('Название сделки должно быть заполнено!', AppColors.attentionRed, 2);
      });
    } else if (priceController.text.isEmpty){
      setState(() {
        loading = false;
        showSnackBar('Укажите цену', AppColors.attentionRed, 2);
      });
    }
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Pay?> _addPayDialog(BuildContext context, Pay? pay) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddPayPopup(pay: pay, idEntity: id,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

  Future<Expense?> _addExpenseDialog(BuildContext context, Expense? expense) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddExpensePopup(expense: expense, idEntity: id,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

  Future<DateTime?> _showDateDialog(BuildContext context, DateTime date) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ChooseDatePopup(date: date); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

  Future<ClientCustom?> _showChooseClientDialog({required BuildContext context}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ClientSearchPopup(); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {
      return results;
    } else {
      return null;
    }
  }

}