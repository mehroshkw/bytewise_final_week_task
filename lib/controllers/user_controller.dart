import 'dart:io';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/constants/const_function.dart';
import 'package:maintenance_services_app/constants/local_storage.dart';
import 'package:uuid/uuid.dart';

class UserController extends GetxController {
  List pics = [];
  final storageRef = FirebaseStorage.instance.ref();
  var isLoading = false.obs;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxString status = ''.obs;

  Future uploadToFirebaseStorage(
      {required List<File> images,
      required String title,
      required String category,
      required String price,
      required String desc,
      required String address}) async {
    isLoading(true);
    for (var element in images) {
      File f = element;
      uploadToFStorage(element.path, f.path,
          images: images,
          title: title,
          desc: desc,
          address: address,
          price: price,
          category: category);
    }
  }

  uploadToFStorage(
    fileName,
    filePath, {
    required List<File> images,
    required String title,
    required String category,
    required String price,
    required String desc,
    required String address,
  }) async {
    var ref = storageRef.child('posts/').child(fileName);
    var uploadTask = ref.putFile(io.File(filePath));
    uploadTask.whenComplete(() => {
          ref.getDownloadURL().then((value) => {
                pics.add(value),
                check(
                    images: images,
                    title: title,
                    desc: desc,
                    address: address,
                    price: price,
                    category: category),
              }),
        });
  }

  check(
      {required List<File> images,
      required String title,
      required String category,
      required String desc,
      required String address,
      required String price}) {
    if (images.length == pics.length) {
      uploadToFirestore(
          title: title,
          desc: desc,
          address: address,
          price: price,
          category: category);
    }
  }

  uploadToFirestore(
      {required String title,
      required String category,
      required String desc,
      required String address,
      required String price}) async {
    var uuid = const Uuid();

    String email = LocalStorage.getString("email");
    // await Future.delayed(const Duration(seconds: 7));
    await FirebaseFirestore.instance.collection("work_requests").doc().set({
      "pics": pics,
      "title": title,
      "category": category,
      "desc": desc,
      "address": address,
      "price": price,
      "email": email,
      "status": "pending",
      "id": uuid.v4(),
    }).then((value) {
      isLoading(false);
      showToast(AppStrings.WORK_REQUEST_ADDED);
      Get.back();
    }).catchError((e) {
      isLoading(false);
      showToast("Something went wrong!");
    });
  }

  Future<void> updateWorkStatus(String workId, String newStatus) async {
    // Query the collection to find the document that contains the workId
    QuerySnapshot snapshot = await _db
        .collection('proposals')
        .where('workId', isEqualTo: workId)
        .get();

    // Check if any documents match the query
    if (snapshot.docs.isNotEmpty) {
      // Get the first document that matches the query
      DocumentSnapshot document = snapshot.docs.first;

      // Update the status field of the document
      await _db.collection('proposals').doc(document.id).update({'status': newStatus});
      showToast("Proposal $newStatus");
      status.value = newStatus;
    }
  }
}
