import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/auth/auth_manager.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/check_boxes/check_box_widget.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../database/database_info_manager.dart';
import '../../design/app_colors.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../user/user_custom.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();

}

class RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool privacyPolicyChecked = false;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack (
          children: [
            if (loading) const LoadingScreen()

            else SingleChildScrollView(

              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/log_in_image_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: AppColors.black.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const TextCustom(text: "Регистрация", textState: TextState.headlineBig, color: AppColors.yellowLight,),

                          const SizedBox(height: 15.0),

                          const TextCustom(text: "Пройдите небольшую регистрацию, заполнив все поля", textState: TextState.bodyMedium),

                          const SizedBox(height: 25.0),

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: nameController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Имя',
                              prefixIcon: Icon(Icons.person),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16.0),

                          // --- ПОЛЕ EMAIL -----

                          TextField(
                            style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontFamily: 'sf_custom',
                            fontWeight: FontWeight.normal,
                          ),
                            controller: emailController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16.0),

                          // ---- ПОЛЕ ПАРОЛЬ -----

                          TextField(
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'sf_custom',
                              fontWeight: FontWeight.normal,
                            ),
                            controller: passwordController,
                            decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                prefixIcon: const Icon(Icons.key),
                                labelText: 'Пароль',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscured ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                )
                            ),
                            obscureText: _isObscured,
                          ),
                          const SizedBox(height: 20.0),

                          CheckBoxWidget(
                              text: 'Подтверждаю согласие с правилами',
                              checkBoxValue: privacyPolicyChecked,
                              onChanged: (value) {
                                togglePrivacyPolicyChecked();
                              },
                              withLink: true,
                              textForLink: 'политики конфиденциальности',
                              link: '/privacy_policy',
                          ),

                          const SizedBox(height: 20.0),

                          // --- КНОПКА ВОЙТИ -----

                          CustomButton(
                              buttonText: "Зарегистрироваться",
                              onTapMethod: () async {
                                setState(() {
                                  loading = true;
                                });

                                if (!privacyPolicyChecked){

                                  showSnackBar('Подтвердите согласие с правилами политики конфиденциальности', AppColors.attentionRed, 2);

                                  // Останавливаем регистрацию
                                  setState(() {
                                    loading = false;
                                  });

                                } else if (nameController.text.isEmpty){

                                  showSnackBar('Имя не указано', AppColors.attentionRed, 2);

                                  // Останавливаем регистрацию
                                  setState(() {
                                    loading = false;
                                  });

                                } else {

                                  String name = nameController.text;
                                  String email = emailController.text;
                                  String password = passwordController.text;

                                  String? uid = await AuthManager.createUserWithEmailAndPassword(email, password);

                                  if (uid != null){

                                    await reactOnUid(name, email, uid);

                                  } else {

                                    // Обработка случая, когда создание пользователя не удалось

                                    showSnackBar(
                                        "Что-то пошло не так. Попробуйте еще раз",
                                        AppColors.attentionRed,
                                        3
                                    );
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              }
                          ),

                          const SizedBox(height: 50.0),

                          const TextCustom(text: "Есть аккаунт?", textState: TextState.headlineSmall, color: AppColors.yellowLight,),

                          const SizedBox(height: 15.0),

                          const TextCustom(
                            text: 'Войдите в свой аккаунт, если он уже был создан',
                            textState: TextState.bodyMedium,
                          ),

                          const SizedBox(height: 20.0),

                          CustomButton(
                            state: ButtonState.secondary,
                            buttonText: 'Войти?',
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
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  void navigateToProfilePage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/Profile',
          (route) => false,
    );
  }

  // Функция показа всплывающего меню
  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void togglePrivacyPolicyChecked() {
    setState(() {
      privacyPolicyChecked = !privacyPolicyChecked;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> reactOnUid(String name, String email, String uid) async {

    if (uid == 'weak-password'){

      showSnackBar(
          "Слабый пароль. Введите минимум 6 символов",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'email-already-in-use'){

      showSnackBar(
          "Пользователь с таким Email уже существует. Попробуйте выполнить вход в аккаунт",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'channel-error'){

      showSnackBar(
          "Все поля должны быть обязательно заполнены",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'invalid-email'){

      showSnackBar(
          "Некорректный формат Email",
          AppColors.attentionRed,
          2
      );

    } else {

      UserCustom userInfo = UserCustom(
          uid: uid,
          email: email,
          name: name,
      );

      String result = await userInfo.publishToDb(uid);

      if (result == 'ok'){
        await DbInfoManager.getInfoFromDbAndUpdate(userInfo.uid);
        showSnackBar(
            "Вход успешно выполнен!",
            Colors.green,
            2
        );
        navigateToProfilePage();
      }
      setState(() {
        loading = false;
      });

    }
  }
}