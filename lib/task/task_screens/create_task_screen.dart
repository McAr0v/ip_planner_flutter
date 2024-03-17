import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/dates/choose_date_popup.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/date_widgets/date_time_picker.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/task/task_screens/task_screen.dart';

import '../../dates/date_mixin.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../task_status.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  TaskCreateScreenState createState() => TaskCreateScreenState();

}

class TaskCreateScreenState extends State<TaskCreateScreen> {


  late bool loading;

  late TextEditingController placeController;
  late TextEditingController commentController;
  late TextEditingController labelController;
  late TextEditingController phoneController;
  late TextEditingController instagramController;

  late DateTime startDate;
  late DateTime endDate;

  late TaskStatus status;

  /*
  String id;
  String place;+
  DateTime startDate;+
  DateTime endDate;+
  String comment;+
  String label;+
  String phone;+
  String instagram;+
  String clientId;
  DateTime createDate;
  TaskStatus status;
   */

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {

    loading = true;

    placeController = TextEditingController();
    commentController = TextEditingController();
    labelController = TextEditingController();
    phoneController = TextEditingController();
    instagramController = TextEditingController();

    startDate = DateTime(2100);
    endDate = DateTime(2100);

    status = TaskStatus();

    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.green,
          title: const TextCustom(text: 'Создание задачи', textState: TextState.bodyBig, color: AppColors.white, weight: FontWeight.bold,),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.chevronLeft, size: 18,),

            // Переход на страницу создания города
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskScreen(),
                ),
              );
            },
          ),
        ),
        body: Stack(
          children: [
            if (loading) const LoadingScreen()
            else SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: labelController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Название задачи',
                      prefixIcon: Icon(Icons.email),

                    ),
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 20,),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: commentController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Комментарий',
                      prefixIcon: Icon(Icons.email),

                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onEditingComplete: () {
                      // Обработка события, когда пользователь нажимает Enter
                      // Вы можете добавить здесь любой код, который нужно выполнить при нажатии Enter
                    },
                  ),

                  const SizedBox(height: 20,),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: phoneController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Контактный телефон',
                      prefixIcon: Icon(Icons.email),

                    ),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 20,),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: instagramController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Instagram',
                      prefixIcon: Icon(Icons.email),

                    ),
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 20,),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: placeController,
                    decoration: const InputDecoration(
                      fillColor: Colors.transparent,
                      labelText: 'Адрес',
                      prefixIcon: Icon(Icons.email),

                    ),
                    keyboardType: TextInputType.streetAddress,
                  ),

                  const SizedBox(height: 20,),

                  DateTimePickerWidget(date: startDate),

                  /*Card(
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
                                  text: startDate != DateTime(2100) ?
                                  '${DateMixin.getHumanDateFromDateTime(startDate)}, в ${DateMixin.getHumanTimeFromDateTime(startDate)}'
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
                                DateTime? result = await _showDateDialog(context, startDate);
                                if (result != null) {
                                  setState(() {
                                    startDate = result;
                                  });
                                }
                              },
                              icon: Icon(startDate != DateTime(2100) ? FontAwesomeIcons.pencil : FontAwesomeIcons.plus, size: 18,)
                          ),
                          if (startDate != DateTime(2100)) IconButton(
                              onPressed: () async {
                                setState(() {
                                  startDate = DateTime(2100);
                                });
                              },
                              icon: const Icon(FontAwesomeIcons.x, size: 18,)
                          ),
                        ],
                      ),
                    ),
                  ),*/

                ],
              )
            ),
          ],
        )
    );
  }

  // ---- Функция отображения диалога фильтра ----

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