import 'package:user_flicks/features/home/model/user_data_model.dart';

class UserResponse {
  final List<UserModel> users;
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  UserResponse({
    required this.users,
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      users: List<UserModel>.from(
        json['data'].map((x) => UserModel.fromJson(x)),
      ),
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}
