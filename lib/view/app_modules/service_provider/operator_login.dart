import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../reusable_widgets/app_button.dart';
import '../../reusable_widgets/app_textfield.dart';
import '../../reusable_widgets/background_widget.dart';
import '../../reusable_widgets/custom_appbar.dart';
import '../../reusable_widgets/progress_indicator.dart';

class OperatorLogin extends StatefulWidget {
  const OperatorLogin({Key? key}) : super(key: key);

  @override
  State<OperatorLogin> createState() => _OperatorLoginState();
}

class _OperatorLoginState extends State<OperatorLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController pinC = TextEditingController();
  final authController = Get.put(AuthController());

  Future<void> validate() async {
    if (_formKey.currentState!.validate()) {
      authController.serviceProviderLogin(
          email: emailC.text.trim(), pin: pinC.text.trim(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.SP_LOGIN),
        body: Obx(() {
          return BackgroundWidget(
              child: authController.isServiceProviderLogin.value
                  ? const Center(child: LoaderWidget())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          Form(
                              key: _formKey,
                              child: Column(children: [
                                CustomTextFormField(
                                    controller: emailC,
                                    label: AppStrings.SP_EMAIL,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (email) {
                                      if (email!.isEmpty) {
                                        return AppStrings.ENTER_EMAIL;
                                      } else if (!email.contains("@")) {
                                        return AppStrings.ENTER_VALID_EMAIL;
                                      } else if (!email.contains(".com")) {
                                        return AppStrings.ENTER_VALID_EMAIL;
                                      } else {
                                        return null;
                                      }
                                    }),
                                CustomTextFormField(
                                    controller: pinC,
                                    label: AppStrings.SP_PIN,
                                    keyboardType: TextInputType.number,
                                    validator: (pin) {
                                      if (pin!.isEmpty) {
                                        return AppStrings.ENTER_PIN;
                                      } else if (pin.length > 4) {
                                        return AppStrings.ENTER_VALID_PIN;
                                      } else {
                                        return null;
                                      }
                                    })
                              ])),
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
                        ]));
        }));
  }
}
