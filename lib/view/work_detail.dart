import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/controllers/work_controller.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_heading.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/sub_heading.dart';
import '../constants/app_colors.dart';
import 'app_modules/service_provider/add_proposal_screen.dart';
import 'reusable_widgets/custom_appbar.dart';

class WorkDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  const WorkDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    const int initialPageIndex = 0;
    var controller = Get.put(WorkController(workId: data['id']));

    final workId = data['id'];
    final workTitle = data['title'];

    return Scaffold(
        appBar: CustomAppBar(title: data['title']),
        body: BackgroundWidget(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          height: height / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(
                                      0, 3) // changes position of shadow
                                  )
                            ],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: PageView.builder(
                                  controller: PageController(
                                      initialPage: initialPageIndex),
                                  itemCount: data['pics'].length,
                                  itemBuilder: (context, index) {
                                    return Image.network(data['pics'][index],
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height);
                                  }))),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 4.0, right: 12.0, left: 12.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppHeading(
                                    text: data['title'],
                                    textColor: AppColors.primaryColor),
                                Text('Rs. ${data['price']}',
                                    // Replace with your price variable
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: AppColors.textColor))
                              ])),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, bottom: 4.0, right: 12.0, left: 12.0),
                          child: Text(data['desc'],
                              softWrap: true,
                              // Replace with your price variable
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.textColor))),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Subheading(
                              text: "Category: ${data['category']}",
                              color: AppColors.primaryColor)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Subheading(
                              text: "Address: ${data['address']}",
                              color: AppColors.primaryColor)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Subheading(
                              text: "User Email: ${data['email']}",
                              color: AppColors.primaryColor)),
                      controller.isClient
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Subheading(
                                text: "Work Status:",
                                color: AppColors.primaryColor,
                              ))
                          : const SizedBox(),
                      controller.isClient
                          ? Obx(() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () =>
                                            controller.updateStatus(
                                                data['id'], 'pending'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              controller.status.value ==
                                                      'pending'
                                                  ? AppColors.primaryColor
                                                  : Colors.grey,
                                          minimumSize: const Size(100, 40),
                                        ),
                                        child: const Text('Pending')),
                                    ElevatedButton(
                                        onPressed: () =>
                                            controller.updateStatus(
                                                data['id'], 'ongoing'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                controller.status.value ==
                                                        'ongoing'
                                                    ? AppColors.primaryColor
                                                    : Colors.grey,
                                            minimumSize: const Size(100, 40)),
                                        child: const Text('Ongoing')),
                                    ElevatedButton(
                                        onPressed: () =>
                                            controller.updateStatus(
                                                data['id'], 'complete'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                controller.status.value ==
                                                        'complete'
                                                    ? AppColors.primaryColor
                                                    : Colors.grey,
                                            minimumSize: const Size(100, 40)),
                                        child: const Text('Complete')),
                                  ]))
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.isClient
                              ? const SizedBox()
                              : SizedBox(
                                  height: 35,
                                  width: width / 2,
                                  child: AppButton(
                                      label: AppStrings.ADD_PROPOSAL,
                                      color: AppColors.primaryColor,
                                      onPressed: () {
                                        Get.to(AddProposalScreen(
                                          workId: workId,
                                          clientEmail: data['email'],
                                          workTitle: workTitle,
                                        ));
                                      }),
                                ),
                        ],
                      ),
                      controller.isClient
                          ? const SizedBox()
                          : const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Subheading(
                                text: "All Proposals",
                                color: AppColors.primaryColor,
                              ),
                            ),
                      controller.isClient
                          ? const SizedBox()
                          : SizedBox(
                              height: height / 3,
                              width: width / 1.0,
                              child: StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.getProposalStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      // Extract the list of documents from the snapshot
                                      List<
                                              QueryDocumentSnapshot<
                                                  Map<String, dynamic>>>
                                          documents = snapshot.data!.docs;

                                      return ListView.builder(
                                          itemCount: documents.length,
                                          itemBuilder: (context, index) {
                                            // Extract the proposal data from the document
                                            Map<String, dynamic> proposalData =
                                                documents[index].data();
                                            String time =
                                                proposalData['time'] ?? '';
                                            String rate =
                                                proposalData['rate'] ?? '';
                                            String material =
                                                proposalData['material'] ?? '';
                                            String userEmail =
                                                proposalData['email'] ?? '';
                                            String imageUrl =
                                                proposalData['imageUrl'] ?? '';

                                            // Display the proposal details
                                            return Container(
                                                margin: const EdgeInsets.all(4),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withOpacity(0.2)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColors
                                                        .primaryGreyColor),
                                                child: Row(children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              imageUrl),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      4.0),
                                                          child: Text(
                                                            userEmail,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .primaryColor),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Materials: $material",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontSize: 16),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Subheading(
                                                                text:
                                                                    "Time: $time",
                                                                color: AppColors
                                                                    .primaryColor,
                                                              ),
                                                              Subheading(
                                                                text:
                                                                    "Rate: $rate",
                                                                color: AppColors
                                                                    .primaryColor,
                                                              )
                                                            ])
                                                      ]))
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
                                              child:
                                                  CircularProgressIndicator()));
                                    } else {
                                      return const Align(
                                          alignment: Alignment.topCenter,
                                          child: Subheading(
                                            text: AppStrings
                                                .YOU_ADDED_NO_PROPOSAL,
                                            color: AppColors.primaryColor,
                                          ));
                                    }
                                  }))
                    ])))));
  }
}
