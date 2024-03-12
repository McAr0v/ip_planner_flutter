import 'package:flutter/cupertino.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppColors.black,
      child: const Row(
        children: [
          Expanded(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Страница заказов',
                      style: TextStyle(
                          color: AppColors.yellowLight,
                          fontFamily: 'sf_custom',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Страница заказов',
                      style: TextStyle(
                          color: AppColors.yellowLight,
                          fontFamily: 'sf_custom',
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),

                    Text(
                      'Страница заказов',
                      style: TextStyle(
                          color: AppColors.yellowLight,
                          //fontFamily: 'sf_custom',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),

                    Text(
                      'Страница заказов',
                      style: TextStyle(
                          color: AppColors.yellowLight,
                          //fontFamily: 'sf_custom',
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              )
          ),
        ],
      ),
    );
  }
}