// submit the description of work with pictures and that work description should be entered by selecting specific category
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_services_app/constants/app_strings.dart';
import 'package:maintenance_services_app/view/app_modules/client/select_service.dart';
import 'package:maintenance_services_app/view/reusable_widgets/background_widget.dart';
import 'package:maintenance_services_app/view/reusable_widgets/custom_appbar.dart';
import 'package:maintenance_services_app/view/reusable_widgets/progress_indicator.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/user_controller.dart';
import '../../reusable_widgets/app_button.dart';

class AddWorkRequest extends StatefulWidget {
  const AddWorkRequest({Key? key}) : super(key: key);

  @override
  State<AddWorkRequest> createState() => _AddWorkRequestState();
}

class _AddWorkRequestState extends State<AddWorkRequest> {
  List<File> images = <File>[];
  final ImagePicker picker = ImagePicker();
  TextEditingController category = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const CustomAppBar(title: AppStrings.ADD_WORK_REQUEST),
        body: Obx(() {
          return BackgroundWidget(
              child: userController.isLoading.value
                  ? const Center(child: LoaderWidget())
                  : SingleChildScrollView(
                      child: Column(children: [
                      images.isNotEmpty
                          ? buildGridView()
                          : buildCustomContainer(),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: title,
                                    validator: (title) {
                                      if (title!.isEmpty) {
                                        return AppStrings.ENTER_TITLE;
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: AppStrings.TITLE,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  AppColors.primaryGreyColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )))),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () async {
                                      var data = await Get.to(
                                          () => const SelectService());
                                      category.text = data;
                                    },
                                    child: TextFormField(
                                        validator: (category) {
                                          if (category!.isEmpty) {
                                            return AppStrings.ENTER_CATEGORY;
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: category,
                                        enabled: false,
                                        decoration: InputDecoration(
                                            hintText:
                                                AppStrings.SELECT_CATEGORY,
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: AppColors
                                                      .primaryGreyColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color:
                                                      AppColors.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ))))),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: price,
                                    validator: (price) {
                                      if (price!.isEmpty) {
                                        return AppStrings.ENTER_PRICE;
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        hintText: AppStrings.PRICE,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  AppColors.primaryGreyColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )))),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    validator: (desc) {
                                      if (desc!.isEmpty) {
                                        return AppStrings.ENTER_DESCRIPTION;
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: desc,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        hintText: AppStrings.DESCRIPTION,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  AppColors.primaryGreyColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: AppColors.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )))),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (desc) {
                                    if (desc!.isEmpty) {
                                      return AppStrings.ENTER_ADDRESS;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: address,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      hintText: AppStrings.ADD_ADDRESS,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryGreyColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.primaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ))
                          ])),
                      SizedBox(
                          width: size.width * 0.6,
                          child: AppButton(
                            label: AppStrings.UPLOAD,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                userController.uploadToFirebaseStorage(
                                    category: category.text.trim(),
                                    desc: desc.text.trim(),
                                    address: address.text.trim(),
                                    price: price.text.trim(),
                                    title: title.text.trim(),
                                    images: images);
                              }
                            },
                            color: AppColors.primaryColor,
                            elevation: 2,
                            borderColor: AppColors.primaryWhite,
                          )),
                    ])));
        }));
  }

  Widget buildGridView() {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          File asset = images[index];
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(children: [
                InkWell(
                  onTap: loadAssets,
                  child: Image.file(asset),
                ),
                Column(children: [
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.black87.withOpacity(0.5),
                        Colors.transparent,
                      ], begin: Alignment.topCenter, end: Alignment.center),
                    ),
                    child: null,
                  )
                ]),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              child:
                                  const Icon(Icons.clear, color: Colors.white))
                        ]))
              ]));
        }));
  }

  Widget buildCustomContainer() {
    return GridView.count(shrinkWrap: true, crossAxisCount: 3, children: [
      InkWell(
          onTap: loadAssets,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade300,
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: Icon(Icons.add),
                  )))),
      InkWell(
          onTap: loadAssets,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade300,
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: Icon(Icons.add),
                  )))),
      InkWell(
          onTap: loadAssets,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade300,
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: Icon(Icons.add),
                  )))),
      InkWell(
          onTap: loadAssets,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade300,
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: Icon(Icons.add),
                  )))),
      InkWell(
          onTap: loadAssets,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Colors.grey.shade300,
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: Icon(Icons.add),
                  ))))
    ]);
  }

  Future<void> loadAssets() async {
    try {
      final List<XFile> xImages = await picker.pickMultiImage();
      setState(() {
        for (var element in xImages) {
          images.add(File(element.path));
        }
      });
    } on Exception {
      return;
    }
    if (!mounted) return;
  }
}
