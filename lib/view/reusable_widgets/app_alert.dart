import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_heading.dart';
import '../../constants/app_colors.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;

  const AppAlertDialog({super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppHeading(text: title, textColor: AppColors.primaryColor),
      content: Text(message),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(
              color: AppColors.primaryWhite,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}
