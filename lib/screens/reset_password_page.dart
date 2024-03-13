import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/screens/registration_screen.dart';
import '../design/app_colors.dart';
import '../design/buttons/custom_button.dart';
import '../design/snackBars/custom_snack_bar.dart';
import '../design/text_widgets/text_custom.dart';
import '../design/text_widgets/text_state.dart';
import '../user/user_custom.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});


  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();

}

// ---- Экран сброса пароля ---

class ResetPasswordPageState extends State<ResetPasswordPage> {

  // --- Контроллеры для полей ввода ----
  final TextEditingController emailController = TextEditingController();

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

  // ----- Отображение кнопки Регистрация -----

  bool showRegButton = false;

  void updateShowRegButton(bool newValue) {
    setState(() {
      showRegButton = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // TODO Сделать экран загрузки, пока идет функция сброса пароля

            // ---- Заголовок и описание ------

            const SizedBox(height: 25.0),

            const TextCustom(text: "Восстановление пароля", textState: TextState.headlineMedium, color: AppColors.yellowLight,),
            const SizedBox(height: 15.0),
            const TextCustom(text: 'Забытый пароль – не повод для печали! Укажи свою почту, и мы отправим тебе инструкцию по восстановлению пароля', textState: TextState.bodyMedium),

            const SizedBox(height: 25.0),

            // ---- Поле ввода email -----

            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),

            // ----- Кнопка восстановления пароля ----

            CustomButton(
                buttonText: 'Восстановить пароль',
                onTapMethod: () async {

                  String email = emailController.text;

                  // Сброс пароля
                  // TODO - Сделать экран загрузки
                  String? textMessage = await UserCustom.resetPassword(email);

                  // --- Если есть результат функции сброса ----

                  if (textMessage != null) {

                    reactOnTextMessage(textMessage);

                  } else {

                    showSnackBar('Что-то пошло не так, и мы с ним не знакомы. Попробуй войти позже, и, возможно, все недоразумение разрешится', AppColors.attentionRed, 5);

                  }
                }
            ),

            // ---- Контент кнопки регистрации -----

            if (showRegButton) const SizedBox(height: 50.0),

            if (showRegButton) const TextCustom(
                text: 'Ой-ой! Нет пользователя с таким Email. Может нужно создать новый аккаунт? 📩🔍',
                textState: TextState.bodyMedium,
            ),

            if (showRegButton) const SizedBox(height: 20.0),

            if (showRegButton) CustomButton(
              state: ButtonState.secondary,
              buttonText: 'Зарегистрироваться',
              onTapMethod: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void reactOnTextMessage(String textMessage) {
    if (textMessage == 'invalid-email') {
      updateShowRegButton(false);
      showSnackBar('Ой, что-то с форматом Email пошло не так. Удостоверься, что вводишь его правильно, и давай еще раз! 📭🔄', AppColors.attentionRed, 5);
    } else if (textMessage == 'user-not-found') {
      updateShowRegButton(true);
      showSnackBar('Упс! Похоже, такой Email не зарегистрирован. Может, опечатка? Попробуй еще раз или зарегистрируйcя! 📧🤔', AppColors.attentionRed, 5);
    } else if (textMessage == 'too-many-requests') {
      updateShowRegButton(false);
      showSnackBar('Ой! Слишком много попыток. В целях безопасности мы заблокировали вход с твоего устройства. Попробуй позже! 🔒⏳', AppColors.attentionRed, 5);
    } else if (textMessage == 'missing-email') {
      updateShowRegButton(false);
      showSnackBar('Без твоей почты мы в тупике. Поделись ею, и мы вмиг отправим инструкции по восстановлению пароля.', AppColors.attentionRed, 5);
    } else if (textMessage == 'success') {

      showSnackBar('Проверь свою почту – мы отправили инструкции по восстановлению пароля. Следуй шагам и верни доступ к аккаунту', Colors.green,5);
      navigateToLogin();
    } else {
      showSnackBar('Ой! Что-то у нас пошло не так, и мы в печали. Попробуй войти позже', AppColors.attentionRed, 5);
    }
  }
}