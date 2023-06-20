import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../constants/const_function.dart';
import '../constants/local_storage.dart';

class RateOperatorController extends GetxController {
  Rx<double>? rating = Rx(0.0);

  String SPemail;

  RateOperatorController({required this.SPemail});

  bool isClient = !LocalStorage().isClient;

  void addRatingAndReview(
    String userEmail,
    String reviewedUserEmail,
    double rating,
    String comment,
  ) async {
    try {
      // Check if a rating and review from the user already exists for the reviewed user
      QuerySnapshot existingReviews = await FirebaseFirestore.instance
          .collection('ratings')
          .where('submittedByUser', isEqualTo: userEmail)
          .where('ServiceProviderEmail', isEqualTo: reviewedUserEmail)
          .limit(1)
          .get();

      if (existingReviews.docs.isNotEmpty) {
        // Update the existing rating and review
        String existingReviewId = existingReviews.docs[0].id;

        await FirebaseFirestore.instance
            .collection('ratings')
            .doc(existingReviewId)
            .update({
          'rating': rating,
          'comment': comment,
        });

        showToast(AppStrings.REVIEW_UPDATED_SUCCESSFULLY);
      } else {
        // Create a new rating and review
        await FirebaseFirestore.instance.collection('ratings').add({
          'submittedByUser': userEmail,
          'ServiceProviderEmail': reviewedUserEmail,
          'rating': rating,
          'comment': comment,
        });

        showToast(AppStrings.REVIEW_UPDATED_SUCCESSFULLY);
      }
    } catch (e) {
      showToast(AppStrings.AN_ERROR_OCCURED);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRatingStream(SPEmail) {
    return FirebaseFirestore.instance
        .collection('ratings')
        .where('ServiceProviderEmail', isEqualTo: SPEmail)
        .snapshots();
  }

  Future<double> getAverageRatingForUser() async {
    double totalRating = 0;
    int numRatings = 0;

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('ratings')
              .where('ServiceProviderEmail', isEqualTo: SPemail)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        Map<String, dynamic> ratingData = documentSnapshot.data();
        double rating = ratingData['rating'] ?? 0;
        totalRating += rating;
        numRatings++;
      }
    } catch (e) {
     showToast(AppStrings.AN_ERROR_OCCURED_GET_RATING);
    }

    double averageRating = numRatings > 0 ? totalRating / numRatings : 0;
    rating!.value = averageRating;
    print("averageRating = $averageRating, rating: ${rating!.value}");
    return averageRating;
  }

  @override
  void onInit() {
    getAverageRatingForUser();
    super.onInit();
  }
}
