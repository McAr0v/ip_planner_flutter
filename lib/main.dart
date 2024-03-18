import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/auth/auth_manager.dart';
import 'package:ip_planner_flutter/clients/clients_screens/clients_list_screen.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/design/dark_theme.dart';
import 'package:ip_planner_flutter/navigation/custom_navigation.dart';
import 'package:ip_planner_flutter/auth/auth_screens/login_screen.dart';
import 'package:ip_planner_flutter/screens/privacy_screen.dart';
import 'package:ip_planner_flutter/auth/auth_screens/registration_screen.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  var currentUser = AuthManager.auth.currentUser;

  if (currentUser != null)
  {
    await DbInfoManager.getInfoFromDbAndUpdate(currentUser.uid);

  }

  // Посмотреть в движе - это слушатель изменений при входе выходе пользователя
  /*runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );*/

  runApp(MyApp(currentUser));
}

class MyApp extends StatelessWidget {

  final User? currentUser;

  const MyApp(this.currentUser, {super.key});

  StatefulWidget _swapScreen(User? user){
    if (user == null) {
      return const LoginScreen();
    } else {
      return const CustomNavContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/

      home: _swapScreen(currentUser),
      theme: CustomTheme.darkTheme,
      routes: {
        '/Profile': (context) => const CustomNavContainer(initialTabIndex: 3,),
        '/orders': (context) => const CustomNavContainer(initialTabIndex: 0),
        '/tasks': (context) => const CustomNavContainer(initialTabIndex: 1),
        '/stat': (context) => const CustomNavContainer(initialTabIndex: 2),
        '/reg': (context) => const RegistrationScreen(),
        '/logIn': (context) => const LoginScreen(),
        '/privacy_policy': (context) => const PrivacyPolicyPage(),
        '/clients': (context) => const ClientListScreen(),

        // Другие маршруты вашего приложения
      },
    );
  }
}

