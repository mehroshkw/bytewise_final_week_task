import 'package:flutter/material.dart';
import 'package:maintenance_services_app/constants/app_images.dart';


class BackgroundWidget extends StatelessWidget {
  final Widget child;
  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.APP_BG),
          fit: BoxFit.fill,
        ),
      ),
      child: child,
    );
  }
}
