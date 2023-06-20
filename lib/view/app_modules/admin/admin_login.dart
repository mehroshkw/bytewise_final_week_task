import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/view/reusable_widgets/progress_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../reusable_widgets/app_button.dart';
import '../../reusable_widgets/app_textfield.dart';
import '../../reusable_widgets/background_widget.dart';
import '../../reusable_widgets/custom_appbar.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailC = TextEditingController();
  final TextEditingController pinC = TextEditingController();
  final authController = Get.put(AuthController());

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.adminLogin(
          email: emailC.text.trim(), pin: pinC.text.trim(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.LOGIN_TO_ADMIN),
      body: Obx(() {
        return BackgroundWidget(
          child: authController.isAdminLogin.value
              ? const Center(child: LoaderWidget())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: emailC,
                              label: AppStrings.ADMIN_EMAIL,
                              keyboardType: TextInputType.text,
                            ),
                            CustomTextFormField(
                              controller: pinC,
                              label: AppStrings.ADMIN_PIN,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        )),
                    SizedBox(
                        height: 50,
                        width: width / 1.3,
                        child: AppButton(
                          label: AppStrings.LOGIN,
                          onPressed: () => validate(),
                          color: AppColors.primaryColor,
                          elevation: 2,
                          borderColor: AppColors.primaryWhite,
                        ))
                  ],
                ),
        );
      }),
    );
  }
}
