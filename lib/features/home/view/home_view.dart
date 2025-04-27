import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/external/cached_image.dart';
import 'package:user_flicks/features/home/view_model/home_view_model.dart';
import 'package:user_flicks/widgets/edge_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Provider.of<UsersViewModel>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final UsersViewModel usersViewModel = Provider.of<UsersViewModel>(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Users"),
          centerTitle: false,
          backgroundColor: AppColors.primary,
        ),
        body:
            usersViewModel.isLoading
                ? EdgeState(
                  message: "Hold tight, building your squad... 👥",
                  showLoader: true,
                )
                : usersViewModel.hasError
                ? EdgeState(
                  message:
                      "Something went wrong... but don't worry, it's not you! 😔",
                  icon: Icons.error_outline,
                  iconColor: AppColors.error,
                )
                : usersViewModel.listOfUsers.isEmpty
                ? EdgeState(
                  message: "Your users will show up soon. Stay tuned! 📻",
                  icon: Icons.people_outline,
                  iconColor: AppColors.textSecondary,
                )
                : ListView.separated(
                  controller: usersViewModel.scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    final user = usersViewModel.listOfUsers[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedImage(
                                imageUrl: user.avatar,
                                height: 50,
                                width: 50,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemCount: usersViewModel.listOfUsers.length,
                ),
      ),
    );
  }
}
