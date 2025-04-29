import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/app_routes.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/features/movies/view_model/list_of_movies_vm.dart';
import 'package:user_flicks/features/movies/widgets/movie_card.dart';
import 'package:user_flicks/widgets/edge_state.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<ListOfMoviesVm>(
      context,
      listen: false,
    ).fetchListOfMovies(isInitialLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Movies Listing Screen")),
        body: Consumer<ListOfMoviesVm>(
          builder:
              (context, vm, child) =>
                  vm.isInitialLoading
                      ? const EdgeState(
                        message:
                            "Hold tight, building your list of top picks! 🎬",
                        showLoader: true,
                      )
                      : vm.hasError && vm.listOfMovies.isEmpty
                      ? EdgeState(
                        message:
                            "Something went wrong... but don't worry, it's not you! 😔",
                        icon: Icons.error_outline,
                        iconColor: AppColors.error,
                        onPressed: () => vm.fetchListOfMovies(),
                      )
                      : vm.listOfMovies.isEmpty
                      ? EdgeState(
                        message:
                            "Your movies will show up soon. Stay tuned! 📻",
                        icon: Icons.hourglass_empty,
                        iconColor: AppColors.textSecondary,
                        onPressed: () => vm.fetchListOfMovies(),
                      )
                      : ListView.builder(
                        controller: vm.scrollController,
                        itemCount:
                            vm.listOfMovies.length + (vm.isPaginating ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < vm.listOfMovies.length) {
                            final movie = vm.listOfMovies[index];
                            return InkWell(
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                              onTap:
                                  () => context.pushNamed(
                                    Routes.movieDetailName,
                                    pathParameters: {"id": movie.id.toString()},
                                  ),
                              child: MovieCard(
                                moviePosterImage: movie.posterPath ?? "",
                                movieTitle: movie.title ?? "",
                                releaseDate: movie.releaseDate ?? "",
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                      ),
        ),
      ),
    );
  }
}
