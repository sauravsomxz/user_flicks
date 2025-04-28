import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/core/app_enums.dart';
import 'package:user_flicks/core/theme/colors.dart';
import 'package:user_flicks/features/add_user/view_model/add_user_view_model.dart';
import 'package:user_flicks/widgets/custom_bottomsheet.dart';
import 'package:user_flicks/widgets/custom_button.dart';
import 'package:user_flicks/widgets/custom_text_field.dart';

class AddUserView extends StatelessWidget {
  const AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Add New User"),
          centerTitle: false,
          elevation: 0,
        ),
        body: Consumer<AddUserViewModel>(
          builder: (context, addUserViewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (addUserViewModel.status != null &&
                  !addUserViewModel.isLoading) {
                _showResultBottomSheet(context, addUserViewModel.status!);
                if (addUserViewModel.status! == UserAddStatus.success) {
                  addUserViewModel.resetStatus();
                }
              }
            });

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ).copyWith(top: 12.0),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      CustomTextField(
                        hintText: 'Name',
                        controller: addUserViewModel.nameController,
                        keyboardType: TextInputType.text,
                        textInputType: TextInputAction.next,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Job",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      CustomTextField(
                        hintText: 'Job',
                        controller: addUserViewModel.jobController,
                        keyboardType: TextInputType.text,
                        textInputType: TextInputAction.done,
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Both fields must be filled to enable Submit button.",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomButton(
                        title: 'Submit',
                        isActive:
                            addUserViewModel.isFormValid &&
                            !addUserViewModel.isLoading,
                        onTap: () {
                          if (addUserViewModel.isFormValid) {
                            addUserViewModel.addUser();
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                if (addUserViewModel.isLoading)
                  Container(
                    color: AppColors.textPrimary.withValues(alpha: 0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showResultBottomSheet(BuildContext context, UserAddStatus status) {
    switch (status) {
      case UserAddStatus.success:
        CustomBottomSheet.show(
          context: context,
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          title: "User Added!",
          description: "The user was successfully created.",
          buttonText: "OK",
          onButtonTap: () {
            context.pop();
            context.pop();
          },
        );
        break;
      case UserAddStatus.failure:
        CustomBottomSheet.show(
          context: context,
          icon: Icons.error_outline,
          iconColor: AppColors.error,
          title: "Oops!",
          description: "Failed to add the user. Please try again.",
          buttonText: "Try Again",
          onButtonTap: () {
            context.pop();
          },
        );
        break;
      case UserAddStatus.error:
        CustomBottomSheet.show(
          context: context,
          icon: Icons.error_outline,
          iconColor: AppColors.error,
          title: "Error",
          description: "An unexpected error occurred.",
          buttonText: "Close",
          onButtonTap: () {
            context.pop();
          },
        );
        break;
    }
  }
}
