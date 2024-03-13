import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/user/user_custom.dart';

import '../design/buttons/button_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppColors.black,
      child: Row(
        children: [
          Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Страница профиля',
                      style: TextStyle(color: AppColors.yellowLight),
                    ),

                    CustomButton(
                        buttonText: "Выйти",
                        state: ButtonState.secondary,
                        onTapMethod: () {

                          UserCustom.signOut();

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/logIn',
                                (route) => false,
                          );

                        }
                    ),

                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}