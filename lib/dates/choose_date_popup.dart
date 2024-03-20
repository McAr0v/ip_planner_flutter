import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';

import '../design/app_colors.dart';
import '../design/buttons/custom_button.dart';


class ChooseDatePopup extends StatefulWidget {

  final DateTime date;

  const ChooseDatePopup({super.key, required this.date});

  @override
  ChooseDatePopupState createState() => ChooseDatePopupState();
}

// -- Виджет отображения фильтра в мероприятиях ---

class ChooseDatePopupState extends State<ChooseDatePopup> {

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    if (widget.date != DateTime(2100)) {
      selectedDate = widget.date;
      selectedTime = TimeOfDay.fromDateTime(selectedDate);
    }

  }

  // ---- САМ ЭКРАН ФИЛЬТРА -----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    // ---- Заголовок фильтра и иконка ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    TextCustom(text: 'Дата и время', textState: TextState.headlineSmall,),

                                    SizedBox(height: 10,),

                                    TextCustom(text: 'Выбери дату и время', textState: TextState.labelMedium,),

                                  ],
                                )
                            )
                        ),

                        // --- Иконка ----

                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8.0),

                    // ---- Содержимое фильтра -----

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
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(text: selectedDate != DateTime(2100) ? DateMixin.getHumanDateFromDateTime(selectedDate) : "Не выбрано", textState: TextState.bodyBig,),
                                      const SizedBox(height: 5.0),
                                      const TextCustom(text: 'Выбранная дата', textState: TextState.labelSmall,),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 20.0),

                                IconButton(
                                  onPressed: (){
                                    _selectDate(context, selectedDate);
                                  },
                                  icon: const Icon(FontAwesomeIcons.pencil, size: 18,),
                                ),

                              ],
                            ),

                            const SizedBox(height: 20.0),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(text: selectedDate != DateTime(2100) ? DateMixin.getHumanTime(selectedTime) : "Не выбрано", textState: TextState.bodyBig,),
                                      const SizedBox(height: 5.0),
                                      const TextCustom(text: 'Выбранное время', textState: TextState.labelSmall,),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 20.0),

                                IconButton(
                                  onPressed: (){
                                    _selectTime(context);
                                  },
                                  icon: const Icon(FontAwesomeIcons.pencil, size: 18,),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),

                    // ---- Кнопки ПРИМЕНИТЬ / Отменить ---

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

                            DateTime tempDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);

                            Navigator.of(context).pop(tempDateTime);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10.0),

                  ],
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      helpText: 'Выбери время',
      cancelText: "Отменить",
      confirmText: "Выбрать",
      errorInvalidText: 'Неверно введен формат времени',
      hourLabelText: "Часы",
      minuteLabelText: "Минуты",
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      orientation: Orientation.portrait,
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }

  }

  Future<void> _selectDate(BuildContext context, DateTime initial) async {

    final DateTime? picked = await showDatePicker(

      //locale: const Locale('ru', 'RU'),
      context: context,
      initialDate: initial.isBefore(DateTime.now()) ? DateTime.now() : initial,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Выбери дату',
      cancelText: 'Отмена',
      confirmText: 'Подтвердить',
      keyboardType: TextInputType.datetime,
      currentDate: DateTime.now(),
    );

    if (picked != null){
      setState(() {
        selectedDate = picked;
      });

    }

  }

}