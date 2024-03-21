import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/clients/gender_class.dart';
import 'package:ip_planner_flutter/clients/gender_enum.dart';
import '../../design/app_colors.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';

class GenderPickerWidget extends StatefulWidget {

  final Gender gender;

  const GenderPickerWidget({super.key, required this.gender});

  @override
  GenderPickerWidgetState createState() => GenderPickerWidgetState();

}

class GenderPickerWidgetState extends State<GenderPickerWidget> {

  List<GenderEnum> list = [
    GenderEnum.notChosen,
    GenderEnum.male,
    GenderEnum.female,

  ];

  late GenderEnum chosenGender;
  int chosenIndex = 0;

  @override
  void initState() {
    super.initState();
    chosenGender = widget.gender.gender;
    chosenIndex = getIndex(chosenGender);


  }

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

                                      TextCustom(text: 'Статус задачи', textState: TextState.headlineSmall,),

                                      SizedBox(height: 10,),

                                      TextCustom(text: 'Выбери статус задачи', textState: TextState.labelMedium,),

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

                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: list.length,
                            itemBuilder: (context, index) {

                              Gender gender = Gender(gender: list[index]);

                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    chosenGender = list[index];
                                    chosenIndex = getIndex(chosenGender);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: chosenIndex == index ? AppColors.yellowLight : AppColors.black,
                                    borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(text: gender.getGenderString(needTranslate: true), color: chosenIndex == index ? AppColors.black : AppColors.white,),
                                    ],
                                  ),
                                ),
                              );
                            }
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
                              Gender tempGender = Gender(gender: chosenGender);
                              Navigator.of(context).pop(tempGender);
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

  int getIndex (GenderEnum gender) {
    for (int i = 0; i<list.length; i++){
      if (list[i] == gender) return i;
    }

    return -1;

  }

}