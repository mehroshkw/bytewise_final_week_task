import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/controllers/user_controller.dart';
import 'package:maintenance_services_app/view/app_modules/client/client_profile.dart';
import 'package:maintenance_services_app/view/reusable_widgets/app_button.dart';
import 'package:maintenance_services_app/view/work_detail.dart';
import 'package:maintenance_services_app/view/reusable_widgets/sub_heading.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/local_storage.dart';
import '../../../controllers/auth_controller.dart';
import '../service_provider/rate_operator.dart';
import 'add_work_request.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
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
          AppStrings.USER_DASHBOARD,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
              onPressed: () => Get.to(const ClientProfile()),
              icon: const Icon(Icons.person_outline)),
          IconButton(
              onPressed: () => authController.logoutUser(),
              icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppStrings.MY_WORK_REQUEST),
            Tab(text: AppStrings.PROPOSAL_RECIEVED),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [workRequests(), yourProposals()],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                Get.to(() => const AddWorkRequest());
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget workRequests() {
    String email = LocalStorage.getString("email");
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('work_requests')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(AppStrings.LOADING);
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
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
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
                                data['pics'][0],
                                // Replace with the URL of the image from Firebase
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
                              )))));
            }).toList(),
          );
        });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProposalStream() {
    return FirebaseFirestore.instance.collection('proposals').snapshots();
  }

  Widget yourProposals() {
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
                  String userEmail = proposalData['email'] ?? '';
                  String title = proposalData['workTitle'] ?? '';
                  String time = proposalData['time'] ?? '';
                  String rate = proposalData['rate'] ?? '';
                  String material = proposalData['material'] ?? '';
                  String imageUrl = proposalData['imageUrl'] ?? '';

                  // Display the proposal details
                  return Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryGreyColor),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(imageUrl),
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  Column(children: [
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width /
                                          4.5,
                                      child: AppButton(
                                        label:
                                            proposalData['status'] == 'pending'
                                                ? 'Accept'
                                                : 'Cancel',
                                        onPressed: () =>
                                            proposalData['status'] == 'pending'
                                                ? UserController()
                                                    .updateWorkStatus(
                                                        proposalData['workId'],
                                                        'accepted')
                                                : UserController()
                                                    .updateWorkStatus(
                                                        proposalData['workId'],
                                                        'pending'),
                                        color:
                                            proposalData['status'] == 'accepted'
                                                ? Colors.black12
                                                : AppColors.primaryColor,
                                        borderColor: AppColors.primaryColor,
                                        elevation: 2.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.5,
                                        child: AppButton(
                                          label: 'Rate',
                                          onPressed: () => Get.to(
                                              RateOperator(data: proposalData)),
                                          color: AppColors.primaryColor,
                                          borderColor: AppColors.primaryColor,
                                          elevation: 2.0,
                                        ))
                                  ])
                                ]),
                            Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  userEmail,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryColor),
                                )),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Subheading(
                                    text: title,
                                    color: AppColors.primaryColor,
                                  ),
                                  Text(
                                    "Rate: $rate",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Materials: $material",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryColor),
                                  ),
                                  Text(
                                    "Time: $time",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryColor),
                                  )
                                ])
                          ]));
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
