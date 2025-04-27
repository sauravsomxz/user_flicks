class AddUserRequest {
  final String name;
  final String job;

  AddUserRequest({required this.name, required this.job});

  factory AddUserRequest.fromJson(Map<String, dynamic> json) {
    return AddUserRequest(
      name: json['name'] as String,
      job: json['job'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'job': job};
  }
}
