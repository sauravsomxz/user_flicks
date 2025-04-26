import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late final String usersBaseUrl;
  static late final String moviesBaseUrl;

  static void init() {
    usersBaseUrl = dotenv.env['USERS_BASE_URL'] ?? '';
    moviesBaseUrl = dotenv.env['MOVIES_BASE_URL'] ?? '';
  }
}
