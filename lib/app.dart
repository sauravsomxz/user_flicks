import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  static Future<void> init() async {
    const String env = String.fromEnvironment('env', defaultValue: 'dev');
    await dotenv.load(fileName: '.env.$env');
    AppConfig.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UserFlix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(),
    );
  }
}
