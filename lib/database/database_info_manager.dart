import 'package:firebase_database/firebase_database.dart';
import '../user/user_custom.dart';
import 'mixin_database.dart';

class DbInfoManager {

  static UserCustom currentUser = UserCustom.empty();

  static Future<void> getInfoFromDbAndUpdate(String uid) async {

    DataSnapshot? dbSnapshot = await MixinDatabase.getInfoFromDB(uid);

    if (dbSnapshot != null){

      currentUser = UserCustom.fromSnapshot(dbSnapshot.child('user_info'));

    }

  }

  static void clearAllInfoInManager() {
    currentUser = UserCustom.empty();
  }


}