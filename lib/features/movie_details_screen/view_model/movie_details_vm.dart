import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/movie_details_screen/model/movie_details_data_model.dart';
import 'package:user_flicks/features/movie_details_screen/repository/movie_details_repository.dart';

class MovieDetailsVm extends ChangeNotifier {
  final MovieDetailsRepository _movieDetailsRepository =
      MovieDetailsRepository();

  MovieDetailsDataModel? movieDetailsDataModel;
  bool _hasError = false;
  bool _isLoading = false;

  Future<void> getMovieDetails({required String movieId}) async {
    _isLoading = true;
    movieDetailsDataModel = null;
    final response = await _movieDetailsRepository.fetchMovieDetails(
      movieId: movieId,
    );

    if (response is Success<MovieDetailsDataModel>) {
      movieDetailsDataModel = response.data;
      _isLoading = false;
      _hasError = false;
    } else if (response is Failure<MovieDetailsDataModel>) {
      _isLoading = false;
      _hasError = true;
    }
    notifyListeners();
  }

  bool get getIfLoading => _isLoading;
  bool get getIfHasError => _hasError;
}
