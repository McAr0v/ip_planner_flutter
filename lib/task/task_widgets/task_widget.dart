import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/design/social_widgets/social_widget.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_class.dart';
import '../../dates/date_mixin.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../links/open_url_class.dart';
import '../../links/url_path_enum.dart';
import '../task_screens/create_task_screen.dart';

class TaskWidget extends StatelessWidget {
  final TaskCustom task; // Передаваемая переменная
  final VoidCallback onDelete; // Передаваемая переменная

  const TaskWidget({super.key, required this.task, required this.onDelete}); // required - значит, что обязательно

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: TextCustom(text: task.label, textState: TextState.bodyBig, weight: FontWeight.bold,)),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    child: const Icon(FontAwesomeIcons.pencil, size: 16, color: AppColors.yellowLight,),
                    onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskCreateScreen(task: task,),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 30,),
                  GestureDetector(
                    child: const Icon(FontAwesomeIcons.x, size: 16, color: AppColors.attentionRed,),
                    onTap: (){
                      onDelete();
                    },
                  ),
                ],
              ),

              if (task.comment.isNotEmpty) const SizedBox(height: 20,),
              if (task.comment.isNotEmpty) TextCustom(text: task.comment, textState: TextState.bodyMedium, maxLines: 3,),

              if (task.place.isNotEmpty) const SizedBox(height: 20,),
              if (task.place.isNotEmpty) TextCustom(text: task.place,),

              if (task.phone.isNotEmpty || task.instagram.isNotEmpty) const SizedBox(height: 20,),

              SocialWidget(phone: task.phone, instagram: task.instagram,),

              if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) const SizedBox(height: 20,),
              if (task.startDate != DateTime(2100) || task.endDate != DateTime(2100)) Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.startDate != DateTime(2100))  TextCustom(
                        text: '${DateMixin.getHumanDateFromDateTime(task.startDate)} в ${DateMixin.getHumanTimeFromDateTime(task.startDate)}',
                        textState: TextState.bodySmall,
                        color: Colors.green,
                      ),
                      if (task.startDate != DateTime(2100))  const TextCustom(text: 'Начать выполнение', textState: TextState.labelSmall, color: AppColors.greyLight,),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (task.endDate != DateTime(2100)) TextCustom(
                          text: '${DateMixin.getHumanDateFromDateTime(task.endDate)} в ${DateMixin.getHumanTimeFromDateTime(task.endDate)}',
                          textState: TextState.bodySmall,
                          color: AppColors.attentionRed
                      ),
                      if (task.endDate != DateTime(2100)) const TextCustom(text: 'Завершить выполнение', textState: TextState.labelSmall, color: AppColors.greyLight,),
                    ],
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}