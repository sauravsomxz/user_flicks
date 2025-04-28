import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/movies/model/list_of_movies_data_model.dart';
import 'package:user_flicks/features/movies/repository/list_of_movies_repository.dart';

class ListOfMoviesVm extends ChangeNotifier {
  final ListOfMoviesRepository _listOfMoviesRepository =
      ListOfMoviesRepository();

  List<Movie> _listOfMovies = [];
  bool _isLoading = false;
  bool _hasError = false;

  Future<void> fetchListOfMovies({int page = 1}) async {
    _isLoading = true;
    final response = await _listOfMoviesRepository.fetchListOfMovies();

    if (response is Success<MovieResponse>) {
      _listOfMovies = response.data.results ?? [];
      _hasError = false;
    } else if (response is Failure<MovieResponse>) {
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  List<Movie> get listOfMovies => _listOfMovies;
  bool get getIfLoading => _isLoading;
  bool get hasError => _hasError;
}
