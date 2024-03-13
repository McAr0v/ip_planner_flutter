// dark_theme.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class CustomTheme {

  // ---- ТЕМНАЯ ТЕМА ------
  static ThemeData get darkTheme {
    return ThemeData(
      // Всплывающее оповещение

        snackBarTheme: const SnackBarThemeData(
            backgroundColor: AppColors.yellowLight,
            actionTextColor: AppColors.white,
            contentTextStyle: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: 'SfProDisplay',
                fontWeight: FontWeight.w400,
                height: 1.1
            )
        ),

        dialogTheme: DialogTheme(
          surfaceTintColor: Colors.transparent,

        ),

        datePickerTheme: DatePickerThemeData(
            surfaceTintColor: Colors.transparent,
            /*dayForegroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return AppColors.greyOnBackground;
          },
        ),*/


            dayStyle: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: 'SfProDisplay',
                fontWeight: FontWeight.normal,
                height: 1.3
            ),


            weekdayStyle: const TextStyle(
                color: AppColors.greyLight,
                fontSize: 16,
                fontFamily: 'SfProDisplay',
                fontWeight: FontWeight.normal,
                height: 1.3
            ),

            backgroundColor: AppColors.black,

            /*todayBackgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return AppColors.white;
          },
        ),*/

            cancelButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
              padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
                    (Set<MaterialState> states) {
                  return const EdgeInsets.fromLTRB(20, 10, 0, 20);
                },
              ),
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                    (Set<MaterialState> states) {
                  return const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SfProDisplay',
                      fontWeight: FontWeight.normal,
                      height: 1.3
                  );
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.attentionRed;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (Set<MaterialState> states) {
                  return const BorderSide(
                    color: Colors.transparent, // Цвет границы
                    width: 0.0, // Толщина границы
                  );
                },
              ),
              minimumSize: MaterialStateProperty.resolveWith<Size?>(
                    (Set<MaterialState> states) {
                  return Size(0, 0); // Задайте минимальную ширину и высоту
                },
              ),
            ),
            confirmButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
              padding: MaterialStateProperty.resolveWith<EdgeInsets?>(
                    (Set<MaterialState> states) {
                  return const EdgeInsets.fromLTRB(20, 10, 20, 20);
                },
              ),
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                    (Set<MaterialState> states) {
                  return const TextStyle(
                      fontSize: 16,
                      fontFamily: 'SfProDisplay',
                      fontWeight: FontWeight.normal,
                      height: 1.3
                  );
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return Colors.green;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                    (Set<MaterialState> states) {
                  return const BorderSide(
                    color: Colors.transparent, // Цвет границы
                    width: 0.0, // Толщина границы
                  );
                },
              ),
              minimumSize: MaterialStateProperty.resolveWith<Size?>(
                    (Set<MaterialState> states) {
                  return Size(0, 0); // Задайте минимальную ширину и высоту
                },
              ),
            ),
            /*todayForegroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return AppColors.white;
          },
        ),*/
            todayBorder: BorderSide(style: BorderStyle.none)
        ),

        // Стиль кнопки

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(color: AppColors.white, fontSize: 16, fontFamily: 'SfProDisplay', fontWeight: FontWeight.normal),
            padding: const EdgeInsets.all(10.0),
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: AppColors.yellowLight,
            foregroundColor: AppColors.black,
            side: const BorderSide(color: AppColors.yellowLight, width: 2.0), // Добавлено границу кнопки
          ),

        ),

        // Верхняя панель

        appBarTheme: const AppBarTheme(
          // Настройка, чтобы при прокрутке не менялся цвет панели
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.black,
          titleTextStyle: TextStyle(color: AppColors.white, fontSize: 22, fontFamily: 'SfProDisplay', fontWeight: FontWeight.bold),

        ),


        // Панель табов (мои, избранные, лента)

        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(color: AppColors.yellowLight, fontSize: 16, fontFamily: 'sf_custom', fontWeight: FontWeight.normal),
          unselectedLabelStyle: TextStyle(color: AppColors.white, fontSize: 14, fontFamily: 'sf_custom', fontWeight: FontWeight.normal),
          indicatorColor: AppColors.yellowLight,
          indicatorSize: TabBarIndicatorSize.tab,

        ),

        primaryColor: AppColors.yellowLight,

        // Цвет фона по умолчанию
        scaffoldBackgroundColor: AppColors.black,



        // Поля ввода
        inputDecorationTheme: const InputDecorationTheme(

            labelStyle: TextStyle(
              color: AppColors.greyLight,
              fontSize: 14,
              fontFamily: 'sf_custom',
              fontWeight: FontWeight.normal,

            ),

            floatingLabelStyle: TextStyle(
              color: AppColors.greyLight,
              fontSize: 16,
              fontFamily: 'sf_custom',
              fontWeight: FontWeight.normal,

            ),

            hintStyle: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontFamily: 'sf_custom',
              fontWeight: FontWeight.normal,

            ),

            // иконка слева
            prefixIconColor: AppColors.greyLight,

            // фон поля ввода
            filled: true,
            fillColor: AppColors.blackLight,

            // цвет активных элементов
            focusColor: AppColors.yellowLight,

            // Активная граница
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.yellowLight, // Цвет границы
                width: 2.0, // Ширина границы
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)), // Радиус скругления углов
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.yellowLight, // Цвет границы
                width: 2.0, // Ширина границы
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)), // Радиус скругления углов
            ),

            activeIndicatorBorder: BorderSide(
              color: AppColors.yellowLight, // Цвет границы активного индикатора
              width: 2.0, // Ширина границы активного индикатора
            ),

            // Не активная граница
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.greyLight, // Цвет границы
                width: 2.0, // Ширина границы
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)), // Радиус скругления углов
            ),

            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.greyLight, // Цвет границы
                width: 2.0, // Ширина границы
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.0)), // Радиус скругления углов
            ),


        ),

        // Цветовая схема
        colorScheme: const ColorScheme.dark(
            primary: AppColors.yellowLight,
            secondary: AppColors.attentionRed,
            background: AppColors.black,
            onBackground: AppColors.blackLight,
            onPrimary: AppColors.black,
            onSurface: AppColors.white
        ),

        // Стиль кнопки
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          buttonColor: AppColors.yellowLight,
          textTheme: ButtonTextTheme.normal,

        ),

        // Стиль нижнего меню

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.black,
          selectedItemColor: AppColors.yellowLight,
          unselectedItemColor: AppColors.graphite,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontFamily: 'sf_custom',
            fontWeight: FontWeight.normal,
          ),
          selectedIconTheme: IconThemeData(
              size: 25
          ),
          unselectedIconTheme: IconThemeData(
              color: AppColors.graphite
          ),
        ),

        // Всплываюшая шторка
        drawerTheme: const DrawerThemeData(
            backgroundColor: AppColors.black
        ),

        // Для драйвера
        // Заголовок и иконка
        listTileTheme: const ListTileThemeData(
          textColor: AppColors.white,
          iconColor: AppColors.white,
          titleTextStyle: TextStyle(color: AppColors.white, fontSize: 16, fontFamily: 'SfProDisplay', fontWeight: FontWeight.normal),
        ),

        dialogBackgroundColor: AppColors.black


    );
  }

  // ---- СВЕТЛАЯ ТЕМА ------

  static ThemeData get lightTheme { //1
    return ThemeData( //2
      appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.yellowLight,
          titleTextStyle: TextStyle(color: AppColors.white)
      ),
      primaryColor: AppColors.yellowLight,
      scaffoldBackgroundColor: AppColors.black,
      textTheme: const TextTheme(
          displayLarge: TextStyle(color: AppColors.black, fontSize: 13),
          displayMedium: TextStyle(color: AppColors.black),
          displaySmall: TextStyle(color: AppColors.black)),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.yellowLight,
        secondary: AppColors.attentionRed,
        background: AppColors.white,
        onBackground: AppColors.black,
      ),
      // fontFamily: 'Montserrat', //3
      buttonTheme: ButtonThemeData( // 4
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: AppColors.yellowLight,
      ),
    );
  }

}

