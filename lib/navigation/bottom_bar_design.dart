import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBarDesign extends StatelessWidget {
  final TabController tabController;
  final void Function(int) onTabTapped;

  const BottomBarDesign({super.key,
    required this.tabController,
    required this.onTabTapped,
  });

  // --- ВИДЖЕТ ОТОБРАЖЕНИЯ НИЖНЕГО ТАБ МЕНЮ -----

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      currentIndex: tabController.index,
      onTap: onTabTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.clipboardList),
          label: 'Сделки',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Задачи',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Статистика',
          backgroundColor: Colors.black,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
          backgroundColor: Colors.black,
        ),
      ],
    );
  }
}

