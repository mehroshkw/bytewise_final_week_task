import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_services_app/constants/app_images.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/controllers/update_profile_controller.dart';
import '../constants/app_colors.dart';
import 'reusable_widgets/app_button.dart';
import 'reusable_widgets/app_textfield.dart';
import 'reusable_widgets/background_widget.dart';
import 'reusable_widgets/custom_appbar.dart';

class ClientUpdateProfile extends StatelessWidget {
  const ClientUpdateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final controller = Get.put(UpdateProfileController());
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.UPDATE_PROFILE),
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
                        height: 20
                      ),

                      /// -- IMAGE
                      GetX<UpdateProfileController>(builder: (state) {
                        ImageProvider image;
                        final imgPath = state.selectedImage.value;
                        if (imgPath.path.isNotEmpty) {
                          image = FileImage(File(imgPath.path));
                        } else {
                          if (state.imageUrl.isNotEmpty) {
                            image = CachedNetworkImageProvider(state.imageUrl);
                          } else {
                            image = const AssetImage(AppImages.APP_LOGO);
                          }
                        }
                        return Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Image(image: image, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.primaryColor,
                                ),
                                child: IconButton(
                                  color: AppColors.primaryGreyColor,
                                  onPressed: () async {
                                    final selectedImagePath =
                                        await state.pickImage();
                                    if (selectedImagePath != null) {
                                      state.selectedImage.value =
                                          XFile(selectedImagePath);
                                    }
                                  },
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 10),
                      Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                label: AppStrings.FULL_NAME,
                                controller: controller.nameC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_NAME;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: AppStrings.CNIC,
                                // maxLength: 13,
                                controller: controller.cnicC,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_CNIC;
                                  } else if (value.length > 13 ||
                                      value.length < 13) {
                                    return AppStrings.ENTER_VALID_CNIC;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: AppStrings.ADDRESS,
                                controller: controller.addressC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_ADDRESS;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: AppStrings.CITY,
                                controller: controller.cityC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_CITY;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: AppStrings.COUNTRY,
                                controller: controller.countryC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_COUNTRY;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                label: AppStrings.PHONE,
                                controller: controller.phnC,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_PHONE;
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
                            label: AppStrings.UPDATE,
                            onPressed: () => controller.validate(),
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
