import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/screens/first_profile_input_screen.dart';
import '../design/app_colors.dart';
import '../design/snackBars/custom_snack_bar.dart';
import '../design/text_widgets/text_with_link.dart';
import '../user/user_custom.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();

}

class RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String defaultImage = 'https://firebasestorage.googleapis.com/v0/b/ipplanner-fdba7.appspot.com/o/avatar.png?alt=media&token=1a568db0-9462-404f-9d03-f9284ed9bc13';

  bool loading = false;
  bool showLogInButton = true;
  bool haveEmailInBd = false;
  bool privacyPolicyChecked = false;
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

                  const TextCustom(text: "Регистрация", textState: TextState.headlineBig, color: AppColors.yellowLight,),

                  const SizedBox(height: 15.0),

                  const TextCustom(text: "Спасибо, что присоединяешься к нам! Теперь ты часть нашей креативной семьи. Готовься к удивительным встречам и приключениям! 😊", textState: TextState.bodyMedium),

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
                      labelText: 'Как тебя зовут?',
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
                      labelText: 'Напиши свой Email',
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
                        labelText: 'Придумай пароль',
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
                  const SizedBox(height: 30.0),

                  // TODO Сделать функцию отрисовки чек-бокса

                  Row(
                    children: [
                      Checkbox(
                        value: privacyPolicyChecked,
                        onChanged: (value) {
                          togglePrivacyPolicyChecked();
                        },
                      ),
                      // ---- Надпись у чекбокса -----
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.75,
                        child: const TextWithLink(
                          linkedText: 'политики конфиденциальности',
                          uri: '/privacy_policy',
                          text: 'Галочку, пожалуйста! Подтвердите, что вы в курсе и согласны с правилами',
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 30.0),

                  // --- КНОПКА ВОЙТИ -----

                  CustomButton(
                      buttonText: "Зарегистрироваться",
                      onTapMethod: () async {
                        setState(() {
                          loading = true;
                        });

                        if (!privacyPolicyChecked){

                          showSnackBar('Это важно! Поставь галочку, что согласен ты с правилами политики конфиденциальности 🤨📜', AppColors.attentionRed, 2);

                          // Останавливаем регистрацию
                          setState(() {
                            loading = false;
                          });

                        } else {

                          String name = nameController.text;
                          String email = emailController.text;
                          String password = passwordController.text;

                          String? uid = await UserCustom.createUserWithEmailAndPassword(email, password);

                          if (uid != null){

                            reactOnUid(name, email, uid);

                          } else {

                            // Обработка случая, когда создание пользователя не удалось

                            showSnackBar(
                                "Что-то пошло не так при регистрации. Возможно, где-то ошибка. "
                                    "Пожалуйста, перепроверь данные и попробуй еще раз. "
                                    "Если проблема сохранится, сообщи нам!",
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

                  if (showLogInButton) const SizedBox(height: 50.0),

                  if (showLogInButton && !haveEmailInBd) const TextCustom(text: "Есть аккаунт?", textState: TextState.headlineSmall, color: AppColors.yellowLight,),

                  if (showLogInButton && haveEmailInBd) const TextCustom(text: "Так ты уже в системе?", textState: TextState.headlineSmall, color: AppColors.yellowLight,),

                  if (showLogInButton) const SizedBox(height: 15.0),

                  if (showLogInButton && haveEmailInBd) const TextCustom(
                      text: 'Опачки, кажется, твой кибер-двойник уже в сети! Может, пора вспомнить свой пароль и попробовать войти?',
                      textState: TextState.bodyMedium,
                  ),

                  if (showLogInButton && !haveEmailInBd) const TextCustom(
                    text: 'Если у тебя есть аккаунт, то ты можешь войти в него',
                    textState: TextState.bodyMedium,
                  ),

                  if (showLogInButton) const SizedBox(height: 20.0),

                  if (showLogInButton) CustomButton(
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

                  const SizedBox(height: 15.0),

                ],
              ),
            ),
          ],
        )
    );
  }

  void navigateToFirstInputScreen(String name, String email, String uid) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FirstProfileInputScreen(name: name, email: email, uid: uid)),
    );
  }

  // Функция показа всплывающего меню
  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateShowLogInButton(bool newValue) {
    setState(() {
      showLogInButton = newValue;
    });
  }

  void updateHaveEmailInBd(bool newValue) {
    setState(() {
      haveEmailInBd = newValue;
    });
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

      updateShowLogInButton(false);
      updateHaveEmailInBd(false);

      showSnackBar(
          "Твой текущий пароль - как стеклянное окно. Давай заменим его на стальные двери с кодовым замком!",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'email-already-in-use'){

      updateShowLogInButton(true);
      updateHaveEmailInBd(true);

      showSnackBar(
          "Вот это совпадение! Если это ты, дружище, давай вспомним, как заходить - твой аккаунт ждет!",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'channel-error'){

      updateShowLogInButton(false);
      updateHaveEmailInBd(false);

      showSnackBar(
          "Ой! Кажется, ты забыл важные детали. Пожалуйста, убедись, что ти ввел свой email и придумал надежный пароль, и тогда мы сможем тебя зарегистрировать!",
          AppColors.attentionRed,
          2
      );

    } else if (uid == 'invalid-email'){

      updateShowLogInButton(false);
      updateHaveEmailInBd(false);

      showSnackBar(
          "Ой, что-то с форматом Email пошло не так. Удостоверься, что вводишь его правильно, и давай еще раз! 📭🔄",
          AppColors.attentionRed,
          2
      );

    } else {

      UserCustom userInfo = UserCustom(
          uid: uid,
          email: email,
          name: name,
          lastname: "",
          phone: "",
          gender: '',
          avatar: defaultImage
      );

      await userInfo.publishToDb();

      navigateToFirstInputScreen(name, email, uid);

      setState(() {
        loading = false;
      });

    }
  }
}