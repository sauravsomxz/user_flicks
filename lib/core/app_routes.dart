import 'package:go_router/go_router.dart';
import 'package:user_flicks/features/home/view/home_view.dart';
import 'package:user_flicks/features/movies/view/movie_screen.dart';

/// The `AppRouter` class is responsible for setting up and managing
/// the app's routing configuration using the `GoRouter` package.
/// It uses the Singleton pattern to ensure that only one instance of
/// the router exists and is used throughout the app.
class AppRouter {
  // Singleton pattern to ensure only one instance of the router
  static final AppRouter _instance = AppRouter._();

  factory AppRouter() {
    return _instance;
  }

  AppRouter._();
  late final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      // Route for HomeView
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: Routes.movies,
        builder: (context, state) {
          return const MoviesView();
        },
      ),
    ],
  );
}

/// The `Routes` class holds all the named routes for the application.
/// This class centralizes the path strings, ensuring consistency
/// throughout the app and avoiding magic strings in the routing logic.
class Routes {
  /// The route path for the Home screen.
  static const String home = '/';

  /// The route path for the Movies screen.
  static const String movies = '/movies';
}
