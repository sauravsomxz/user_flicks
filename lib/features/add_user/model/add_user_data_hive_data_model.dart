import 'package:hive/hive.dart';

part 'add_user_data_hive_data_model.g.dart';

@HiveType(typeId: 0)
class HiveUserModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String job;

  HiveUserModel({required this.name, required this.job});
}
