import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maintenance_services_app/constants/app_colors.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/custom_appbar.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List category = [
    "Furniture Assembly",
    "Electric Work",
    "Plumbing",
    "Moving",
    "Painting",
    "Landscaping"
  ];
  List icons = [
    "assets/2.png",
    "assets/4.png",
    "assets/3.png",
    "assets/5.png",
    "assets/6.png",
    "assets/7.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: AppStrings.SELECT_CATEGORY),
      body: BackgroundWidget(child: buildGridView()),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: category.length,
        itemBuilder: ((context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () => Get.back(result: category[index]),
                  child: Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "${icons[index]}",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          category[index],
                          style: Theme.of(context).textTheme.headlineSmall
                        )
                      ])))));
        }));
  }
}
