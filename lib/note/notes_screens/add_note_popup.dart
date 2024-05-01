
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/database/entities_managers/deal_manager.dart';
import 'package:ip_planner_flutter/database/mixin_database.dart';
import 'package:ip_planner_flutter/deal/deal_class.dart';
import 'package:ip_planner_flutter/design/buttons/buttons_for_popup.dart';
import 'package:ip_planner_flutter/design/buttons/custom_button.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../design/app_colors.dart';
import '../../design/images/image_in_edit_screen.dart';
import '../../design/input_fields/input_field.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../../image_picker/image_picker_service.dart';
import '../../image_picker/image_uploader.dart';
import '../note_class.dart';

class AddNotePopup extends StatefulWidget {

  final Note? note;
  final String idEntity;

  const AddNotePopup({super.key, required this.note, required this.idEntity});

  @override
  AddNotePopupState createState() => AddNotePopupState();
}

class AddNotePopupState extends State<AddNotePopup> {

  final ImagePickerService imagePickerService = ImagePickerService();

  bool saving = false;

  late String id;
  late String image;

  File? _imageFile;

  late TextEditingController headlineController;
  late TextEditingController descController;

  DateTime createDate = DateTime.now();

  DealCustom deal = DealCustom.empty();

  @override
  void initState() {

    headlineController = TextEditingController();
    descController = TextEditingController();

    if (widget.note != null) {
      id = widget.note!.id;
      descController.text = widget.note!.desc;
      headlineController.text = widget.note!.headline;
      createDate = widget.note!.createDate;
      if (widget.idEntity.isNotEmpty){
        deal = DealManager.getDeal(widget.idEntity);
      }
      image = widget.note!.imageUrl;

    } else {
      id = MixinDatabase.generateKey()!;
      image = '';
    }

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black.withOpacity(0.6),
      body: Stack(
          children: [
            if (saving) const LoadingScreen(loadingText: 'Сохранение картинки в базе данных',)
            else if (!saving) Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.blackLight,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      const TextCustom(text: 'Заметка', textState: TextState.headlineSmall,),

                                      const SizedBox(height: 10,),

                                      TextCustom(
                                        //text: deal.headline.isNotEmpty ? 'Заметка для сделки ${DealManager.getDeal(widget.idEntity).headline}' : 'Заполните данные о заметке',
                                        text: 'Заполните данные о заметке',
                                        textState: TextState.labelMedium,
                                      ),

                                    ],
                                  )
                              )
                          ),


                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8.0),

                      SingleChildScrollView (
                        child: Container (
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.blackLight,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              InputField(
                                controller: headlineController,
                                label: 'Заголовок (Обязательно)',
                                textInputType: TextInputType.text,
                                active: true,
                                icon: Icons.text_decrease,
                                needButton: headlineController.text.isNotEmpty,
                                activateButton: headlineController.text.isNotEmpty,
                                onChanged: (value) {
                                  setState(() {
                                    headlineController.text = value;
                                  });
                                },
                                onButtonClick: (){
                                  setState(() {
                                    headlineController.text = '';
                                  });
                                },
                                iconForButton: FontAwesomeIcons.x,
                              ),

                              const SizedBox(height: 20.0),

                              InputField(
                                controller: descController,
                                label: 'Комментарий',
                                textInputType: TextInputType.multiline,
                                active: true,
                                icon: Icons.comment,
                                needButton: descController.text.isNotEmpty,
                                activateButton: descController.text.isNotEmpty,
                                onChanged: (value) {
                                  setState(() {
                                    descController.text = value;
                                  });
                                },
                                onButtonClick: (){
                                  setState(() {
                                    descController.text = '';
                                  });
                                },
                                maxLength: 100,
                                maxLines: null,
                                iconForButton: FontAwesomeIcons.x,
                              ),

                              const SizedBox(height: 20.0),

                              if (_imageFile == null && image.isEmpty) CustomButton(buttonText: 'Добавить картинку', onTapMethod: () => _pickImage())

                              else if (_imageFile != null) ImageInEditScreen(

                                  backgroundImageFile: _imageFile,
                                  onEditPressed: () => _pickImage()
                              )

                              else if (_imageFile == null && widget.note != null && image.isNotEmpty) ImageInEditScreen(
                                  onEditPressed: () => _pickImage(),
                                  backgroundImageUrl: widget.note!.imageUrl,
                                ),

                              const SizedBox(height: 20.0),

                              ButtonsForPopup(
                                  cancelText: 'Отменить',
                                  confirmText: 'Применить',
                                  onCancel: (){
                                    setState(() {
                                      // --- При отмене просто уходим, без аргументов
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onConfirm: () async {

                                    if (headlineController.text.isEmpty){
                                      showSnackBar('Заголовок должен быть обязательно заполнен', AppColors.attentionRed, 2);
                                    } else {

                                      setState(() {
                                        saving = true;
                                      });

                                      String? avatarURL;

                                      // ---- ЕСЛИ ВЫБРАНА НОВАЯ КАРТИНКА -------
                                      if (_imageFile != null) {

                                        // Сжимаем изображение
                                        final compressedImage = await imagePickerService.compressImage(_imageFile!);

                                        // Выгружаем изображение в БД и получаем URL картинки
                                        avatarURL = await ImageUploader.uploadImageInNote(DbInfoManager.currentUser.uid, id, compressedImage);


                                        // Если URL аватарки есть
                                        if (avatarURL != null) {
                                          image = avatarURL;
                                        } else {
                                          // TODO: Сделать обработку ошибок, если не удалось загрузить картинку в базу данных пользователя
                                        }
                                      }

                                      Note tempNote = Note(
                                          id: id,
                                          headline: headlineController.text,
                                          desc: descController.text,
                                          imageUrl: image,
                                          createDate: createDate,
                                          idEntity: widget.idEntity
                                      );

                                      setState(() {
                                        saving = false;
                                      });

                                      goWithResult(tempNote);
                                    }
                                  }
                              ),

                              const SizedBox(height: 10.0),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ]
      ),
    );
  }

  void goWithResult (Note tempNote){
    Navigator.of(context).pop(tempNote);
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _pickImage() async {
    final File? pickedImage = await imagePickerService.pickImage(ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

}