import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../constants/const_function.dart';

class AdminController extends GetxController{


  //Send Account Approval Email
  approveUser({required String userEmail}) async {
    // Admin's Email
    String username = AppStrings.ADMIN_EMAIL_GMAIL;
    // Admin's Gmail password
    String password = AppStrings.ADMIN_PASS_GMAIL;

    final smtpServer = gmail(
      username,
      password,
    );

    final message = Message()
      ..from = Address(username, AppStrings.SERVICE_PROVIDER)
      ..recipients.add(userEmail)
      ..subject = AppStrings.ACCOUNT_ACCTIVATION_ALERT
      ..text = AppStrings.ACTIVATION_MSG;

    FirebaseFirestore.instance
        .collection('app_users')
        .doc(userEmail)
        .update({"approved": true}).then((result) async {
      showToast(AppStrings.USER_APPROVED);

      await send(message, smtpServer);
    }).catchError((onError) {
      showToast(AppStrings.SMTHNG_WENT_WRONG);
    });
  }

  //Block User
  blockUser({required String userEmail}) async {
    FirebaseFirestore.instance
        .collection('app_users')
        .doc(userEmail)
        .update({"approved": false}).then((result) async {
      showToast(AppStrings.BLOCK_USER);
    }).catchError((onError) {
      showToast(AppStrings.SMTHNG_WENT_WRONG);
    });
  }
}