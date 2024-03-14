import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/auth/auth_manager.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/auth/auth_screens/reset_password_page.dart';
import '../../database/database_info_manager.dart';
import '../../design/app_colors.dart';
import '../../design/snackBars/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showForgotPasswordButton = false;
  bool userNotFound = false;

  bool loading = false;

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

                          const TextCustom(text: "Вход", textState: TextState.headlineBig, color: AppColors.yellowLight,),

                          const SizedBox(height: 15.0),

                          const TextCustom(text: "Войдите в свой аккаунт для доступа к функциям приложения", textState: TextState.bodySmall),

                          const SizedBox(height: 25.0),

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
                            // Отобразить / скрыть пароль
                            obscureText: _isObscured,
                          ),
                          const SizedBox(height: 16.0),

                          // --- КНОПКА ВОЙТИ -----

                          CustomButton(
                              buttonText: "Войти",
                              onTapMethod: () async {
                                setState(() {
                                  loading = true;
                                });

                                String email = emailController.text;
                                String password = passwordController.text;

                                String? uid = await AuthManager.signInWithEmailAndPassword(email, password, context);

                                if (uid != null) {
                                  _reactOnUid(uid);
                                }
                              }
                          ),

                          if (showForgotPasswordButton) const SizedBox(height: 30.0),

                          if (showForgotPasswordButton) Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextCustom(text: 'Забыли пароль?', textState: TextState.bodyMedium,),
                              const SizedBox(width: 10,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                                  );
                                },
                                child: const TextCustom(text: 'Восстановить пароль', textState: TextState.bodyMedium, color: AppColors.yellowLight,),
                              ),
                            ],
                          ),

                          const SizedBox(height: 50,),

                          const TextCustom(text: "Нет аккаунта?", textState: TextState.headlineSmall, color: AppColors.yellowLight,),

                          const SizedBox(height: 10.0),


                          const TextCustom(text: "Пройдите небольшую регистрацию и пользуйтесь приложением", textState: TextState.bodySmall),

                          const SizedBox(height: 15.0),

                          CustomButton(
                              buttonText: "Зарегистрироваться",
                              state: ButtonState.secondary,
                              onTapMethod: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/reg',
                                      (route) => false,
                                );

                              }
                          ),

                          const SizedBox(height: 15.0),

                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  void navigateToProfile() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/Profile', // Название маршрута, которое вы задаете в MaterialApp
          (route) => false,
    );
    showSnackBar('Вход успешно выполнен', Colors.green, 2);

  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Функция обновления состояния "Забыли пароль?"
  void updateForgotPasswordButton(bool newValue) {
    setState(() {
      showForgotPasswordButton = newValue;
    });
  }

  // Функция для смены состояния переменной показывающей / скрывающей пароль
  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _reactOnUid(String uid) async {

    if (uid == 'wrong-password') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateForgotPasswordButton(true);
      showSnackBar('Неверный пароль. Попробуйте еще раз', AppColors.attentionRed, 2);

    } else if (uid == 'user-not-found') {

      setState(() {
        loading = false;
        userNotFound = true;
      });
      updateForgotPasswordButton(false);
      showSnackBar('Пользователь с таким Email не найден', AppColors.attentionRed, 2);

    } else if (uid == 'too-many-requests') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateForgotPasswordButton(false);
      _showAlertDialogWithButton(
          context,
          "Внимание!",
          'Слишком много неудачных попыток входа. \n \nВ целях безопасности мы на время заблокировали вход с устройства. \n \nПопробуйте позже!',
          'Ок'
      );
    } else if (uid == 'channel-error') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateForgotPasswordButton(false);

      showSnackBar('Все поля должны быть обязательно заполнены', AppColors.attentionRed, 2);



    } else if (uid == 'invalid-email') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateForgotPasswordButton(false);
      showSnackBar('Некорректный формат Email', AppColors.attentionRed, 2);

    } else {

      await DbInfoManager.getInfoFromDbAndUpdate(uid);

      navigateToProfile();

      setState(() {
        loading = false;
        userNotFound = false;
      });

    }
  }

  void _showAlertDialogWithButton(BuildContext context, String headlineText, String descText, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning, color: AppColors.yellowLight,),
              const SizedBox(width: 15,),
              Expanded(child: TextCustom(text: headlineText, textState: TextState.headlineSmall, color: AppColors.yellowLight,),),
            ],
          ),
          content: TextCustom(text: descText, textState: TextState.bodyMedium, color: AppColors.white,),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Закрываем диалог при нажатии на кнопку
              },
              child: TextCustom(text: buttonText, textState: TextState.bodyMedium, color: Colors.green,),
            )
          ],
        );
      },
    );
  }

}