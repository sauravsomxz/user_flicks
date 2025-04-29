import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/network/api_client.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/movie_details_screen/model/movie_details_data_model.dart';

class MovieDetailsRepository {
  late final ApiClient _apiClient;

  MovieDetailsRepository() {
    _apiClient = ApiClient(baseUrl: AppConfig.moviesBaseUrl);
  }

  Future<NetworkResponse<MovieDetailsDataModel>> fetchMovieDetails({
    required String movieId,
  }) async {
    return await _apiClient.get(
      "/movie/$movieId",
      parser: (json) => MovieDetailsDataModel.fromJson(json),
      headers: {
        "Authorization": "Bearer ${AppConfig.moviesDBAPIKEY}",
        "accept": "application/json",
      },
    );
  }
}
