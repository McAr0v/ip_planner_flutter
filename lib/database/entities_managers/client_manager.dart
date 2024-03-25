import 'package:firebase_database/firebase_database.dart';

import '../../clients/client_class.dart';

class ClientManager{

  static List<ClientCustom> clientsList = [];

  static void updateClientList(DataSnapshot snapshot){

    clientsList.clear();

    for (var idFolder in snapshot.children){

      ClientCustom tempClient = ClientCustom.fromSnapshot(idFolder);
      if(tempClient.id != '') clientsList.add(tempClient);

    }
  }

  static void replaceChangedClientItem(ClientCustom client){
    for (int i = 0; i<clientsList.length; i++){
      if (clientsList[i].id == client.id){
        clientsList[i] = client;
      }
    }
  }

  static void removeFromClientList(String id){
    clientsList.removeWhere((element) => element.id == id);
  }

  static ClientCustom getClientFromList(String id){
    for (int i = 0; i<clientsList.length; i++){
      if (clientsList[i].id == id) return clientsList[i];
    }
    return ClientCustom.empty();
  }

}