import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/auth/auth_manager.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import '../database/database_info_manager.dart';
import '../user/user_custom.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();

}

class ProfileScreenState extends State<ProfileScreen> {

  UserCustom currentUser = UserCustom.empty();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    currentUser = DbInfoManager.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextCustom(text: '123',),
      ),
      body: SingleChildScrollView(
        child: Stack (
          children: [
            if (loading) const LoadingScreen()

            else Center(
              child: Column(
                children: [
                  TextCustom(text: currentUser.uid),
                  TextCustom(text: currentUser.name),
                  TextCustom(text: currentUser.email),
                  const SizedBox(height: 50,),
                  CustomButton(
                      buttonText: 'Выйти',
                      onTapMethod: (){
                        AuthManager.signOut();

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
          ],
        ),
      ),
    );
  }
}