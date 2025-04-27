import 'package:flutter/material.dart';
import 'package:user_flicks/core/app_enums.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/add_user/repository/add_user_repository.dart';

class AddUserViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final AddUserRepository _addUserRepository = AddUserRepository();

  UserAddStatus? _status;
  bool _isLoading = false;

  AddUserViewModel() {
    nameController.addListener(_onTextChanged);
    jobController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  Future<void> addUser() async {
    if (isFormValid) {
      _isLoading = true;
      notifyListeners();

      try {
        final String name = nameController.text;
        final String job = jobController.text;
        final response = await _addUserRepository.addUser(name: name, job: job);

        if (response is Success) {
          _status = UserAddStatus.success;
        } else if (response is Failure) {
          _status = UserAddStatus.failure;
        }
      } catch (e) {
        _status = UserAddStatus.error;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty && jobController.text.isNotEmpty;
  }

  bool get isLoading => _isLoading;
  UserAddStatus? get status => _status;

  void resetStatus() {
    _status = null;
    nameController.clear();
    jobController.clear();
    notifyListeners();
  }
}
