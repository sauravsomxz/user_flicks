import 'package:flutter/material.dart';
import 'package:user_flicks/core/network/network_response.dart';
import 'package:user_flicks/features/home/model/user_data_model.dart';
import 'package:user_flicks/features/home/model/user_response.dart';
import 'package:user_flicks/features/home/repository/home_repository.dart';

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
    // Initializes the scroll controller and sets up the listener for pagination
    scrollController.addListener(_scrollListener);
  }

  /// Listens for scroll events to trigger pagination when the user scrolls halfway through the list.
  /// This method checks if the scroll position reaches half of the total scrollable area
  /// and calls `loadMoreUsers` to fetch additional data if not already loading and not on the last page.
  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    // Trigger pagination when halfway through the scroll
    if (currentScroll >= maxScroll / 2 && !isLoading && !isLastPage) {
      loadMoreUsers();
    }
  }

  /// Fetches users from the repository and handles pagination. This method is responsible for:
  /// - Making the initial request to fetch users
  /// - Handling loading, error, and last page states
  /// - Adding newly fetched users to the list
  /// - Triggering pagination if the list size is small or the scroll reaches halfway
  ///
  /// [page] parameter allows specifying which page to fetch (default is page 1).
  Future<void> fetchUsers({int page = 1}) async {
    if (page == 1) {
      isLoading = true;
      hasError = false;
      isLastPage = false;
    }

    // Fetch users from the repository
    final response = await _usersRepository.fetchUsers(page: page);

    // Check if the response is successful
    if (response is Success<UserResponse>) {
      if (response.data.users.isNotEmpty) {
        listOfUsers.addAll(response.data.users); // Add new users to the list
        if (currentPage >= response.data.totalPages) {
          isLastPage = true; // Mark as last page if there are no more pages
        }
      }
      hasError = false;
    } else if (response is Failure<UserResponse>) {
      hasError = true; // Handle failure in fetching data
    }

    isLoading = false;
    currentPage = page; // Update the current page
    notifyListeners(); // Notify listeners about data changes

    // If the list has 6 or fewer items, automatically load more users
    if (listOfUsers.length <= 6 && !isLoading && !isLastPage) {
      loadMoreUsers();
    }
  }

  /// Loads more users by fetching the next page from the repository.
  /// This method ensures that pagination happens only if the app is not loading data
  /// and there are more pages available (i.e., not the last page).
  void loadMoreUsers() {
    if (!isLoading && !isLastPage) {
      currentPage++; // Increment current page
      fetchUsers(page: currentPage); // Fetch the next page
    }
  }

  /// Handles automatic pagination based on screen height.
  /// If the screen height changes (for example, when a device's screen orientation changes),
  /// this method checks if the list has fewer than 6 items and fetches the next page if necessary.
  /// This ensures that when there's less data, the app automatically loads more users.
  void updateScreenHeight(double height) {
    screenHeight = height;
    // Trigger fetching next page if the screen height is valid and the list is small
    if (screenHeight > 0.0 && listOfUsers.length <= 6) {
      fetchUsers(page: currentPage + 1); // Automatically fetch the next page
    }
  }

  /// Disposes of the scroll controller when it is no longer needed.
  /// This prevents memory leaks by removing the listener and disposing of the controller.
  @override
  void dispose() {
    scrollController.removeListener(
      _scrollListener,
    ); // Remove the scroll listener
    scrollController.dispose(); // Dispose of the scroll controller
    super.dispose(); // Call the superclass dispose method
  }
}
