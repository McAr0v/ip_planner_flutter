import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/pay/pay_type.dart';
import 'package:ip_planner_flutter/pay/pay_type_enum.dart';
import '../../design/app_colors.dart';
import '../../design/input_fields/input_field.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../pay_class.dart';

class AddPayPopup extends StatefulWidget {

  final Pay? pay;
  final String idEntity;

  const AddPayPopup({super.key, required this.pay, required this.idEntity});

  @override
  AddPayPopupState createState() => AddPayPopupState();
}

class AddPayPopupState extends State<AddPayPopup> {

  late TextEditingController priceController;
  late TextEditingController dateController;
  late String id;
  PayType payType = PayType();
  DateTime payDate = DateTime.now();

  late PayTypeEnum _selectedSortingOption = PayTypeEnum.notChosen;

  @override
  void initState() {

    priceController = TextEditingController();
    dateController = TextEditingController();

    if (widget.pay != null) {
      id = widget.pay!.id;
      priceController.text = widget.pay!.sum.toString();
      payType = widget.pay!.payType;
      payDate = widget.pay!.payDate;
      _selectedSortingOption = widget.pay!.payType.payType;
      dateController.text = DateMixin.getHumanDateFromDateTime(widget.pay!.payDate);

    } else {
      id = MixinDatabase.generateKey()!;
      dateController.text = DateMixin.getHumanDateFromDateTime(payDate);
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

                                      const TextCustom(text: 'Оплата', textState: TextState.headlineSmall,),

                                      const SizedBox(height: 10,),

                                      //TextCustom(text: 'Оплата за сделку ${DealManager.getDeal(widget.idEntity).headline}', textState: TextState.labelMedium,),
                                      TextCustom(text: 'Оплата за сделку', textState: TextState.labelMedium,),

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
                                label: 'Сумма оплаты (Обязательно)',
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
                                needButton: payDate != DateTime(2100) ? true : false,
                                onFieldClick: () async {
                                  _selectDate(context, payDate != DateTime(2100) ? payDate : DateTime.now());
                                },
                                onButtonClick: (){
                                  setState(() {
                                    payDate = DateTime(2100);
                                    dateController.text = '';
                                  });
                                },
                                iconForButton: FontAwesomeIcons.x,
                                icon: FontAwesomeIcons.calendarDays,
                                activateButton: payDate != DateTime(2100) ? true : false,

                              ),

                              const SizedBox(height: 20.0),

                              Row(
                                children: [
                                  const TextCustom(text: 'Способ оплаты:'),

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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  GestureDetector(
                                      child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                                      onTap: (){
                                        setState(() {
                                          // --- При отмене просто уходим, без аргументов
                                          Navigator.of(context).pop();
                                        });
                                      }
                                  ),

                                  const SizedBox(width: 30.0),

                                  GestureDetector(
                                    child: const TextCustom(text: 'Применить', color: Colors.green,),
                                    onTap: (){

                                      if (priceController.text.isEmpty){
                                        showSnackBar('Сумма оплаты должна быть обязательно заполнена', AppColors.attentionRed, 2);
                                      } else {
                                        if (int.tryParse(priceController.text) == null) {
                                          showSnackBar('Некорректно введена сумма', AppColors.attentionRed, 2);
                                        } else {
                                          Pay tempPay = Pay(id: id, sum: int.parse(priceController.text), payType: PayType(payType: _selectedSortingOption), idEntity: widget.idEntity, payDate: payDate);

                                          Navigator.of(context).pop(tempPay);
                                        }
                                      }
                                    },
                                  ),
                                ],
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
        payDate = picked;
        dateController.text = DateMixin.getHumanDateFromDateTime(payDate);

      });
    }
  }

}