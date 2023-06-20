import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController pinC = TextEditingController();
  final TextEditingController cnicC = TextEditingController();
  final TextEditingController addressC = TextEditingController();
  final TextEditingController cityC = TextEditingController();
  final TextEditingController countryC = TextEditingController();
  final TextEditingController phnC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  String email = LocalStorage.getString("email");
  String name = LocalStorage.getString("name");
  String address = LocalStorage.getString("address");
  String city = LocalStorage.getString("city");
  String country = LocalStorage.getString("country");
  String cnic = LocalStorage.getString("cnic");
  String phone = LocalStorage.getString("phone");
  String imageUrl = LocalStorage.getString("imageUrl");
  Rx<XFile> selectedImage = Rx<XFile>(XFile('')); // Selected image file

  @override
  void onInit() {
    super.onInit();
    // Set the initial values of the TextEditingController from shared pref
    nameC.text = name;
    emailC.text = email;
    addressC.text = address;
    cityC.text = city;
    countryC.text = country;
    cnicC.text = cnic;
    phnC.text = phone;
  }

  Future<void> validate() async {
    if (formKey.currentState!.validate()) {
      updateUserProfile(
        name: nameC.text,
        cnic: cnicC.text,
        address: addressC.text,
        city: cityC.text,
        country: countryC.text,
        phone: phnC.text,
        imageFile: selectedImage.value,
      );
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String cnic,
    required String address,
    required String city,
    required String country,
    required String phone,
    XFile? imageFile,
  }) async {
    isLoading(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();
    if (snapshot.exists) {
      final updateData = {
        "name": name,
        "cnic": cnic,
        "address": address,
        "city": city,
        "country": country,
        "phone": phone,
      };

      if (imageFile != null) {
        String imageUrl = await uploadImage(imageFile);
        updateData['imageUrl'] = imageUrl;
      }

      FirebaseFirestore.instance
          .collection('app_users')
          .doc(email)
          .update(updateData)
          .then((value) {
        // Update the values in shared preferences
        LocalStorage.saveString("name", name);
        LocalStorage.saveString("address", address);
        LocalStorage.saveString("city", city);
        LocalStorage.saveString("country", country);
        LocalStorage.saveString("cnic", cnic);
        LocalStorage.saveString("phone", phone);
        if (imageFile != null) {
          LocalStorage.saveString("imageUrl", imageUrl);
        }

        showToast(AppStrings.PROPOSAL_UPDATED);
        isLoading(false);
        Get.back(result: true);
      }).catchError((onError) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      isLoading(false);
      showToast(AppStrings.PROFILE_NOT_FOUND);
    }
  }

  Future<String> uploadImage(XFile imageFile) async {
    // Generate a unique filename for the uploaded image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a reference to the storage location where the image will be uploaded
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/$fileName');
    // Upload the image file to the storage location
    await storageRef.putFile(File(imageFile.path));

    // Get the download URL of the uploaded image
    String downloadURL = await storageRef.getDownloadURL();

    // Return the download URL
    return downloadURL;
  }

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage.value = XFile(pickedImage.path);
      return pickedImage.path;
    }
  }
}
