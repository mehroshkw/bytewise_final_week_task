import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/constants/const_function.dart';
import 'package:maintenance_services_app/constants/local_storage.dart';
import '../view/app_modules/admin/admin_dashboard.dart';
import '../view/app_modules/client/user_dashboard.dart';
import '../view/app_modules/service_provider/operator_dashboard.dart';
import '../view/reusable_widgets/app_alert.dart';
import '../view/user_role_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isUserLogin = false.obs;
  var isAdminLogin = false.obs;
  var isServiceProviderLogin = false.obs;
  Rx<XFile> selectedImage = Rx<XFile>(XFile(''));

  Future<String> uploadImage(XFile imageFile) async {
    // Generate a unique filename for the uploaded image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a reference to the storage location where the image will be uploaded
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/$fileName');

    // Get the bytes of the image file
    List<int> imageBytes = await imageFile.readAsBytes();

    // Convert the imageBytes to Uint8List
    Uint8List uint8List = Uint8List.fromList(imageBytes);

    // Upload the image bytes to the storage location
    await storageRef.putData(uint8List);

    // Get the download URL of the uploaded image
    String downloadURL = await storageRef.getDownloadURL();

    // Return the download URL
    return downloadURL;
  }

  Future<XFile?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    selectedImage.value = pickedImage!;
    return pickedImage;
  }

  Future<void> registerUser({
    required String email,
    required String name,
    required String pin,
    required String cnic,
    required String address,
    required String city,
    required String country,
    required String phone,
    required int groupValue,
    XFile? imageFile,
  }) async {
    isLoading(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();

    if (!snapshot.exists) {
      final data = {
        "name": name,
        "email": email,
        "pin": pin,
        "cnic": cnic,
        "address": address,
        "city": city,
        "country": country,
        "phone": phone,
        "userRole": groupValue == 0 ? AppStrings.USER : AppStrings.OPERATOR,
        "approved": false,
      };

      if (imageFile != null) {
        print(imageFile.path);
        String imageUrl = await uploadImage(imageFile);
        data['imageUrl'] = imageUrl;
      }

      FirebaseFirestore.instance
          .collection('app_users')
          .doc(email)
          .set(data)
          .then((_) {
        showToast(AppStrings.ACCOUNT_CREATED);
        isLoading(false);
        Get.offAll(() => const UserRoles());
      }).catchError((onError) {
        isLoading(false);
        showToast(AppStrings.SMTHNG_WENT_WRONG);
      });
    } else {
      isLoading(false);
      showToast(AppStrings.USER_ALREADY_EXIST);
    }
  }

  userLogin(
      {required String email,
      required String pin,
      required BuildContext context}) async {
    isUserLogin(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();
    if (snapshot.exists && snapshot.get('pin') == pin) {
      if (snapshot.get('userRole') == 'User') {
        if (snapshot.get('approved') == true) {
          LocalStorage.saveString("userType", "user");
          LocalStorage.saveString("email", email);
          LocalStorage.saveString("address", snapshot.get('address'));
          LocalStorage.saveString("cnic", snapshot.get('cnic'));
          LocalStorage.saveString("name", snapshot.get('name'));
          LocalStorage.saveString("phone", snapshot.get('phone'));
          showToast(AppStrings.LOGING_IN);
          isUserLogin(false);
          Get.offAll(() => const UserDashboard());
        } else if (snapshot.get('approved') == false) {
          isUserLogin(false);
          showDialog(
            context: context,
            builder: (context) {
              return const AppAlertDialog(
                title: AppStrings.ACCOUNT_NOT_APPROVED,
                message: AppStrings.MSG,
              );
            },
          );
        }
      } else {
        isUserLogin(false);
        showToast(AppStrings.NOT_REGISTERED_USER);
      }
    } else {
      isUserLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  serviceProviderLogin(
      {required String email,
      required String pin,
      required BuildContext context}) async {
    isServiceProviderLogin(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();
    if (snapshot.exists && snapshot.get('pin') == pin) {
      if (snapshot.get('userRole') == 'Operator') {
        if (snapshot.get('approved') == true) {
          LocalStorage.saveString("userType", "operator");
          LocalStorage.saveString("email", email);
          LocalStorage.saveString(
              "address", snapshot.get('address').toString());
          LocalStorage.saveString("city", snapshot.get('city').toString());
          LocalStorage.saveString("cnic", snapshot.get('cnic').toString());
          LocalStorage.saveString("name", snapshot.get('name').toString());
          LocalStorage.saveString("phone", snapshot.get('phone').toString());
          LocalStorage.saveString(
              "country", snapshot.get('country').toString());
          LocalStorage.saveString("imageUrl", snapshot.get('imageUrl'));
          showToast(AppStrings.LOGING_IN);
          isServiceProviderLogin(false);
          Get.offAll(() => const OperatorDashboard());
        } else if (snapshot.get('approved') == false) {
          isServiceProviderLogin(false);
          showDialog(
            context: context,
            builder: (context) {
              return const AppAlertDialog(
                title: AppStrings.ACCOUNT_NOT_APPROVED,
                message: AppStrings.MSG,
              );
            },
          );
        }
      } else {
        isServiceProviderLogin(false);
        showToast(AppStrings.NOT_REGISTERED_SP);
      }
    } else {
      isServiceProviderLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  adminLogin(
      {required String email,
      required String pin,
      required BuildContext context}) async {
    isAdminLogin(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();
    if (snapshot.exists && snapshot.get('pin') == pin) {
      if (snapshot.get('userRole') == 'Admin') {
        LocalStorage.saveString("userType", "admin");
        LocalStorage.saveString("email", email);
        showToast(AppStrings.LOGING_IN);
        isAdminLogin(false);
        Get.offAll(() => const AdminDashboard());
      } else {
        isAdminLogin(false);
        showToast(AppStrings.NOT_REGISTERED_Admin);
      }
    } else {
      isAdminLogin(false);
      showToast(AppStrings.INVALID);
    }
  }

  Future<void> logoutUser() async {
    LocalStorage.removeAll();
    Get.offAll(const UserRoles());
  }
}
