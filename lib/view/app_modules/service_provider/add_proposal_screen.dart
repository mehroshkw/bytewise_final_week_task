import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/controllers/service_provider_controller.dart';
import '../../../constants/app_colors.dart';
import '../../reusable_widgets/app_button.dart';
import '../../reusable_widgets/background_widget.dart';
import '../../reusable_widgets/custom_appbar.dart';
import '../../reusable_widgets/progress_indicator.dart';

class AddProposalScreen extends StatelessWidget {
  final String workId;
  final String clientEmail;
  final String workTitle;

  const AddProposalScreen(
      {Key? key,
      required this.workId,
      required this.clientEmail,
      required this.workTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(ServiceProviderController());

    return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.ADD_PROPOSAL),
        body: BackgroundWidget(
            child: controller.isLoading.value
                ? const Center(child: LoaderWidget())
                : SingleChildScrollView(
                    child: Column(children: [
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.time,
                              validator: (title) {
                                if (title!.isEmpty) {
                                  return AppStrings.ENTER_TIME;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: AppStrings.TIME_REQUIRED,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.rate,
                              validator: (price) {
                                if (price!.isEmpty) {
                                  return AppStrings.ENTER_RATE;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: AppStrings.WORK_RATE,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (desc) {
                                if (desc!.isEmpty) {
                                  return AppStrings.ENTER_MATERIAL;
                                } else {
                                  return null;
                                }
                              },
                              controller: controller.material,
                              maxLines: 5,
                              decoration: InputDecoration(
                                  hintText: AppStrings.MATERIAL,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryGreyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: size.width * 0.6,
                        child: AppButton(
                          label: AppStrings.UPLOAD,
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.uploadProposal(
                                workId: workId,
                                clientEmail: clientEmail,
                                workTitle: workTitle,
                              );
                            }
                          },
                          color: AppColors.primaryColor,
                          elevation: 2,
                          borderColor: AppColors.primaryWhite,
                        ))
                  ]))));
  }
}
