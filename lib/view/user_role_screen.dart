import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_colors.dart';
import 'package:maintenance_services_app/constants/app_images.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_heading.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/sub_heading.dart';
import 'package:maintenance_services_app/view/app_modules/admin/admin_login.dart';
import 'package:maintenance_services_app/view/app_modules/client/user_login.dart';
import 'package:maintenance_services_app/view/app_modules/service_provider/operator_login.dart';
import '../constants/local_storage.dart';
import 'app_modules/register_view/register_screen.dart';

class UserRoles extends StatefulWidget {
  const UserRoles({Key? key}) : super(key: key);

  @override
  State<UserRoles> createState() => _UserRolesState();
}

class _UserRolesState extends State<UserRoles> {
  void saveUserType(bool isClient) {
    LocalStorage().setClient(!isClient);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
             AppImages.APP_LOGO,
              height: 180,
              width: 180,
            ),
            const AppHeading(
                text: "Login in as", textColor: AppColors.primaryColor),
            SizedBox(
                width: width * 0.6,
                child: AppButton(
                  label: AppStrings.USER,
                  onPressed: () {
                    saveUserType(true);
                    Get.to(() => const UserLogin());
                  },
                  color: AppColors.primaryColor,
                  borderColor: AppColors.primaryWhite,
                  elevation: 2,
                )),
            SizedBox(
                width: width * 0.6,
                child: AppButton(
                  label: AppStrings.SP,
                  onPressed: () {
                    saveUserType(false);
                    Get.to(() => const OperatorLogin());
                  },
                  color: AppColors.primaryColor,
                  borderColor: AppColors.primaryWhite,
                  elevation: 2,
                )),
            SizedBox(
                width: width * 0.6,
                child: AppButton(
                  label: AppStrings.ADMIN,
                  onPressed: () => Get.to(() => const AdminLogin()),
                  color: AppColors.primaryColor,
                  elevation: 2,
                  borderColor: AppColors.primaryWhite,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Subheading(
                  text: AppStrings.DONT_HAVE_ACCOUNT,
                  color: AppColors.textColor,
                ),
                InkWell(
                    onTap: () => Get.to(() => const Register()),
                    child: const Subheading(
                      text: AppStrings.REGISTER,
                      color: AppColors.primaryColor,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
