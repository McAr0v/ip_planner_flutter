import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/dark_theme.dart';
import 'package:ip_planner_flutter/navigation/custom_navigation.dart';
import 'package:ip_planner_flutter/screens/login_screen.dart';
import 'package:ip_planner_flutter/screens/registration_screen.dart';

import 'design/app_colors.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseAuth auth = FirebaseAuth.instance;

  var currentUser = auth.currentUser;

  if (currentUser != null)
  {
    //await local_user.UserCustom.readUserDataAndWriteCurrentUser(auth.currentUser!.uid);
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/

      home: currentUser != null ? const CustomNavContainer() : const LoginScreen(),
      theme: CustomTheme.darkTheme,
      routes: {
        '/Profile': (context) => const CustomNavContainer(initialTabIndex: 3,),
        '/orders': (context) => const CustomNavContainer(initialTabIndex: 0),
        '/tasks': (context) => const CustomNavContainer(initialTabIndex: 1),
        '/stat': (context) => const CustomNavContainer(initialTabIndex: 2),
        '/reg': (context) => const RegistrationScreen(),
        '/logIn': (context) => const LoginScreen(),
        //'/privacy_policy': (context) => const PrivacyPolicyPage(),
        //'/reset_password_page': (context) => const ResetPasswordPage(),
        //'/cities': (context) => const CitiesListScreen(),

        // Другие маршруты вашего приложения
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: const TextStyle(color: AppColors.yellowLight),),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                fontFamily: 'sf_custom',
                fontSize: 50.0,
                fontWeight: FontWeight.normal,
                height: 1
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
