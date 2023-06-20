import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_textfield.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/custom_appbar.dart';
import '../constants/app_colors.dart';
import '../controllers/change_pin_controller.dart';

class ChangePin extends StatelessWidget {
  const ChangePin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(ChangePinController());
    return Scaffold(
      appBar: const CustomAppBar(title: "Update Profile"),
      body: Obx(() {
        return BackgroundWidget(
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 10),
                      Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                label: "Old Pin",
                                controller: controller.oldPinC,
                                hintText: "Old Pin",
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your old pin';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: "New Pin",
                                controller: controller.newPinC,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your new pin';
                                  } else if (value.length != 4) {
                                    return 'Pin should be 4 digits';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: "Confirm Pin",
                                controller: controller.confirmPinC,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter confirm pin';
                                  } else if (value.length != 4) {
                                    return 'Pin should be 4 digits';
                                  } else if (value != controller.newPinC.text) {
                                    return "Pins do not match";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                          height: 50,
                          width: width / 1.3,
                          child: AppButton(
                            label: "Change Pin",
                            onPressed: () {
                              controller.validate();
                            },
                            color: AppColors.primaryColor,
                            elevation: 2,
                            borderColor: AppColors.primaryWhite,
                          )),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
