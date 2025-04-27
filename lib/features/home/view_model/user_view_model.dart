import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/home/model/user_data_model.dart';
import 'package:user_flicks/features/home/model/user_response.dart';
import 'package:user_flicks/features/home/repository/users_repository.dart';

class UsersViewModel extends ChangeNotifier {
  final UsersRepository _usersRepository = UsersRepository();

  List<UserModel> listOfUsers = [];
  bool isLoading = false;
  bool hasError = false;
  int currentPage = 1;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();

  double screenHeight = 0.0;

  UsersViewModel() {
    scrollController.addListener(_scrollListener);
  }

  /// Scroll listener to trigger pagination when reaching the bottom of the list.
  /// This is responsible for loading more users when the user scrolls near the end of the list.
  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent - 100) {
      loadMoreUsers();
    }
  }

  /// Fetch users from the repository and handle pagination.
  ///
  /// This method is responsible for making the API call to fetch users based on the current page.
  /// If it's the first page, the loading state is initialized and previous error states are cleared.
  /// It will also append new users to the list and check whether the last page is reached.
  Future<void> fetchUsers({int page = 1}) async {
    if (page == 1) {
      isLoading = true;
      hasError = false;
      isLastPage = false;
    }

    final response = await _usersRepository.fetchUsers(page: page);

    if (response is Success<UserResponse>) {
      if (response.data.users.isNotEmpty) {
        listOfUsers.addAll(response.data.users); // Add new users
        if (currentPage >= response.data.totalPages) {
          isLastPage = true; // Mark as last page if we reached the end
        }
      }
      hasError = false;
    } else if (response is Failure<UserResponse>) {
      hasError = true; // Handle failure case
    }

    isLoading = false;
    notifyListeners();
    _checkForAutoPagination(); // Check if the next page needs to be auto-fetched
  }

  /// Method to load more users when the user reaches the bottom of the list.
  ///
  /// This method is invoked when the user scrolls close to the bottom of the list.
  /// It triggers the loading of the next set of users if pagination is possible.
  void loadMoreUsers() {
    if (!isLoading && !isLastPage) {
      currentPage++;
      fetchUsers(page: currentPage); // Fetch the next page
    }
  }

  /// Auto-fetch the next page if necessary for large screens without scroll.
  ///
  /// This method automatically triggers the loading of the next page if certain conditions are met:
  /// - If the screen height is large (e.g., iPhone 16/Pro).
  /// - If there are fewer than 6 users currently loaded on the screen (indicating the screen isn't filled up).
  ///
  /// For devices with large screens, like iPhone 16 or iPhone Pro, this ensures that pagination works automatically,
  /// avoiding the need for user scrolling. This is useful when the available list of users doesn’t fill up the screen.
  ///
  /// On smaller devices (like iPhone SE), pagination will only be triggered when the user reaches the end of the list,
  /// ensuring that the loading of the next page is not triggered unnecessarily.
  void _checkForAutoPagination() {
    if (screenHeight > 0.0 && listOfUsers.length <= 6) {
      fetchUsers(
        page: currentPage + 1,
      ); // Fetch the next page automatically for larger screens
    }
  }

  /// Update screen height and check for auto-pagination.
  ///
  /// This method updates the screen height whenever the device's screen size changes (for example, if the app is rotated).
  /// If the screen height exceeds a threshold and there are fewer than 6 users in the list, it triggers auto-pagination
  /// to fetch the next set of users. This ensures a smooth user experience on larger screens.
  void updateScreenHeight(double height) {
    screenHeight = height;
    if (screenHeight > 0.0 && listOfUsers.length <= 6) {
      fetchUsers(
        page: currentPage + 1,
      ); // Automatically fetch the next page if necessary
    }
  }

  /// Dispose of the controller when no longer needed.
  ///
  /// This method removes the scroll listener and disposes of the `ScrollController` to avoid memory leaks
  /// when the `UsersViewModel` is no longer in use.
  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
