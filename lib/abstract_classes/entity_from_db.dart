abstract class EntityFromDb{
  Future<String> publishToDb(String userId);
  Map<String, dynamic> generateEntityDataCode();
  Future<String> deleteFromDb(String userId);

}