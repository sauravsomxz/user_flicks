import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/app_routes.dart';
import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/theme/app_theme.dart';
import 'package:user_flicks/features/add_user/view_model/add_user_view_model.dart';
import 'package:user_flicks/features/home/view_model/home_view_model.dart';
import 'package:user_flicks/features/movie_details_screen/view_model/movie_details_vm.dart';
import 'package:user_flicks/features/movies/view_model/list_of_movies_vm.dart';

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
        ChangeNotifierProvider<AddUserViewModel>(
          create: (_) => AddUserViewModel(),
        ),
        ChangeNotifierProvider<ListOfMoviesVm>(create: (_) => ListOfMoviesVm()),
        ChangeNotifierProvider<MovieDetailsVm>(create: (_) => MovieDetailsVm()),
      ],
      child: MaterialApp.router(
        title: 'UserFlix',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
