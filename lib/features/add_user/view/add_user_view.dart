import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_flicks/features/add_user/view_model/add_user_view_model.dart';
import 'package:user_flicks/widgets/custom_button.dart';
import 'package:user_flicks/widgets/custom_text_field.dart';

class AddUserView extends StatelessWidget {
  const AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddUserViewModel addUserViewModel = Provider.of<AddUserViewModel>(
      context,
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Add New User"),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
          child: Column(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              CustomTextField(
                label: 'Name',
                controller: addUserViewModel.nameController,
                keyboardType: TextInputType.text,
              ),
              Text("Job"),
              CustomTextField(
                label: 'Job',
                controller: addUserViewModel.jobController,
                keyboardType: TextInputType.text,
              ),
              Spacer(),
              CustomButton(
                title: 'Submit',
                isActive: addUserViewModel.isFormValid,
                onTap: () {
                  if (addUserViewModel.isFormValid) {
                    addUserViewModel.addUser();
                  }
                },
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
