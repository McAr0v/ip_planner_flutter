import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../design/app_colors.dart';
import '../design/images/image_in_edit_screen.dart';
import '../design/snackBars/custom_snack_bar.dart';
import '../image_picker/image_picker_service.dart';
import '../image_picker/image_uploader.dart';
import '../user/user_custom.dart';

class FirstProfileInputScreen extends StatefulWidget {

  final String name;
  final String email;
  final String uid;

  const FirstProfileInputScreen({
    required this.name,
    required this.email,
    required this.uid,
    super.key,
  });


  @override
  FirstProfileInputScreenState createState() => FirstProfileInputScreenState();

}

class FirstProfileInputScreenState extends State<FirstProfileInputScreen> {

  final ImagePickerService imagePickerService = ImagePickerService();
  final ImageUploader imageUploader = ImageUploader();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late TextEditingController imageController;

  bool loading = false;

  File? _imageFile;

  String defaultImage = 'https://firebasestorage.googleapis.com/v0/b/ipplanner-fdba7.appspot.com/o/avatar.png?alt=media&token=1a568db0-9462-404f-9d03-f9284ed9bc13';

  @override
  void initState() {

    if (widget.name != ""){
      nameController.text = widget.name;
    }

    imageController = TextEditingController(text: defaultImage);

    super.initState();
  }

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

                  // --- ЗАГОЛОВОК И ПОДПИСЬ

                  const SizedBox(height: 25.0),

                  const TextCustom(text: "Заполни профиль", textState: TextState.headlineBig, color: AppColors.yellowLight,),

                  const SizedBox(height: 15.0),

                  const TextCustom(text: "Давай дополним твой профиль дополнительной информацией", textState: TextState.bodyMedium),

                  const SizedBox(height: 25.0),

                  if (_imageFile != null) ImageInEditScreen(

                      backgroundImageFile: _imageFile,
                      onEditPressed: () => _pickImage()
                  )

                  else if (_imageFile == null) ImageInEditScreen(
                    onEditPressed: () => _pickImage(),
                    backgroundImageUrl: defaultImage,
                  ),

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
                      labelText: 'Имя',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Фамилия',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),

                  TextField(
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'sf_custom',
                      fontWeight: FontWeight.normal,
                    ),
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16.0),

                  // --- КНОПКА ВОЙТИ -----

                  CustomButton(
                      buttonText: "Сохранить",
                      onTapMethod: () async {
                        setState(() {
                          loading = true;
                        });

                        String name = nameController.text;
                        String lastName = lastNameController.text;
                        String phone = phoneController.text;

                        String? avatarUrl = "";

                        if (_imageFile != null){

                          final compressedImage = await imagePickerService.compressImage(_imageFile!);
                          avatarUrl = await ImageUploader.uploadImageInUser(widget.uid, compressedImage);

                        }

                        UserCustom userInfo = UserCustom(
                            uid: widget.uid,
                            email: widget.email,
                            name: name,
                            lastname: lastName,
                            phone: phone,
                            gender: '',
                            avatar: avatarUrl ?? defaultImage
                        );

                        String? result = await userInfo.publishToDb();

                        if (result == 'success') {

                          // Показываем всплывающее сообщение
                          showSnackBar(
                            "Прекрасно! Данные опубликованы!",
                            Colors.green,
                            1,
                          );

                          // Уходим в профиль
                          navigateToProfile();

                        } else {
                          // Показываем всплывающее сообщение
                          showSnackBar(
                            "Произошла ошибка(",
                            AppColors.attentionRed,
                            1,
                          );
                        }

                        setState(() {
                          loading = false;
                        });

                      }
                  ),
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
  // Функция показа всплывающего меню
  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage() async {
    final File? pickedImage = await imagePickerService.pickImage(ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
        imageController.text = _imageFile!.path;
      });
    }
  }

}