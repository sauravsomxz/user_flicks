import 'package:flutter/material.dart';
import 'package:user_flicks/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  runApp(const App());
}
