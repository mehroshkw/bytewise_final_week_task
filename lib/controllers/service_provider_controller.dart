import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:uuid/uuid.dart';

import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class ServiceProviderController extends GetxController {
  TextEditingController rate = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController material = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  uploadProposal({
    required String workId,
    required String clientEmail,
    required String workTitle,
  }) async {
    String email = LocalStorage.getString("email");

    // Check if a proposal from the user already exists for the given workId
    QuerySnapshot existingProposals = await FirebaseFirestore.instance
        .collection("proposals")
        .where("workId", isEqualTo: workId)
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (existingProposals.docs.isNotEmpty) {
      // Update the existing proposal
      String existingProposalId = existingProposals.docs[0].id;

      await FirebaseFirestore.instance
          .collection("proposals")
          .doc(existingProposalId)
          .update({
        "rate": rate.text,
        "time": time.text,
        "material": material.text,
        // Update any other fields if needed
      }).then((value) {
        rate.clear();
        time.clear();
        material.clear();
        isLoading(false);
        Get.back();
        showToast(AppStrings.PROPOSAL_UPDATED);
      }).catchError((e) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      // Create a new proposal
      await FirebaseFirestore.instance.collection("proposals").doc().set({
        "workId": workId,
        "rate": rate.text,
        "time": time.text,
        "material": material.text,
        "clientEmail": clientEmail,
        "email": email,
        "workTitle": workTitle,
        "status": "pending",
      }).then((value) {
        rate.clear();
        time.clear();
        material.clear();
        isLoading(false);
        showToast(AppStrings.PROPOSAL_UPDATED);
        Get.back();
      }).catchError((e) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    }
  }
}
