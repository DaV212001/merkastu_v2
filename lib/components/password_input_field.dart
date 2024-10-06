import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PasswordInput extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final GlobalKey<FormState>? formKey;
  final Function(dynamic val) onChanged;

  const PasswordInput(
      {required this.textEditingController,
      required this.hintText,
      super.key,
      this.formKey,
      required this.onChanged});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool pwdVisibility = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      obscureText: !pwdVisibility,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: Colors.grey.withOpacity(.75), fontSize: 14),
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
          suffixIcon: InkWell(
            onTap: () => setState(
              () => pwdVisibility = !pwdVisibility,
            ),
            child: Icon(
              pwdVisibility
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey.shade400,
              size: 18,
            ),
          ),
          errorStyle: const TextStyle(
              fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter a password';
        } else if (val.length != 6) {
          return 'Password must be exactly 6 characters long';
        }
        return null;
      },
    );
  }
}
