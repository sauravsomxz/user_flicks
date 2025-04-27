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

  // Scroll listener triggers pagination when the user scrolls halfway through the list
  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    if (currentScroll >= maxScroll / 2 && !isLoading && !isLastPage) {
      loadMoreUsers();
    }
  }

  // Fetch users from the repository and handle pagination
  Future<void> fetchUsers({int page = 1}) async {
    if (page == 1) {
      isLoading = true;
      hasError = false;
      isLastPage = false;
    }

    final response = await _usersRepository.fetchUsers(page: page);

    if (response is Success<UserResponse>) {
      if (response.data.users.isNotEmpty) {
        listOfUsers.addAll(response.data.users);
        if (currentPage >= response.data.totalPages) {
          isLastPage = true; // Mark as last page if no more data
        }
      }
      hasError = false;
    } else if (response is Failure<UserResponse>) {
      hasError = true;
    }

    isLoading = false;
    currentPage = page;
    notifyListeners();

    // Auto-load more users if the list is small (6 items or less)
    if (listOfUsers.length <= 6 && !isLoading && !isLastPage) {
      loadMoreUsers();
    }
  }

  // Load more users for pagination when needed
  void loadMoreUsers() {
    if (!isLoading && !isLastPage) {
      currentPage++;
      fetchUsers(page: currentPage); // Fetch the next page
    }
  }

  // Check for auto-pagination when screen height changes
  void updateScreenHeight(double height) {
    screenHeight = height;
    if (screenHeight > 0.0 && listOfUsers.length <= 6) {
      fetchUsers(page: currentPage + 1); // Automatically fetch the next page
    }
  }

  // Dispose of the controller when no longer needed
  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
