import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../dates/date_mixin.dart';
import '../app_colors.dart';
import '../text_widgets/text_custom.dart';
import '../text_widgets/text_state.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime date;
  final VoidCallback addDate;
  final VoidCallback clearDate;
  final String desc;
  final double padding;
  final Color backgroundColor;

  const DateTimePickerWidget({super.key, required this.date, required this.addDate, required this.clearDate, required this.desc, this.padding = 0, this.backgroundColor = AppColors.black});

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
    return Container(
      color: widget.backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
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
                        : "Дата и время не выбраны",
                    textState: TextState.bodyBig,
                  ),
                  TextCustom(
                    text: widget.desc,
                    textState: TextState.labelMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            IconButton(
                onPressed: () async {
                  widget.addDate();
                },
                icon: Icon(widget.date != DateTime(2100) ? FontAwesomeIcons.pencil : FontAwesomeIcons.plus, size: 18, color: widget.date != DateTime(2100) ? AppColors.yellowLight : AppColors.white,)
            ),
            if (widget.date != DateTime(2100)) IconButton(
                onPressed: () async {
                  widget.clearDate();
                },
                icon: const Icon(FontAwesomeIcons.x, size: 18, color: AppColors.attentionRed,)
            ),
          ],
        ),
      ),
    );
  }
}