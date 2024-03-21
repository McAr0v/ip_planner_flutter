import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import '../../dates/date_mixin.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';

class TaskWidget extends StatelessWidget {
  final TaskCustom task;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskWidget({super.key, required this.task, required this.onDelete, required this.onTap}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.blackLight,
          borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: task.status.getTaskStatusColor(),
                          borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                        ),
                        child: TextCustom(text: task.status.getTaskStatusString(needTranslate: true), textState: TextState.labelMedium),
                      ),
                      Expanded(child: TextCustom(text: task.label, textState: TextState.bodyBig, weight: FontWeight.bold,)),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  child: const Icon(FontAwesomeIcons.x, size: 14, color: AppColors.greyLight,),
                  onTap: (){
                    onDelete();
                  },
                ),
              ],
            ),


            if (task.comment.isNotEmpty) const SizedBox(height: 20,),
            /*Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: task.status.getTaskStatusColor(),
                borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
              ),
              child: TextCustom(text: task.status.getTaskStatusString(needTranslate: true), textState: TextState.labelMedium),
            ),*/

            if (task.comment.isNotEmpty) TextCustom(text: task.comment, textState: TextState.bodyMedium, maxLines: 3,),
            if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) const SizedBox(height: 20,),

            /*if (task.place.isNotEmpty) const SizedBox(height: 20,),
            if (task.place.isNotEmpty) TextCustom(text: task.place,),

            if (task.phone.isNotEmpty || task.instagram.isNotEmpty) const SizedBox(height: 20,),

            SocialWidget(phone: task.phone, instagram: task.instagram,),*/

            //if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) const SizedBox(height: 20,),
            if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (task.startDate != DateTime(2100))  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      text: '${DateMixin.getHumanDateFromDateTime(task.startDate)} в ${DateMixin.getHumanTimeFromDateTime(task.startDate)}',
                      textState: TextState.bodySmall,
                      color: Colors.green,
                    ),
                    const TextCustom(text: 'Начать выполнение', textState: TextState.labelSmall, color: AppColors.greyLight,),
                  ],
                ),
                if (task.endDate != DateTime(2100))  Column(
                  crossAxisAlignment: task.startDate != DateTime(2100) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                        text: '${DateMixin.getHumanDateFromDateTime(task.endDate)} в ${DateMixin.getHumanTimeFromDateTime(task.endDate)}',
                        textState: TextState.bodySmall,
                        color: AppColors.attentionRed
                    ),
                    const TextCustom(text: 'Завершить выполнение', textState: TextState.labelSmall, color: AppColors.greyLight,),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}