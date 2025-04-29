import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user_flicks/app.dart';
import 'package:user_flicks/features/add_user/model/add_user_data_hive_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserModelAdapter());
  await App.init();
  runApp(const App());
}
