import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/network/api_client.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/home/model/user_response.dart';

class UsersRepository {
  late final ApiClient _apiClient;

  UsersRepository() {
    _apiClient = ApiClient(baseUrl: AppConfig.usersBaseUrl);
  }

  Future<NetworkResponse<UserResponse>> fetchUsers({int page = 1}) async {
    return await _apiClient.get<UserResponse>(
      '/users?page=$page',
      parser: (json) => UserResponse.fromJson(json),
      headers: {"x-api-key": "reqres-free-v1"},
    );
  }
}
