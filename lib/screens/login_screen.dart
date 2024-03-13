import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/screens/reset_password_page.dart';
import '../design/app_colors.dart';
import '../design/snackBars/custom_snack_bar.dart';
import '../user/user_custom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen> {

  // Переменная для перенаправления пользователя !! НЕ УДАЛЯТЬ !!!
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showForgotPasswordButton = false;
  bool showRegButton = true;
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
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const SizedBox(height: 25.0),

                  const TextCustom(text: "Вход", textState: TextState.headlineBig, color: AppColors.yellowLight,),

                  const SizedBox(height: 15.0),

                  const TextCustom(text: "Привет, дружище! Скучали по тебе! Входи в свой аккаунт и пользуйся возможностями приложения на здоровье! 🚀😊", textState: TextState.bodyMedium),

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

                        String? uid = await UserCustom.signInWithEmailAndPassword(email, password, context);

                        if (uid != null) {
                          _reactOnUid(uid);
                        }
                      }
                  ),

                  const SizedBox(height: 50,),

                  if (showForgotPasswordButton) const SizedBox(height: 50.0),

                  if (showForgotPasswordButton) const TextCustom(
                      text: 'Ой, пароль куда-то потерялся? Не переживай, мы тебя не бросим! Давай восстановим доступ в твой аккаунт 🚀🔓',
                      textState: TextState.bodyMedium,
                  ),

                  if (showForgotPasswordButton) const SizedBox(height: 20.0),

                  if (showForgotPasswordButton) CustomButton(
                    state: ButtonState.secondary,
                    buttonText: 'Восстановить доступ',
                    onTapMethod: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
                      );
                    },
                  ),

                  if (showRegButton) const TextCustom(text: "Нет аккаунта?", textState: TextState.headlineSmall, color: AppColors.yellowLight,),

                  if (showRegButton) const SizedBox(height: 15.0),

                  if (showRegButton && userNotFound) Text(
                      'Ой-ой! Нет пользователя с таким Email. Может нужно создать новый аккаунт? 📩🔍',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),

                  if (showRegButton && !userNotFound) const TextCustom(text: "Не беда! Присоединяйся к нам! Регистрируйся сейчас и открой для себя все преимущества нашего приложения. 🚀😊", textState: TextState.bodyMedium),

                  if (showRegButton) const SizedBox(height: 15.0),

                  if (showRegButton) CustomButton(
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
          ],
        )
    );
  }

  void navigateToProfile() {
    // Если пользователь не нал и подтвердил почту
    // Уходит на страницу профиля
    if (auth.currentUser != null && auth.currentUser!.emailVerified){
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Profile', // Название маршрута, которое вы задаете в MaterialApp
            (route) => false,
      );
      showSnackBar('Пингвин вошел в холл. Повторяю, пингвин вошел в холл! Ваш вход успешен, герой. Приготовьтесь к веселью! 🐧🌟', Colors.green, 2);
    } else {
      // Во всем остальном - переходит на страницу подтверждения почты
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/confirm_email', // Название маршрута, которое вы задаете в MaterialApp
            (route) => false,
      );
    }
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

  // Функция обновления состояния "Может нужна регистрация?"
  void updateShowRegButton(bool newValue) {
    setState(() {
      showRegButton = newValue;
    });
  }

  // Функция для смены состояния переменной показывающей / скрывающей пароль
  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _reactOnUid(String uid){

    if (uid == 'wrong-password') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateShowRegButton(false);
      updateForgotPasswordButton(true);
      showSnackBar('Упс! Пароль не верен( Давай попробуем еще раз – мы верим в твою память! 🔐🔄', AppColors.attentionRed, 2);

    } else if (uid == 'user-not-found') {

      setState(() {
        loading = false;
        userNotFound = true;
      });
      updateShowRegButton(true);
      updateForgotPasswordButton(false);
      showSnackBar('Упс! Похоже, такой Email не зарегистрирован. Может, опечатка? Попробуй еще раз или зарегистрируйcя! 📧🤔', AppColors.attentionRed, 2);

    } else if (uid == 'too-many-requests') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateShowRegButton(false);
      updateForgotPasswordButton(false);
      showSnackBar('Ой! Слишком много попыток. В целях безопасности мы заблокировали вход с твоего устройства. Попробуй позже! 🔒⏳', AppColors.attentionRed, 2);

    } else if (uid == 'channel-error') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateShowRegButton(false);
      updateForgotPasswordButton(false);
      showSnackBar('Что-то пропущено! Давайте вместе заполним недостающие поля, чтобы вы могли продолжить веселье.', AppColors.attentionRed, 2);

    } else if (uid == 'invalid-email') {

      setState(() {
        loading = false;
        userNotFound = false;
      });
      updateShowRegButton(false);
      updateForgotPasswordButton(false);
      showSnackBar('Ой, что-то с форматом Email пошло не так. Удостоверься, что вводишь его правильно, и давай еще раз! 📭🔄', AppColors.attentionRed, 2);

    } else {

      navigateToProfile();

      setState(() {
        loading = false;
        userNotFound = false;
      });

    }
  }

}