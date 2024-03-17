import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../dates/choose_date_popup.dart';
import '../../dates/date_mixin.dart';
import '../app_colors.dart';
import '../text_widgets/text_custom.dart';
import '../text_widgets/text_state.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime date;

  const DateTimePickerWidget({super.key, required this.date});

  @override
  DateTimePickerWidgetState createState() => DateTimePickerWidgetState();

}

class DateTimePickerWidgetState extends State<DateTimePickerWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blackLight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    text: widget.date != DateTime(2100) ?
                    '${DateMixin.getHumanDateFromDateTime(widget.date)}, в ${DateMixin.getHumanTimeFromDateTime(widget.date)}'
                        : "Не выбрано",
                    textState: TextState.bodyBig,
                  ),
                  const TextCustom(
                    text: 'Начало',
                    textState: TextState.labelMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            IconButton(
                onPressed: () async {
                  DateTime? result = await _showDateDialog(context, widget.date);
                  if (result != null) {
                    setState(() {
                      //widget.date = result;
                    });
                  }
                },
                icon: Icon(widget.date != DateTime(2100) ? FontAwesomeIcons.pencil : FontAwesomeIcons.plus, size: 18,)
            ),
            if (widget.date != DateTime(2100)) IconButton(
                onPressed: () async {
                  setState(() {
                    //startDate = DateTime(2100);
                  });
                },
                icon: const Icon(FontAwesomeIcons.x, size: 18,)
            ),
          ],
        ),
      ),
    );
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

}