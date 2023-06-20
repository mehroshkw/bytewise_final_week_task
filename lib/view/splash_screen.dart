import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_images.dart';
import 'package:maintenance_services_app/view/user_role_screen.dart';
import 'package:maintenance_services_app/view/app_modules/admin/admin_dashboard.dart';
import '../constants/local_storage.dart';
import 'app_modules/client/user_dashboard.dart';
import 'app_modules/service_provider/operator_dashboard.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  getLoginType() {
    String userType = LocalStorage.getString("userType");
    if (userType != "") {
      if (userType == "admin") {
        Future.delayed(const Duration(seconds: 3),
            () => Get.offAll(const AdminDashboard()));
      } else if (userType == "user") {
        Future.delayed(const Duration(seconds: 3),
            () => Get.offAll(const UserDashboard()));
      } else {
        Future.delayed(const Duration(seconds: 3),
            () => Get.offAll(const OperatorDashboard()));
      }
    } else {
      Future.delayed(
          const Duration(seconds: 3), () => Get.offAll(const UserRoles()));
    }
  }

  @override
  void initState() {
    super.initState();
    getLoginType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          AppImages.APP_SPLASH,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
