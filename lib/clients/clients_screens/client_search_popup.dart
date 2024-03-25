import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ip_planner_flutter/database/database_info_manager.dart';
import 'package:ip_planner_flutter/dates/date_mixin.dart';
import 'package:ip_planner_flutter/design/input_fields/input_field.dart';
import 'package:ip_planner_flutter/design/loading/loading_screen.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_custom.dart';
import 'package:ip_planner_flutter/design/text_widgets/text_state.dart';
import '../../database/entities_managers/client_manager.dart';
import '../../database/mixin_database.dart';
import '../../design/app_colors.dart';
import '../../design/snackBars/custom_snack_bar.dart';
import '../client_class.dart';
import '../client_widgets/clients_widget.dart';
import '../gender_class.dart';
import 'client_create_popup.dart';


class ClientSearchPopup extends StatefulWidget {

  const ClientSearchPopup({super.key});

  @override
  ClientSearchPopupState createState() => ClientSearchPopupState();
}

// -- Виджет отображения фильтра в мероприятиях ---

class ClientSearchPopupState extends State<ClientSearchPopup> {

  late bool loading;
  late bool saving;
  late bool edit;
  late bool showSearchBar;

  late ClientCustom chosenClient;
  int chosenClientId = -1;

  late List<ClientCustom> list;


  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initializeData();

  }

  Future<void> _initializeData() async {


    loading = true;
    saving = false;
    showSearchBar = false;

    chosenClient = ClientCustom.empty();
    list = ClientManager.clientsList;
    sortList(false);

    loading = false;
  }

  // ---- САМ ЭКРАН ФИЛЬТРА -----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.black.withOpacity(0.6),
        body: Stack(
          children: [
            if (loading) const LoadingScreen()
            else Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.blackLight,
                        borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                  child: Column (
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      TextCustom(text: "Поиск клиента", textState: TextState.headlineSmall,),
                                      const SizedBox(height: 10,),
                                      TextCustom(text: 'Выберите существующего клиента или создайте нового', textState: TextState.labelMedium, softWrap: true, maxLines: 2,),

                                    ],
                                  )
                              ),

                              IconButton(
                                icon: Icon(Icons.search, color: showSearchBar ? AppColors.yellowLight : AppColors.white,),

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
                                icon: const Icon(FontAwesomeIcons.plus, color: AppColors.white, size: 18,),

                                onPressed: () {
                                  _showCreateClientDialog(context: context);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),

                          if (showSearchBar) Container(
                            color: AppColors.blackLight,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: InputField(
                              controller: searchController,
                              label: 'Поиск по имени или телефону...',
                              textInputType: TextInputType.text,
                              active: true,
                              activateButton: searchController.text != '',
                              needButton: true,
                              onButtonClick: (){
                                setState(() {
                                  searchController.text = '';
                                  updateClientsListInSearch(searchController.text);
                                });
                              },
                              onChanged: (value) {
                                updateClientsListInSearch(value);
                              },
                              icon: Icons.search,
                              iconForButton: FontAwesomeIcons.x,
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          // ---- Содержимое фильтра -----

                          if (list.isNotEmpty) Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                itemCount: list.length,
                                itemBuilder: (context, index) {


                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        if (chosenClientId == index) {
                                          chosenClientId = -1;
                                          chosenClient = ClientCustom.empty();
                                        } else {
                                          chosenClientId = index;
                                          chosenClient = list[index];
                                        }

                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: chosenClientId == index ? AppColors.yellowLight : AppColors.black,
                                        borderRadius: BorderRadius.circular(15), // настройте радиус скругления углов для контейнера
                                      ),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(text: list[index].name, color: chosenClientId == index ? AppColors.black : AppColors.white,),
                                          SizedBox(height: 10,),
                                          TextCustom(text: list[index].phone, textState: TextState.labelMedium, color: chosenClientId == index ? AppColors.black : AppColors.white),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),

                          if (list.isEmpty) Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  const TextCustom(text: 'Пусто( Создать клиента?',),
                                  const SizedBox(height: 20,),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: AppColors.black,),
                                    onPressed: () {
                                      _showCreateClientDialog(context: context);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                            return Colors.green;
                                          },
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),

                          const SizedBox(height: 30.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              GestureDetector(
                                child: const TextCustom(text: 'Отменить', color: AppColors.attentionRed,),
                                onTap: (){Navigator.of(context).pop();},
                              ),

                              if (chosenClient.id != '') const SizedBox(width: 30.0),

                              if (chosenClient.id != '') GestureDetector(
                                child: const TextCustom(text: 'Применить', color: Colors.green,),
                                onTap: () async {

                                  setState(() {
                                    saving = true;
                                  });

                                  returnWithResult(chosenClient);

                                  setState(() {
                                    saving = false;
                                  });

                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 10.0),

                        ],
                      ),
                    ),
                  ),
                ],
              )
          ],
        )
    );
  }

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
        showSearchBar = false;
        searchController.text = '';
        chosenClient = results;
        list = ClientManager.clientsList;
        sortList(false);
        chosenClientId = getIndex(chosenClient);

        loading = false;
      });
    }
  }

  int getIndex(ClientCustom clientCustom){
    for (int i = 0; i < list.length; i++){
      if (clientCustom.id == list[i].id){
        return i;
      }
    }
    return -1;
  }

  void returnWithResult(ClientCustom client){
    Navigator.of(context).pop(client);
  }

  void sortList(bool sort){
    if (!sort) list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (sort) list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
  }

  void updateClientsListInSearch(String query) {
    setState(() {
      chosenClient = ClientCustom.empty();
      chosenClientId = -1;
      list = ClientManager.clientsList
          .where((client) =>
      client.name.toLowerCase().contains(query.toLowerCase()) ||
          client.phone.contains(query)) // Проверяем и имя, и номер телефона
          .toList();
    });
  }

  void showSnackBar(String message, Color color, int showTime) {
    final snackBar = customSnackBar(message: message, backgroundColor: color, showTime: showTime);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}