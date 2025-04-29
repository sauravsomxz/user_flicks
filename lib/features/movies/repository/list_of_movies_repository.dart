import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/network/api_client.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/movies/model/list_of_movies_data_model.dart';

class ListOfMoviesRepository {
  late final ApiClient _apiClient;

  ListOfMoviesRepository() {
    _apiClient = ApiClient(baseUrl: AppConfig.moviesBaseUrl);
  }

  Future<NetworkResponse<MovieResponse>> fetchListOfMovies({
    int page = 1,
  }) async {
    return await _apiClient.get<MovieResponse>(
      "trending/movie/day?language=en-US&page=$page",
      parser: (json) => MovieResponse.fromJson(json),
      headers: {
        "Authorization": "Bearer ${AppConfig.moviesDBAPIKEY}",
        "accept": "application/json",
      },
    );
  }
}
