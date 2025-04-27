import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/add_user/repository/add_user_repository.dart';

class AddUserViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final AddUserRepository _addUserRepository = AddUserRepository();

  AddUserViewModel() {
    nameController.addListener(_onTextChanged);
    jobController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  Future<void> addUser() async {
    if (isFormValid) {
      try {
        final String name = nameController.text;
        final String job = jobController.text;
        final response = await _addUserRepository.addUser(name: name, job: job);

        if (response is Success) {
          /// TODO: HANDLE SUCCESS
        } else if (response is Failure) {
          /// TODO: Handle error state
        }
      } catch (e) {
        //// HANDLE TRY
      }
    }
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty && jobController.text.isNotEmpty;
  }
}
