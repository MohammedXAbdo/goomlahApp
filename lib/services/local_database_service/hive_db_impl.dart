import 'package:goomlah/services/local_database_service/local_db_repository.dart';
import 'package:hive/hive.dart';

class HiveDatabaseImpl extends LocalDatabaseRepository {
  @override
  Future<void> delete({String tableName, String key}) async {
    final box = await Hive.openBox(tableName ?? key);
    box.delete(key);
  }

  @override
  Future<dynamic> read({String tableName, String key}) async {
    final box = await Hive.openBox(tableName ?? key);
    if (key == null) {
      return box.keys.toList();
    }
    return box.get(key);
  }

  @override
  Future<void> write({String tableName, dynamic key, dynamic value}) async {
    final box = await Hive.openBox(tableName ?? key);

    box.put(key, value);
  }
}
