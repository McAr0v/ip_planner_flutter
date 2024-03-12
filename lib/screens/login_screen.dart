import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../user/user_custom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  LoginScreenState createState() => LoginScreenState();

}

// ----- ЭКРАН ВХОДА ------

class LoginScreenState extends State<LoginScreen> {

  // Инициализируем класс с функциями для входа
  //final AuthWithEmail authWithEmail = AuthWithEmail();

  // Контроллеры полей ввода
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Функция перехода в профиль
  void navigateToProfile() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/Profile', // Название маршрута, которое вы задаете в MaterialApp
          (route) => false,
    );
  }

  // Функция показа всплывающего меню
  /*void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }*/

  // Переменные отображения "забыли пароль" и "Может нужна регистрация?"

  bool showForgotPasswordButton = false;
  bool showRegButton = false;

  bool loading = false;

  // Функция обновления состояния "Забыли пароль?"
  void updateForgotPasswordButton(bool newValue) {
    setState(() {
      showForgotPasswordButton = newValue;
    });
  }

  // Функция обновления состояния "Может нужна регистрация?"
  void updateShowRegButton(bool newValue) {
    setState(() {
      showRegButton = newValue;
    });
  }

  // Переменная - показать / скрыть пароль
  bool _isObscured = true;

  // Функция для смены состояния переменной показывающей / скрывающей пароль
  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Вход'),
        ),
        body: Stack (
          children: [
            if (loading) const Center(
              child: CircularProgressIndicator(),
            )

            else SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // --- ЗАГОЛОВОК И ПОДПИСЬ

                  Text('Вход', style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 15.0),
                  Text('Привет, дружище! Скучали по тебе! Входи в свой аккаунт и окунись в атмосферу увлекательных событий. 🚀😊', style: Theme.of(context).textTheme.bodyMedium,),
                  const SizedBox(height: 25.0),

                  // --- ПОЛЕ EMAIL -----

                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // ---- ПОЛЕ ПАРОЛЬ -----

                  TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: passwordController,
                    decoration: InputDecoration(
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

                  TextButton(
                      onPressed: () async {

                        setState(() {
                          loading = true;
                        });

                        // Запоминаем значение введенных данных
                        String email = emailController.text;
                        String password = passwordController.text;

                        // Выполняем функцию входа
                        //String? uid = await authWithEmail.signInWithEmailAndPassword(email, password, context);

                        String? uid = await UserCustom.createUserWithEmailAndPassword(email, password);

                        if (uid != null) {

                          // ОБРАБОТКА ОШИБОК
                          // TODO Сделать функцию, которая возвращает текст для снакбара от кода ошибки
                          if (uid == 'wrong-password') {
                            setState(() {
                              loading = false;
                            });
                            updateShowRegButton(false);
                            updateForgotPasswordButton(true);
                            //showSnackBar('Упс! Пароль не верен( Давай попробуем еще раз – мы верим в твою память! 🔐🔄', AppColors.attentionRed, 5);
                          } else if (uid == 'user-not-found') {
                            setState(() {
                              loading = false;
                            });
                            updateShowRegButton(true);
                            updateForgotPasswordButton(false);
                            //showSnackBar('Упс! Похоже, такой Email не зарегистрирован. Может, опечатка? Попробуй еще раз или зарегистрируйcя! 📧🤔', AppColors.attentionRed, 5);
                          } else if (uid == 'too-many-requests') {
                            setState(() {
                              loading = false;
                            });
                            updateShowRegButton(false);
                            updateForgotPasswordButton(false);
                            //showSnackBar('Ой! Слишком много попыток. В целях безопасности мы заблокировали вход с твоего устройства. Попробуй позже! 🔒⏳', AppColors.attentionRed, 5);
                          } else if (uid == 'channel-error') {
                            setState(() {
                              loading = false;
                            });
                            updateShowRegButton(false);
                            updateForgotPasswordButton(false);
                            //showSnackBar('Что-то пропущено! Давайте вместе заполним недостающие поля, чтобы вы могли продолжить веселье.', AppColors.attentionRed, 5);
                          } else if (uid == 'invalid-email') {
                            setState(() {
                              loading = false;
                            });
                            updateShowRegButton(false);
                            updateForgotPasswordButton(false);
                            //showSnackBar('Ой, что-то с форматом Email пошло не так. Удостоверься, что вводишь его правильно, и давай еще раз! 📭🔄', AppColors.attentionRed, 5);
                          } else {
                            setState(() {
                              loading = false;
                            });
                            //showSnackBar('Пингвин вошел в холл. Повторяю, пингвин вошел в холл! Ваш вход успешен, герой. Приготовьтесь к веселью! 🐧🌟', Colors.green, 2);
                            navigateToProfile();
                          }

                        } else {

                          setState(() {
                            loading = false;
                          });

                          //showSnackBar('Ой-ой! Технические шалости, наверное. Попробуй позже, мы над этим работаем!', AppColors.attentionRed, 2);

                        }
                      },
                      child: Text('Зарегистрироваться')
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}