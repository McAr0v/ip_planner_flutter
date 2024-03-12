import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Expanded(
        child: Center(
          child: Text(
            'Страница заказов',
            style: TextStyle(color: AppColors.brandColor),
          ),
        )
    );
  }
}