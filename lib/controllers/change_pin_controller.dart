import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/constants/const_function.dart';
import '../constants/local_storage.dart';

class ChangePinController extends GetxController{
  final TextEditingController oldPinC = TextEditingController();
  final TextEditingController newPinC = TextEditingController();
  final TextEditingController confirmPinC = TextEditingController();

  String email = LocalStorage.getString("email");

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  Future<void> validate() async {
    if (formKey.currentState!.validate()) {
     changePassword(email, oldPinC.text, newPinC.text);
    }
  }


  Future<void> changePassword(String email, String oldPin, String newPin) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      final document = querySnapshot.docs[0];
      final documentId = document.id;
      final existingPin = document.get('pin');

      if (existingPin == oldPin) {
        await FirebaseFirestore.instance
            .collection('app_users')
            .doc(documentId)
            .update({'pin': newPin});

        showToast(AppStrings.PIN_CHANGED_SUCCESSFULLY);
        oldPinC.clear();
        newPinC.clear();
        confirmPinC.clear();
        Get.back();
      } else {
        showToast(AppStrings.INVALID_OLD_PIN);
      }
    } else {
      showToast(AppStrings.USER_NOT_FOUND);
    }
  }


}