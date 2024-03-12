import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Expanded(
        child: Center(
          child: Text(
            'Страница задач',
            style: TextStyle(color: AppColors.brandColor),
          ),
        )
    );
  }
}