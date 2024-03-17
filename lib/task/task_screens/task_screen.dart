import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/task/task_screens/create_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  TaskScreenState createState() => TaskScreenState();

}

class TaskScreenState extends State<TaskScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.graphite,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextCustom(text: 'Задачи', textState: TextState.headlineSmall, color: AppColors.white,),
            //SizedBox(height: 5,),
            TextCustom(text: 'Все ваши задачи', textState: TextState.labelSmall, color: AppColors.white,),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),

            // Переход на страницу создания города
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskCreateScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: AppColors.attentionRed,
              child: Column(
                children: [
                  TextCustom(text: 'Задачи', textState: TextState.bodyMedium, color: AppColors.white,),
                ],
              ),
            )
          ]
        ),
      )
    );
  }
}