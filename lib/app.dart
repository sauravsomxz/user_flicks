import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/theme/app_theme.dart';
import 'package:user_flicks/features/home/view/home_view.dart';
import 'package:user_flicks/features/home/view_model/user_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  static Future<void> init() async {
    const String env = String.fromEnvironment('env', defaultValue: 'dev');
    await dotenv.load(fileName: '.env.$env');
    AppConfig.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersViewModel>(create: (_) => UsersViewModel()),
      ],
      child: MaterialApp(
        title: 'UserFlix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: HomeView(),
      ),
    );
  }
}
