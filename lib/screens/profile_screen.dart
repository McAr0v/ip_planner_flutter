import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/buttons/button_state.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import 'package:ip_planner_flutter/screens/reset_password_page.dart';
import '../database/database_info_manager.dart';
import '../design/app_colors.dart';
import '../design/snackBars/custom_snack_bar.dart';
import '../user/user_custom.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();

}

class ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCustom currentUser = UserCustom.getEmptyUser();

  bool loading = true;

  @override
  void initState() {

    getInfoFromDb(auth.currentUser!.uid);

  }

  Future<void> getInfoFromDb(String uid) async {

    setState(() {
      loading = true;
    });
    if (DbInfoManager.currentUser.name != ''){
      currentUser = DbInfoManager.currentUser;
    } /*else {
      await DbInfoManager.getInfoFromDbAndUpdate(auth.currentUser!.uid);
      if (DbInfoManager.currentUser.name != ''){
        currentUser = DbInfoManager.currentUser;
      }
    }*/

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextCustom(text: '123',),
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
                  SizedBox(height: 50,),
                  CustomButton(
                      buttonText: 'Выйти',
                      onTapMethod: (){
                        UserCustom.signOut();

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