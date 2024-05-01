import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/design/buttons/buttons_for_popup.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/expenses/expense_class.dart';
import 'package:ip_planner_flutter/expenses/expense_type.dart';
import 'package:ip_planner_flutter/expenses/expense_type_enum.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';
import 'package:ip_planner_flutter/pay/pay_type_enum.dart';
import '../../design/app_colors.dart';
import '../../design/input_fields/input_field.dart';
import '../../design/snackBars/custom_snack_bar.dart';

class AddExpensePopup extends StatefulWidget {

  final Expense? expense;
  final String idEntity;

  const AddExpensePopup({super.key, required this.expense, required this.idEntity});

  @override
  AddExpensePopupState createState() => AddExpensePopupState();
}

class AddExpensePopupState extends State<AddExpensePopup> {

  late TextEditingController priceController;
  late TextEditingController dateController;
  late TextEditingController commentController;
  late String id;
  PayType payType = PayType();
  ExpenseType expenseType = ExpenseType();
  DateTime expenseDate = DateTime.now();

  late PayTypeEnum _selectedSortingOption = PayTypeEnum.notChosen;
  late ExpenseTypeEnum _selectedExpenseSortingOption = ExpenseTypeEnum.notChosen;

  late DealCustom deal;

  @override
  void initState() {

    priceController = TextEditingController();
    dateController = TextEditingController();
    commentController = TextEditingController();

    deal = DealManager.getDeal(widget.idEntity);

    if (widget.expense != null) {
      id = widget.expense!.id;
      priceController.text = widget.expense!.sum.toString();
      payType = widget.expense!.payType;
      expenseDate = widget.expense!.expenseDate;
      expenseType = widget.expense!.expenseType;
      _selectedSortingOption = widget.expense!.payType.payType;
      _selectedExpenseSortingOption = widget.expense!.expenseType.expenseType;
      dateController.text = DateMixin.getHumanDateFromDateTime(widget.expense!.expenseDate);
      commentController.text = widget.expense!.comment;

    } else {
      id = MixinDatabase.generateKey()!;
      dateController.text = DateMixin.getHumanDateFromDateTime(expenseDate);
    }

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black.withOpacity(0.6),
      body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.blackLight,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      const TextCustom(text: 'Затраты', textState: TextState.headlineSmall,),

                                      const SizedBox(height: 10,),

                                      /*TextCustom(
                                        text: deal.headline.isNotEmpty ? 'Расходы на сделку ${DealManager.getDeal(widget.idEntity).headline}' : 'Заполните данные о затратах',
                                        textState: TextState.labelMedium,
                                      ),*/

                                    ],
                                  )
                              )
                          ),


                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8.0),

                      SingleChildScrollView (
                        child: Container (
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blackLight,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              InputField(
                                controller: priceController,
                                label: 'Сумма затрат (Обязательно)',
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
                                controller: dateController,
                                label: 'Дата оплаты',
                                textInputType: TextInputType.datetime,
                                active: true,
                                needButton: expenseDate != DateTime(2100) ? true : false,
                                onFieldClick: () async {
                                  _selectDate(context, expenseDate != DateTime(2100) ? expenseDate : DateTime.now());
                                },
                                onButtonClick: (){
                                  setState(() {
                                    expenseDate = DateTime(2100);
                                    dateController.text = '';
                                  });
                                },
                                iconForButton: FontAwesomeIcons.x,
                                icon: FontAwesomeIcons.calendarDays,
                                activateButton: expenseDate != DateTime(2100) ? true : false,

                              ),

                              const SizedBox(height: 20.0),

                              InputField(
                                controller: commentController,
                                label: 'Комментарий',
                                textInputType: TextInputType.text,
                                active: true,
                                icon: Icons.comment,
                                needButton: commentController.text.isNotEmpty,
                                activateButton: commentController.text.isNotEmpty,
                                onChanged: (value) {
                                  setState(() {
                                    commentController.text = value;
                                  });
                                },
                                onButtonClick: (){
                                  setState(() {
                                    commentController.text = '';
                                  });
                                },
                                iconForButton: FontAwesomeIcons.x,
                              ),

                              const SizedBox(height: 20.0),

                              Row(
                                children: [

                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.3,
                                    child: const TextCustom(text: 'Способ оплаты:', maxLines: 10,),
                                  ),

                                  const SizedBox(width: 20.0),

                                  Expanded(
                                    child: DropdownButton(
                                      style: Theme.of(context).textTheme.bodySmall,
                                      isExpanded: true,
                                      value: _selectedSortingOption,
                                      onChanged: (PayTypeEnum? newValue) {
                                        setState(() {
                                          _selectedSortingOption = newValue!;
                                        });
                                      },
                                      items: PayType().getPaySortingOptionsList(),
                                    ),
                                  ),
                                ],
                              ),



                              const SizedBox(height: 20.0),

                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.3,
                                    child: const TextCustom(text: 'Статья затрат:'),
                                  ),


                                  const SizedBox(width: 20.0),

                                  Expanded(
                                    child: DropdownButton(
                                      style: Theme.of(context).textTheme.bodySmall,
                                      isExpanded: true,
                                      value: _selectedExpenseSortingOption,
                                      onChanged: (ExpenseTypeEnum? newValue) {
                                        setState(() {
                                          _selectedExpenseSortingOption = newValue!;
                                        });
                                      },
                                      items: ExpenseType().getExpenseSortingOptionsList(),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20.0),

                              ButtonsForPopup(
                                  cancelText: 'Отменить',
                                  confirmText: 'Применить',
                                  onCancel: (){
                                    setState(() {
                                      // --- При отмене просто уходим, без аргументов
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onConfirm: (){

                                    if (priceController.text.isEmpty){
                                      showSnackBar('Сумма оплаты должна быть обязательно заполнена', AppColors.attentionRed, 2);
                                    } else {
                                      if (int.tryParse(priceController.text) == null) {
                                        showSnackBar('Некорректно введена сумма', AppColors.attentionRed, 2);
                                      } else {
                                        Expense tempExpense = Expense(
                                            id: id,
                                            sum: int.parse(priceController.text),
                                            payType: PayType(payType: _selectedSortingOption),
                                            idEntity: widget.idEntity,
                                            expenseType: ExpenseType(expenseType: _selectedExpenseSortingOption),
                                            expenseDate: expenseDate,
                                            comment: commentController.text
                                        );

                                        Navigator.of(context).pop(tempExpense);
                                      }
                                    }
                                  }
                              ),

                              const SizedBox(height: 10.0),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _selectDate(BuildContext context, DateTime initial) async {

    final DateTime? picked = await showDatePicker(

      //locale: const Locale('ru', 'RU'),
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
      helpText: 'Выбери дату',
      cancelText: 'Отмена',
      confirmText: 'Подтвердить',
      keyboardType: TextInputType.datetime,
      currentDate: DateTime.now(),
    );

    if (picked != null){
      setState(() {
        expenseDate = picked;
        dateController.text = DateMixin.getHumanDateFromDateTime(expenseDate);

      });
    }
  }

}