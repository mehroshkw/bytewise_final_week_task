import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants/app_strings.dart';
import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class ProfileController extends GetxController {

  var isLoading = false.obs;
  final RxBool isDataLoaded = false.obs;

  var name = ''.obs;
  var address = ''.obs;
  var city = ''.obs;
  var country = ''.obs;
  var cnic = ''.obs;
  var phone = ''.obs;
  var imageUrl = ''.obs;

  String email = LocalStorage.getString("email");
  String userRole = LocalStorage.getString("userType");


  Future<void> getUser() async {
    isLoading(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('app_users')
        .doc(email)
        .get();
    if (snapshot.exists) {
      final userData = snapshot.data() as Map<String, dynamic>;

      // Retrieve the user data fields
      name.value = userData['name'];
      address.value = userData['address'];
      city.value = userData['city'];
      country.value = userData['country'];
      cnic.value = userData['cnic'];
      phone.value = userData['phone'];
      imageUrl.value = userData['imageUrl'];

      isLoading(false);
    } else {
      isLoading(false);
      showToast(AppStrings.USER_PROFILE_NOT_FOUND);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUser();
  }
}
