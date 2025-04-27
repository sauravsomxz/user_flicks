class AddUserResponse {
  final String name;
  final String job;
  final String id;
  final String createdAt;

  AddUserResponse({
    required this.name,
    required this.job,
    required this.id,
    required this.createdAt,
  });

  factory AddUserResponse.fromJson(Map<String, dynamic> json) {
    return AddUserResponse(
      name: json['name'] as String,
      job: json['job'] as String,
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'job': job, 'id': id, 'createdAt': createdAt};
  }
}
