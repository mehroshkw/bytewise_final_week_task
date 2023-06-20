import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_images.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../reusable_widgets/app_button.dart';
import '../../reusable_widgets/app_textfield.dart';
import '../../reusable_widgets/background_widget.dart';
import '../../reusable_widgets/custom_appbar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController pinC = TextEditingController();
  final TextEditingController cnicC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController cityC = TextEditingController();
  final TextEditingController countryC = TextEditingController();
  final TextEditingController phnC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authController = Get.put(AuthController());
  int _groupValue = 0;
  bool isLoading = false;
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.registerUser(
          email: emailC.text.trim(),
          name: nameC.text,
          pin: pinC.text.trim(),
          cnic: cnicC.text,
          address: addressC.text,
          city: cityC.text,
          country: countryC.text,
          phone: phnC.text,
          groupValue: _groupValue,
        imageFile: authController.selectedImage.value
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:const CustomAppBar(title: AppStrings.CREATE_ACCOUNT),
      body: Obx(() {
        return BackgroundWidget(

          child: authController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      GetX<AuthController>(builder: (state) {
                        ImageProvider image;
                        final imgPath = state.selectedImage.value.path;

                        if (imgPath.isNotEmpty) {
                          image = FileImage(File(imgPath));
                        } else {
                          image = const AssetImage(AppImages.APP_LOGO);
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
                                  child: (imgPath.isNotEmpty)
                                      ? Image(image: image, fit: BoxFit.cover)
                                      : Image(image: image),
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
                                    final selectedImagePath = await state.pickImage();
                                    if (selectedImagePath != null) {
                                      state.selectedImage.value = selectedImagePath;
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
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: nameC,
                                label: AppStrings.FULL_NAME,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_NAME;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: emailC,
                                label: AppStrings.EMAIL,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_EMAIL;
                                  } else if (!value.contains("@") ||
                                      !value.contains(".com")) {
                                    return AppStrings.ENTER_VALID_EMAIL;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: pinC,
                                label: AppStrings.SET_PIN,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_VALID_PIN;
                                    // } else if (value.length>4 ||value.length <4) {
                                  } else if (value.length < 4 ||
                                      value.length > 4) {
                                    return AppStrings.ENTER_VALID_PIN;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                maxLength: 13,
                                controller: cnicC,
                                label: AppStrings.CNIC,
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
                                controller: addressC,
                                label: AppStrings.ADDRESS,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_ADDRESS;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: cityC,
                                label: AppStrings.CITY,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_CITY;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: countryC,
                                label: AppStrings.COUNTRY,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_COUNTRY;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: phnC,
                                label: AppStrings.PHONE,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.ENTER_PHONE;
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: RadioListTile(
                                      value: 0,
                                      groupValue: _groupValue,
                                      title: const Text(AppStrings.USER),
                                      onChanged: (newValue) => setState(
                                          () => _groupValue = newValue!),
                                      activeColor: AppColors.primaryColor,
                                      selected: false,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: RadioListTile(
                                      value: 1,
                                      groupValue: _groupValue,
                                      title: const Text(AppStrings.OPERATOR),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _groupValue = newValue!;
                                        });
                                      },
                                      activeColor: AppColors.primaryColor,
                                      selected: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(
                          height: 50,
                          width: width / 1.3,
                          child: AppButton(
                            label: AppStrings.REGISTER,
                            onPressed: () {
                              validate();
                            },
                            color: AppColors.primaryColor,
                            elevation: 2,
                            borderColor: AppColors.primaryWhite,
                          )),
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
