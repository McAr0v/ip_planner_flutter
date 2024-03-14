import 'package:flutter/material.dart';
import 'package:ip_planner_flutter/navigation/bottom_bar_design.dart';
import 'package:ip_planner_flutter/screens/profile_screen.dart';
import 'package:ip_planner_flutter/screens/stat_screen.dart';
import 'package:ip_planner_flutter/screens/task_screen.dart';
import '../screens/order_screen.dart';

class CustomNavContainer extends StatefulWidget {
  final int initialTabIndex;

  const CustomNavContainer({super.key, this.initialTabIndex = 1});

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
          OrderScreen(),
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