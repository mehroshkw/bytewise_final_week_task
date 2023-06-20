import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_images.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/constants/const_function.dart';
import 'package:maintenance_services_app/controllers/rate_operator_controller.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/sub_heading.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/local_storage.dart';
import '../../reusable_widgets/custom_appbar.dart';

class RateOperator extends StatelessWidget {
  final Map<String, dynamic> data;

  const RateOperator({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// passing data from previous class
    // String SPname = data['proposal'] ?? '';
    String SPemail = data['email'] ?? '';

    /// logged in user email from shared preferences
    String email = LocalStorage.getString("email");

    final controller = Get.put(RateOperatorController(SPemail: SPemail));

    return Scaffold(
        appBar: CustomAppBar(
            title: controller.isClient
                ? AppStrings.RATE_OPERATOR
                : AppStrings.MY_RATING),
        body: BackgroundWidget(
            child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  /// -- IMAGE
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: AppColors.primaryGreyColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 1,
                                          )),
                                      child: const Image(
                                          image:
                                              AssetImage(AppImages.APP_LOGO)))),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Subheading(
                              text: "Email: $SPemail",
                              color: AppColors.primaryColor,
                            ),
                            Obx(() => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Subheading(
                                        text:
                                            "Total Rating: ${controller.rating!.value}",
                                        color: AppColors.primaryColor,
                                      ),
                                      RatingBar.builder(
                                          initialRating:
                                              controller.rating!.value,
                                          itemSize: 30.0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 1.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          onRatingUpdate: (rating) {})
                                    ])),

                            /// -- Rate if client
                            controller.isClient
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: AppButton(
                                      color: AppColors.primaryColor,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) => RatingDialog(
                                            starSize: 30.0,
                                            initialRating: 1.0,
                                            title: const Text(
                                              AppStrings.RATE_OPERATOR,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                            submitButtonText: 'Submit',
                                            commentHint: 'Add a Review',
                                            onSubmitted: (response) {
                                              controller.addRatingAndReview(
                                                  email,
                                                  SPemail,
                                                  response.rating,
                                                  response.comment);
                                              showToast(AppStrings.ADDING);
                                            },
                                          ),
                                        );
                                      },
                                      label: "Add Review",
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: AppColors.primaryColor,
                  ),

                  Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.getRatingStream(SPemail),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              // Extract the list of documents from the snapshot
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  documents = snapshot.data!.docs;

                              return ListView.builder(
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    // Extract the proposal data from the document
                                    Map<String, dynamic> ratings =
                                        documents[index].data();
                                    String userEmail =
                                        ratings['submittedByUser'] ?? '';
                                    double rating = ratings['rating'] ?? '';
                                    String comment = ratings['comment'] ?? '';

                                    // Display the proposal details
                                    return Container(
                                        margin: const EdgeInsets.all(4),
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.primaryGreyColor),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Subheading(
                                                      text: userEmail,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    Subheading(
                                                      text: "Rating: $rating",
                                                      color: AppColors
                                                          .primaryColor,
                                                    )
                                                  ]),
                                              Text(
                                                "Comment: $comment",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              )
                                            ]));
                                  });
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator()));
                            } else {
                              return const Subheading(
                                text: AppStrings.NO_REVIEW,
                                color: AppColors.primaryColor,
                              );
                            }
                          }))
                ]))));
  }
}
