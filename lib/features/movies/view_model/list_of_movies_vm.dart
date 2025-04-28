import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/movies/model/list_of_movies_data_model.dart';
import 'package:user_flicks/features/movies/repository/list_of_movies_repository.dart';

class ListOfMoviesVm extends ChangeNotifier {
  final ListOfMoviesRepository _listOfMoviesRepository =
      ListOfMoviesRepository();

  final ScrollController scrollController = ScrollController();

  final List<Movie> _listOfMovies = [];

  /// Indicates whether the initial API call is in progress.
  bool _isInitialLoading = false;

  /// Indicates whether a pagination API call (loading more data) is in progress.
  bool _isPaginating = false;

  bool _hasError = false;

  int _currentPage = 1;

  bool _hasMoreData = true;

  /// Constructor - attaches a listener to [scrollController]
  /// to automatically trigger pagination when user reaches the end.
  ListOfMoviesVm() {
    scrollController.addListener(_scrollListener);
  }

  /// Fetches the list of movies.
  ///
  /// If [isInitialLoad] is true, resets the list, page number, and flags.
  /// Otherwise, loads the next page and appends the new movies to the existing list.
  ///
  /// Notifies listeners after the fetch is complete.
  Future<void> fetchListOfMovies({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      _isInitialLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
      _listOfMovies.clear();
    } else {
      _isPaginating = true;
    }

    final response = await _listOfMoviesRepository.fetchListOfMovies(
      page: _currentPage,
    );

    if (response is Success<MovieResponse>) {
      final newMovies = response.data.results ?? [];

      if (newMovies.isEmpty) {
        _hasMoreData = false;
      } else {
        _listOfMovies.addAll(newMovies);
        _currentPage++;
      }

      _hasError = false;
    } else if (response is Failure<MovieResponse>) {
      _hasError = true;
    }

    _isInitialLoading = false;
    _isPaginating = false;
    notifyListeners();
  }

  /// Listener attached to [scrollController].
  ///
  /// Triggers a fetch for the next page when the user
  /// scrolls near the bottom of the list.
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      if (!_isPaginating && _hasMoreData && !_hasError) {
        fetchListOfMovies();
      }
    }
  }

  /// Returns the current list of movies.
  List<Movie> get listOfMovies => _listOfMovies;

  /// Returns whether the initial loading state is active.
  bool get isInitialLoading => _isInitialLoading;

  /// Returns whether pagination (loading more data) is ongoing.
  bool get isPaginating => _isPaginating;

  /// Returns whether the last fetch operation resulted in an error.
  bool get hasError => _hasError;

  /// Returns whether more pages are available to fetch.
  bool get hasMoreData => _hasMoreData;

  @override
  void dispose() {
    /// Clean up the [ScrollController] and remove the listener
    /// to avoid memory leaks when the ViewModel is disposed.
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
