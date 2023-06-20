import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';

import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class WorkController extends GetxController {
  var isLoading = false.obs;
  RxString status = ''.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  TextEditingController proposalController = TextEditingController();

  bool isClient = !LocalStorage().isClient;
  String email = LocalStorage.getString("email");

  String workId;

  WorkController({required this.workId});

  Future<void> updateStatus(String workId, String newStatus) async {
    // Query the collection to find the document that contains the workId
    QuerySnapshot snapshot = await _db
        .collection('work_requests')
        .where('id', isEqualTo: workId)
        .get();

    // Check if any documents match the query
    if (snapshot.docs.isNotEmpty) {
      // Get the first document that matches the query
      DocumentSnapshot document = snapshot.docs.first;

      // Update the status field of the document
      final response = await _db
          .collection('work_requests')
          .doc(document.id)
          .update({'status': newStatus});
      status.value = newStatus;
    }
  }

  Future<void> fetchData(String workId) async {
    QuerySnapshot snapshot = await _db
        .collection('work_requests')
        .where('id', isEqualTo: workId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;

      final response =
          await _db.collection('work_requests').doc(document.id).get();
      status.value = response.get('status');
    }
  }

  @override
  Future<void> onInit() async {
    fetchData(workId);
    super.onInit();
  }

  uploadProposal({
    required String workId,
    required String proposal,
    required String clientEmail,
    required String workTitle,
  }) async {
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
        "proposal": proposal,
        // Update any other fields if needed
      }).then((value) {
        isLoading(false);
        proposalController.clear();
        showToast(AppStrings.PROPOSAL_UPDATED);
      }).catchError((e) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      // Create a new proposal
      await FirebaseFirestore.instance.collection("proposals").doc().set({
        "workId": workId,
        "proposal": proposal,
        "clientEmail": clientEmail,
        "email": email,
        "workTitle": workTitle,
        "status": "pending",
      }).then((value) {
        isLoading(false);
        proposalController.clear();
        showToast(AppStrings.PROPOSAL_UPDATED);
      }).catchError((e) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProposalStream() {
    return FirebaseFirestore.instance
        .collection('proposals')
        .where('workId', isEqualTo: workId)
        .where('email', isEqualTo: email)
        .snapshots();
  }
}
