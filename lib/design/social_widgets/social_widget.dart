import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../links/open_url_class.dart';
import '../../links/url_path_enum.dart';
import '../app_colors.dart';

class SocialWidget extends StatelessWidget {
  final String phone;
  final String telegram;
  final String instagram;
  final String whatsapp;

  const SocialWidget({
    super.key,
    this.whatsapp = '',
    this.telegram = '',
    this.instagram = '',
    this.phone = ''
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (phone.isNotEmpty) IconButton(
          onPressed: () => OpenUrlClass.openUrl(phone, UrlPathEnum.phone),
          icon: const Icon(FontAwesomeIcons.phone, size: 18,),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.call;
                },
              )
          ),
        ),

        if (phone.isNotEmpty) const SizedBox(width: 10,),

        if (instagram.isNotEmpty) IconButton(
          onPressed: () => OpenUrlClass.openUrl(instagram, UrlPathEnum.instagram),
          icon: const Icon(FontAwesomeIcons.instagram),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.instagram;
                },
              )
          ),
        ),

        if (instagram.isNotEmpty) const SizedBox(width: 10,),

        if (telegram.isNotEmpty) IconButton(
          onPressed: () => OpenUrlClass.openUrl(telegram, UrlPathEnum.telegram),
          icon: const Icon(FontAwesomeIcons.telegram),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.telegram;
                },
              )
          ),
        ),

        if (telegram.isNotEmpty) const SizedBox(width: 10,),

        if (whatsapp.isNotEmpty) IconButton(
          onPressed: () => OpenUrlClass.openUrl(whatsapp, UrlPathEnum.whatsapp),
          icon: const Icon(FontAwesomeIcons.whatsapp),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return AppColors.whatsapp;
                },
              )
          ),
        ),
      ],
    );
  }
}