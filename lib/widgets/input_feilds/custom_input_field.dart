import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final String? initialValue;
  final String? label;
  final Color primaryColor;
  final String? Function(String?)? validator;
  final Function(dynamic val) onChanged;
  final TextInputType? keyboardType;
  const CustomInputField(
      {super.key,
      required this.inputController,
      required this.hintText,
      this.primaryColor = const Color(0xFF3AE0C4),
      required this.onChanged,
      this.validator,
      this.keyboardType,
      this.initialValue,
      this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
      onChanged: onChanged,
      keyboardType: keyboardType,
      initialValue: initialValue,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: label,
        labelStyle: TextStyle(color: maincolor, fontSize: 12),
        hintStyle: const TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: maincolor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: maincolor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: maincolor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: maincolor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorStyle: const TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
      ),
      validator: validator,
    );
  }
}
