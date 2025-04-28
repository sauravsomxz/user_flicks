import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Provider.of<ListOfMoviesVm>(context, listen: false).fetchListOfMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movies Listing Screen")),
      body: Consumer<ListOfMoviesVm>(
        builder: (BuildContext context, ListOfMoviesVm value, Widget? child) {
          return value.getIfLoading
              ? EdgeState(
                message: "Hold tight, building your list of top picks! 🎬",
                showLoader: true,
              )
              : value.hasError
              ? EdgeState(
                message:
                    "Something went wrong... but don't worry, it's not you! 😔",
                icon: Icons.error_outline,
                iconColor: AppColors.error,
              )
              : value.listOfMovies.isEmpty
              ? EdgeState(
                message: "Your movies will show up soon. Stay tuned! 📻",
                icon: Icons.hourglass_empty,
                iconColor: AppColors.textSecondary,
              )
              : ListView.builder(
                itemCount: value.listOfMovies.length,
                itemBuilder: (context, index) {
                  final movie = value.listOfMovies[index];
                  return MovieCard(
                    moviePosterImage: movie.posterPath ?? "",
                    movieTitle: movie.title ?? "",
                    releaseDate: movie.releaseDate ?? "",
                  );
                },
              );
        },
      ),
    );
  }
}
