import 'dart:convert';

import 'package:user_flicks/core/config/app_config.dart';
import 'package:user_flicks/core/network/api_client.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/add_user/model/add_user_request_data_model.dart';
import 'package:user_flicks/features/add_user/model/add_user_response.dart';

class AddUserRepository {
  late final ApiClient _apiClient;

  AddUserRepository() {
    _apiClient = ApiClient(baseUrl: AppConfig.usersBaseUrl);
  }

  Future<NetworkResponse<AddUserResponse>> addUser({
    required String name,
    required String job,
  }) async {
    final AddUserRequest addUserRequest = AddUserRequest(name: name, job: job);

    return await _apiClient.post<AddUserResponse>(
      '/users',
      body: json.encode(addUserRequest.toJson()),
      parser: (json) => AddUserResponse.fromJson(json),
      headers: {
        "x-api-key": AppConfig.usersAPIKey,
        "Content-Type": "application/json",
      },
    );
  }
}
