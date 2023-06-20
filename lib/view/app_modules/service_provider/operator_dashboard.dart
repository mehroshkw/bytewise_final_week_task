import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/view/app_modules/service_provider/operator_profile.dart';
import 'package:maintenance_services_app/view/app_modules/service_provider/rate_operator.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/auth_controller.dart';
import '../../reusable_widgets/app_heading.dart';
import '../../reusable_widgets/sub_heading.dart';
import '../../work_detail.dart';

class OperatorDashboard extends StatefulWidget {
  const OperatorDashboard({Key? key}) : super(key: key);

  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthController authController = AuthController();

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          AppStrings.OPERATOR_DASHBOARD,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const OperatorProfile());
              },
              icon: const Icon(Icons.person_outline)),
          IconButton(
              onPressed: () {
                authController.logoutUser();
              },
              icon: const Icon(Icons.logout)),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppStrings.WORK_REQUEST),
            Tab(text: AppStrings.MY_PROPOSAL),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [workRequests(), yourProposals()],
      ),
    );
  }

  Widget workRequests() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('work_requests')
          .where('status', isEqualTo: "pending")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            AppStrings.NO_WORK_REQUESTS,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.black),
          ));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                onTap: () {
                  Get.to(WorkDetail(
                    data: data,
                  ));
                },
                child: Card(
                  color: AppColors.primaryColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: AppColors.primaryColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      // Replace with the URL of the image from Firebase
                      data['pics'][0],
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    ),
                    tileColor: AppColors.primaryGreyColor,
                    title: Subheading(
                      text: data['title'],
                      color: AppColors.primaryColor,
                    ),
                    subtitle: Text(
                      data['desc'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Subheading(
                      text: "Rs. ${data['price']}",
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProposalStream() {
    return FirebaseFirestore.instance.collection('proposals').snapshots();
  }

  Widget yourProposals() {
    Future<String> getStatus(String workID) async {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('work_requests')
          .where('id', isEqualTo: workID)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final document = querySnapshot.docs.first;
        final status = document['status'] as String?;
        return status ??
            "Not Status Found"; // Return an empty string if status is null
      } else {
        return ""; // No matching document found
      }
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getProposalStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Extract the list of documents from the snapshot
            List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data!.docs;

            return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  // Extract the proposal data from the document
                  Map<String, dynamic> proposalData = documents[index].data();
                  String rate = proposalData['rate'] ?? '';
                  String time = proposalData['time'] ?? '';
                  String material = proposalData['material'] ?? '';
                  String clientEmail = proposalData['clientEmail'] ?? '';
                  String title = proposalData['workTitle'] ?? '';
                  String status = proposalData['status'] ?? '';
                  String workId = proposalData['workId'] ?? '';

                  // Display the proposal details
                  return FutureBuilder<String?>(
                      future: getStatus(workId),
                      builder: (context, snapshot) {
                        String workStatus = snapshot.data ?? '';
                        return Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryGreyColor),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppHeading(
                                        text: title,
                                        textColor: AppColors.primaryColor,
                                      ),
                                      SizedBox(
                                          height: 30,
                                          child: AppButton(
                                            label: AppStrings.CHECK_RATING,
                                            onPressed: () => Get.to(
                                                RateOperator(
                                                    data: proposalData)),
                                            color: AppColors.primaryColor,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Request Posted by: $clientEmail",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Materials: $material",
                                    style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Subheading(
                                        text: "Time: $time",
                                        color: AppColors.primaryColor,
                                      ),
                                      Subheading(
                                        text: "Rate: $rate",
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                  const Divider(color: AppColors.primaryColor),
                                  Row(
                                    children: [
                                      const Subheading(
                                        text: "Proposal Status: ",
                                        color: AppColors.primaryColor,
                                      ),
                                      Subheading(
                                        text: status,
                                        color: Colors.red,
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                  const Divider(color: AppColors.primaryColor),
                                  Row(
                                    children: [
                                      const Subheading(
                                        text: "Work Request Status: ",
                                        color: AppColors.primaryColor,
                                      ),
                                      Subheading(
                                        text: workStatus,
                                        color: Colors.red,
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                  const SizedBox(height: 5)
                                ]));
                      });
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          } else {
            return const Subheading(
              text: AppStrings.NO_PROPOSALS_YET,
              color: AppColors.primaryColor,
            );
          }
        });
  }
}
