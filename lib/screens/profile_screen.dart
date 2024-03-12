import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppColors.black,
      child: const Row(
        children: [
          Expanded(
              child: Center(
                child: Text(
                  'Страница профиля',
                  style: TextStyle(color: AppColors.yellowLight),
                ),
              )
          ),
        ],
      ),
    );
  }
}