import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_flicks/core/app_enums.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/external/connectivity_service.dart';
import 'package:user_flicks/external/local_user_storage_service.dart';
import 'package:user_flicks/features/add_user/model/add_user_data_hive_data_model.dart';
import 'package:user_flicks/features/add_user/model/add_user_response.dart';
import 'package:user_flicks/features/add_user/repository/add_user_repository.dart';
import 'package:user_flicks/features/home/model/user_data_model.dart';

class AddUserViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  final AddUserRepository _addUserRepository = AddUserRepository();
  final ConnectivityService _connectivityService = ConnectivityService();
  final LocalUserStorageService _localStorageService =
      LocalUserStorageService();

  UserAddStatus? _status;
  bool _isLoading = false;
  List<HiveUserModel> _unsyncedUsers = [];

  StreamSubscription? _connectivitySubscription;

  AddUserViewModel() {
    nameController.addListener(_onTextChanged);
    jobController.addListener(_onTextChanged);

    _init();
  }

  void _init() async {
    await _loadUnsyncedUsers();

    _connectivitySubscription = _connectivityService.onConnectionChange.listen((
      isConnected,
    ) {
      if (isConnected) {
        syncUnsyncedUsers();
      }
    });

    // Trigger initial sync once connectivity is confirmed
    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      await syncUnsyncedUsers();
    }
  }

  void _onTextChanged() {
    notifyListeners();
  }

  Future<void> _loadUnsyncedUsers() async {
    _unsyncedUsers = await _localStorageService.getUnsyncedUsers();
    notifyListeners();
  }

  Future<void> addUser() async {
    if (!isFormValid) return;

    _isLoading = true;
    notifyListeners();

    final String name = nameController.text;
    final String job = jobController.text;

    try {
      final isConnected = await _connectivityService.isConnected;

      if (!isConnected) {
        await _localStorageService.saveUserLocally(
          HiveUserModel(name: name, job: job),
        );
        _status = UserAddStatus.success;
        _loadUnsyncedUsers();
        return;
      }

      final response = await _addUserRepository.addUser(name: name, job: job);

      if (response is Success) {
        _status = UserAddStatus.success;
      } else {
        await _localStorageService.saveUserLocally(
          HiveUserModel(name: name, job: job),
        );
        _status = UserAddStatus.failure;
        _loadUnsyncedUsers();
      }
    } catch (_) {
      await _localStorageService.saveUserLocally(
        HiveUserModel(name: name, job: job),
      );
      _status = UserAddStatus.error;
      _loadUnsyncedUsers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncUnsyncedUsers() async {
    final isConnected = await _connectivityService.isConnected;

    if (!isConnected) return;

    final List<HiveUserModel> unsynced =
        await _localStorageService.getUnsyncedUsers();

    for (var user in unsynced) {
      final response = await _addUserRepository.addUser(
        name: user.name,
        job: user.job,
      );

      if (response is Success<AddUserResponse>) {
        await _localStorageService.removeUser(user);
        await _loadUnsyncedUsers();
      } else if (response is Failure<UserModel>) {}
    }
  }

  bool get isFormValid =>
      nameController.text.isNotEmpty && jobController.text.isNotEmpty;
  bool get isLoading => _isLoading;
  UserAddStatus? get status => _status;
  List<HiveUserModel> get unsyncedUsers => _unsyncedUsers;

  void resetStatus() {
    _status = null;
    nameController.clear();
    jobController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
