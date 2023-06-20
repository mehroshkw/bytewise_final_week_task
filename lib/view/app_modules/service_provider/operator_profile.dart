import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/controllers/profile_controller.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../change_pin.dart';
import '../../reusable_widgets/custom_appbar.dart';
import '../../update_profile.dart';

class OperatorProfile extends StatelessWidget {
  const OperatorProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.OPERATOR_PROFILE),
        body: Obx(() {
          return BackgroundWidget(
              child: controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(children: [
                            /// -- IMAGE
                            Stack(children: [
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
                                              )),
                                          child: CachedNetworkImage(
                                            imageUrl: controller.imageUrl.value,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ))))
                            ]),
                            const SizedBox(height: 10),
                            ListTile(
                                title: Text("Name: ${controller.name.value}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(color: AppColors.primaryColor),
                            ListTile(
                                title: Text("Email: ${controller.email}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(color: AppColors.primaryColor),
                            ListTile(
                                title: Text(
                                    "Address: ${controller.address.value}, ${controller.city.value}, ${controller.country.value}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(
                              color: AppColors.primaryColor,
                            ),
                            ListTile(
                                title: Text("CNIC: ${controller.cnic.value}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(
                              color: AppColors.primaryColor,
                            ),
                            ListTile(
                                title: Text("Phone: ${controller.phone.value}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(
                              color: AppColors.primaryColor,
                            ),
                            ListTile(
                                title: Text("User Role: ${controller.userRole}",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor))),
                            const Divider(
                              color: AppColors.primaryColor,
                            ),

                            const SizedBox(height: 20),

                            /// -- BUTTON
                            Row(children: [
                              SizedBox(
                                  height: 40,
                                  width: size.width / 2.3,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        final result = await Get.to<bool>(
                                            const ClientUpdateProfile());
                                        if (result == true) {
                                          controller.getUser();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          side: BorderSide.none,
                                          shape: const StadiumBorder()),
                                      child: const Text(AppStrings.EDIT_PROFILE,
                                          style: TextStyle(
                                              color: AppColors.primaryWhite)))),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                  height: 40,
                                  width: size.width / 2.3,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(const ChangePin());
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          side: BorderSide.none,
                                          shape: const StadiumBorder()),
                                      child: const Text(
                                        AppStrings.CHANGE_PIN,
                                        style: TextStyle(
                                            color: AppColors.primaryWhite),
                                      )))
                            ]),
                            const SizedBox(height: 20),
                          ]))));
        }));
  }
}
