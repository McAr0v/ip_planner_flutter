import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import '../../design/app_colors.dart';
import '../../design/buttons/custom_button.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../design/text_widgets/text_custom.dart';
import '../../design/text_widgets/text_state.dart';
import '../auth_manager.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();

}

// ---- Экран сброса пароля ---

class ResetPasswordPageState extends State<ResetPasswordPage> {

  // --- Контроллеры для полей ввода ----
  final TextEditingController emailController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const TextCustom(text: "Восстановление пароля", textState: TextState.headlineMedium, color: AppColors.yellowLight,),

                        const SizedBox(height: 15.0),

                        const TextCustom(text: 'Введите вашу почту. Мы отправим письмо с инструкцией по сбросу пароля', textState: TextState.bodySmall),

                        const SizedBox(height: 25.0),

                        // ---- Поле ввода email -----

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
                        const SizedBox(height: 25.0),

                        // ----- Кнопка восстановления пароля ----

                        CustomButton(
                            buttonText: 'Восстановить пароль',
                            onTapMethod: () async {

                              setState(() {
                                loading = true;
                              });

                              String email = emailController.text;

                              // Сброс пароля
                              String? textMessage = await AuthManager.resetPassword(email);

                              // --- Если есть результат функции сброса ----

                              if (textMessage != null) {

                                reactOnTextMessage(textMessage);

                              } else {

                                setState(() {
                                  loading = false;
                                });

                                showSnackBar('Что-то пошло не так, и мы с ним не знакомы. Попробуй войти позже', AppColors.attentionRed, 5);

                              }
                            }
                        ),
                        const SizedBox(height: 20.0),

                        CustomButton(
                            buttonText: 'Вернуться назад',
                            state: ButtonState.secondary,
                            onTapMethod: (){
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Функция перехода в мероприятия ------
  void navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/logIn', // Название маршрута, которое вы задаете в MaterialApp
          (route) => false,
    );
  }

  // ---- Функция показа всплывающего сообщения ----

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void reactOnTextMessage(String textMessage) {
    if (textMessage == 'invalid-email') {

      setState(() {
        loading = false;
      });
      showSnackBar('Неверный формат Email', AppColors.attentionRed, 2);
    } else if (textMessage == 'user-not-found') {

      setState(() {
        loading = false;
      });
      showSnackBar('Пользователя с таким Email не существует', AppColors.attentionRed, 2);
    } else if (textMessage == 'too-many-requests') {
      _showAlertDialogWithButton(
        context: context,
        headlineText: 'Внимание!',
        descText: 'Слишком много неудачных попыток входа. \n \nВ целях безопасности мы на время заблокировали вход с устройства. \n \nПопробуйте позже!',
        buttonText: "Ок",
        onTapMethod: (){
          navigateToLogin();
        },
          icon: Icons.warning,
          color: AppColors.yellowLight
      );

      setState(() {
        loading = false;
      });
    } else if (textMessage == 'missing-email') {

      setState(() {
        loading = false;
      });
      showSnackBar('Введите Email', AppColors.attentionRed, 5);
    } else if (textMessage == 'success') {
      _showAlertDialogWithButton(
          context: context,
          headlineText: 'Сброс успешно выполнен',
          descText: 'Проверьте почту – мы отправили инструкции по восстановлению пароля.',
          buttonText: "Ок",
        onTapMethod: (){
          navigateToLogin();
        },
        icon: FontAwesomeIcons.check,
        color: Colors.green
      );
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      showSnackBar('Ой! Что-то у нас пошло не так, и мы в печали. Попробуй войти позже', AppColors.attentionRed, 5);
    }
  }

  void _showAlertDialogWithButton(
      {
        required BuildContext context,
        required String headlineText,
        required String descText,
        required String buttonText,
        required VoidCallback onTapMethod,
        Color color = Colors.green,
        IconData icon = Icons.warning
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color,),
              const SizedBox(width: 15,),
              Expanded(child: TextCustom(text: headlineText, textState: TextState.headlineSmall, color: color,),),
            ],
          ),
          content: TextCustom(text: descText, textState: TextState.bodyMedium, color: AppColors.white,),
          actions: <Widget>[
            GestureDetector(
              onTap: onTapMethod,
              child: TextCustom(text: buttonText, textState: TextState.bodyMedium, color: Colors.green,),
            )
          ],
        );
      },
    );
  }

}