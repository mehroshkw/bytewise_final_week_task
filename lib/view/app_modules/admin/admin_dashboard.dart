import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_colors.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import '../../../controllers/admin_controller.dart';
import '../../../controllers/auth_controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthController authController = AuthController();
  final adminController = Get.put(AdminController());

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
          AppStrings.ADMIN_DASHBOARD,
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: [
          IconButton(
              onPressed: () {
                authController.logoutUser();
              },
              icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppStrings.USERS),
            Tab(text: AppStrings.OPERATORS),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserTab(),
          _buildOperatorTab(),
        ],
      ),
    );
  }

  Widget _buildUserTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('app_users')
          .where('userRole', isEqualTo: 'User')
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
            AppStrings.NO_USER_FOUND,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.black),
          ));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['email']),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        data["approved"] ? Colors.red : AppColors.primaryColor,
                  ),
                  onPressed: () {
                    if (data["approved"] == false) {
                      adminController.approveUser(userEmail: data['email']);
                    } else {
                      adminController.blockUser(userEmail: data['email']);
                    }
                  },
                  child: Text(data["approved"] ? "Block" : "Approve")),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildOperatorTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('app_users')
          .where('userRole', isEqualTo: 'Operator')
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
            AppStrings.NO_USER_FOUND,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(color: Colors.black),
          ));
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['email']),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        data["approved"] ? Colors.red : AppColors.primaryColor,
                  ),
                  onPressed: () {
                    if (data["approved"] == false) {
                      adminController.approveUser(userEmail: data['email']);
                    } else {
                      adminController.blockUser(userEmail: data['email']);
                    }
                  },
                  child: Text(data["approved"] ? "Block" : "Approve")),
            );
          }).toList(),
        );
      },
    );
  }
}
