import 'package:hive/hive.dart';
import 'package:user_flicks/features/add_user/model/add_user_data_hive_data_model.dart';

class LocalUserStorageService {
  static const String _boxName = 'unsynced_users';

  Future<void> saveUserLocally(HiveUserModel user) async {
    final box = await Hive.openBox<HiveUserModel>(_boxName);
    await box.add(user);
  }

  Future<List<HiveUserModel>> getUnsyncedUsers() async {
    final box = await Hive.openBox<HiveUserModel>(_boxName);
    return box.values.toList();
  }

  Future<void> clearAllUsers() async {
    final box = await Hive.openBox<HiveUserModel>(_boxName);
    await box.clear();
  }

  Future<void> removeUserAt(int index) async {
    final box = await Hive.openBox<HiveUserModel>(_boxName);
    await box.deleteAt(index);
  }

  Future<void> removeUser(HiveUserModel user) async {
    final box = await Hive.openBox<HiveUserModel>(_boxName);
    final key = box.keys.firstWhere(
      (k) => box.get(k) == user,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }
}
