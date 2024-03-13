import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';

import '../app_colors.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingText;

  const LoadingScreen({super.key, this.loadingText = 'Подожди чуть-чуть) Идет загрузка'});

  // ---- ВИДЖЕТ ЭКРАНА ЗАГРУЗКИ ----

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 15.0),
            TextCustom(
              text: loadingText,
            )
          ],
        ),
      ),
    );
  }
}