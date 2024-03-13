import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../design/app_colors.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  ConfirmEmailScreenState createState() => ConfirmEmailScreenState();

}

class ConfirmEmailScreenState extends State<ConfirmEmailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack (
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25.0),
                  const TextCustom(text: "Подтверди почту", textState: TextState.headlineBig, color: AppColors.yellowLight,),
                  const SizedBox(height: 15.0),
                  const TextCustom(text: "Тебе нужно подтвердить свою почту, которую ты указал при регистрации.", textState: TextState.bodyMedium),
                  const SizedBox(height: 5.0),
                  const TextCustom(text: "Мы отправили письмо с подробной инструкцией. Просто подтверди почту и войди в приложение", textState: TextState.bodyMedium),

                  const SizedBox(height: 25.0),

                  CustomButton(
                    state: ButtonState.secondary,
                    buttonText: 'Вход в аккаунт',
                    onTapMethod: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/logIn',
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}