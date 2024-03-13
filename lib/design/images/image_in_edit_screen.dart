import 'package:flutter/material.dart';
import 'dart:io';

import '../buttons/custom_button.dart';

class ImageInEditScreen extends StatelessWidget {
  final String? backgroundImageUrl;
  final File? backgroundImageFile;
  final VoidCallback onEditPressed;

  const ImageInEditScreen({super.key, this.backgroundImageUrl, this.backgroundImageFile, required this.onEditPressed});

  // ---- ВИДЖЕТ ИЗОБРАЖЕНИЯ НА ЭКРАНАХ РЕДАКТИРОВАНИЯ -----

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth, // Ширина равна максимальной ширине
            height: constraints.maxWidth, // Фиксированная высота равная ширине
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [

                // ВЫБРАННОЕ ИЗ ГАЛЕРЕИ ФОТО

                if (backgroundImageFile != null)
                  Image.file(
                    backgroundImageFile!,
                    fit: BoxFit.cover,
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                  ),

                // ФОТО ЗАГРУЖЕННОЕ ИЗ БД

                if (backgroundImageUrl != null)
                  Ink.image(
                    image: NetworkImage(backgroundImageUrl!),
                    fit: BoxFit.cover,
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                  ),

                // КНОПКА РЕДАКТИРОВАТЬ ФОТО

                Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: CustomButton(
                        buttonText: 'Изменить фото',
                        onTapMethod: onEditPressed
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}