import 'package:flutter/material.dart';
import 'package:maintenance_services_app/constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final String label;


  const CustomTextFormField({
    Key? key,
     this.hintText = "",
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    required this.controller,
    this.maxLength,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 6),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          label: Text(label),
          labelStyle: const TextStyle(
            color: AppColors.primaryColor
          ),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primaryGreyColor
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColors.primaryColor
            ),
            borderRadius: BorderRadius.circular(10),
          )
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        readOnly: readOnly,
      ),
    );
  }
}
