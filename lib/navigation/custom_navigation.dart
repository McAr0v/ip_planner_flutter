import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/navigation/bottom_bar_design.dart';
import 'package:ip_planner_flutter/screens/login_screen.dart';
import 'package:ip_planner_flutter/screens/order_screen.dart';
import 'package:ip_planner_flutter/screens/profile_screen.dart';
import 'package:ip_planner_flutter/screens/stat_screen.dart';
import 'package:ip_planner_flutter/screens/task_screen.dart';

// ---- ВСЯ НАВИГАЦИЯ ЗДЕСЬ! ----

class CustomNavContainer extends StatefulWidget {
  final int initialTabIndex;

  const CustomNavContainer({Key? key, this.initialTabIndex = 1})
      : super(key: key);

  @override
  CustomNavContainerState createState() => CustomNavContainerState();
}

class CustomNavContainerState extends State<CustomNavContainer>
    with SingleTickerProviderStateMixin {

  // Переменная, управляющая табами
  late TabController _tabController;

  // Названия табов
  final List<String> _tabTitles = ['Сделки', 'Задачи', 'Статистика', 'Профиль'];

  // --- ИНИЦИАЛИЗИРУЕМ СОСТОЯНИЕ -----
  @override
  void initState() {
    super.initState();

    // В зависимости от действий, меняем состояние контроллера табов
    _tabController =
        TabController(length: _tabTitles.length, vsync: this, initialIndex: widget.initialTabIndex);
  }

  // --- Сам виджет меню табов ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [

          //OrderScreen(),
          LoginScreen(),
          TaskScreen(),
          StatScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomBarDesign(
        onTabTapped: (index){
          setState(() {
            _tabController.index = index;
          });
        },
        tabController: _tabController,
      ),
    );
  }
}