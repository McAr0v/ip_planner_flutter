import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Expanded(
        child: Center(
          child: Text(
            'Страница статистики',
            style: TextStyle(color: AppColors.brandColor),
          ),
        )
    );
  }
}