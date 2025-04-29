import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/external/connectivity_service.dart';
import 'package:user_flicks/external/local_user_storage_service.dart';
import 'package:user_flicks/features/add_user/repository/add_user_repository.dart';
import 'package:workmanager/workmanager.dart';

const String userAutoSyncTask = "userAutoSyncTask";

class BackgroundSyncManager {
  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kReleaseMode ? false : true,
    );
  }

  static registerUserSyncTask() async {
    Workmanager().registerOneOffTask(
      userAutoSyncTask,
      userAutoSyncTask,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
}

// This runs in a separate isolate!
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == userAutoSyncTask) {
      final connectivityService = ConnectivityService();
      final isConnected = await connectivityService.isConnected;

      if (isConnected) {
        final localUserStorageService = LocalUserStorageService();
        final addUserRepository = AddUserRepository();

        final unsyncedUsers = await localUserStorageService.getUnsyncedUsers();

        for (var user in unsyncedUsers) {
          final result = await addUserRepository.addUser(
            name: user.name,
            job: user.job,
          );

          if (result is Success) {
            await localUserStorageService.removeUser(user);
          }
        }
      }
    }

    return Future.value(true);
  });
}
