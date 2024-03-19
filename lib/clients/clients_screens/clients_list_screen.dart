import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/clients/client_class.dart';
import 'package:ip_planner_flutter/clients/client_widgets/clients_widget.dart';
import 'package:ip_planner_flutter/clients/clients_screens/client_create_popup.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/design/app_colors.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../design/dialogs/dialog.dart';
import '../../design/snackBars/custom_snack_bar.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  ClientListScreenState createState() => ClientListScreenState();

}

class ClientListScreenState extends State<ClientListScreen> {

  bool loading = true;
  bool deleting = false;
  bool showSearchBar = false;

  TextEditingController searchController = TextEditingController();

  List<ClientCustom> list = [];

  @override
  void initState() {
    super.initState();
    initializeScreen();
  }

  Future<void> initializeScreen() async {

    setState(() {
      loading = true;
    });

    list = DbInfoManager.clientsList;

    setState(() {
      loading = false;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blackLight,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(text: 'Мои клиенты', textState: TextState.headlineSmall, color: AppColors.white,),
            ],
          ),
          actions: [

            IconButton(
              icon: const Icon(FontAwesomeIcons.searchengin, size: 18,),

              onPressed: () {
                  setState(() {

                    showSearchBar = !showSearchBar;

                    if (showSearchBar == false) {
                      searchController.text = '';
                      updateClientsListInSearch(searchController.text);
                    }

                  });
              },
            ),

            IconButton(

              icon: const Icon(Icons.add),

              // Переход на страницу создания города
              onPressed: () {
                _showCreateClientDialog(context: context);
              },
            ),



          ],
        ),
        body: Column(
          children: [

            if (showSearchBar) Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Поиск клиента по имени или телефону...',
                    ),
                    onChanged: (value) {
                      updateClientsListInSearch(value);
                    },
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      searchController.text = '';
                      updateClientsListInSearch(searchController.text);
                    });
                  },
                  child: const Card(
                    color: AppColors.yellowLight,
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(FontAwesomeIcons.x, size: 18, color: AppColors.black,),
                    ),
                  ),
                ),

              ],
            ),

            //TextCustom(text: list.length.toString()),

            if (loading) const LoadingScreen()
            else if (deleting) const LoadingScreen(loadingText: "Подождите, идет удаление",)
            else if (list.isNotEmpty) Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ClientWidget(
                        client: list[index],
                        onDelete: (){
                          deleteClient(list[index]);
                        },
                        onEdit: (){
                          _showCreateClientDialog(context: context, client: list[index]);
                        },
                      );
                    }
                ),
              )
              else const Center(
                  child: TextCustom(text: 'Клиентов еще нет',),
                )
          ],
        )
    );
  }

  Future<void> deleteClient(ClientCustom client) async {
    bool? confirmed = await exitDialog(context, "Вы действительно хотите удалить клиента? \n \n Вы не сможете восстановить данные" , 'Да', 'Нет', 'Удаление клиента');

    if (confirmed != null && confirmed){

      setState(() {
        deleting = true;
      });

      String result = await client.deleteFromDb(DbInfoManager.currentUser.uid);

      if (result == 'ok') {
        DbInfoManager.clientsList.removeWhere((element) => element.id == client.id);
        list.removeWhere((element) => element.id == client.id);

        showSnackBar('Удаление прошло успешно!', Colors.green, 2);

      } else {
        showSnackBar('Произошла ошибка удаления - $result', AppColors.attentionRed, 2);
      }

      setState(() {
        deleting = false;
      });

    }

  }

  // ---- Функция отображения диалога фильтра ----

  Future<void> _showCreateClientDialog({required BuildContext context, ClientCustom? client}) async {
    final results = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClientCreatePopup(client: client,); // Вызываем кастомный виджет для pop-up
      },
    );

    if (results != null) {

      setState(() {
        loading = true;
        list = DbInfoManager.clientsList;
        loading = false;
      });
    }
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateClientsListInSearch(String query) {
    setState(() {
      list = DbInfoManager.clientsList
          .where((client) =>
            client.name.toLowerCase().contains(query.toLowerCase()) ||
            client.phone.contains(query)) // Проверяем и имя, и номер телефона
          .toList();
    });
  }

}