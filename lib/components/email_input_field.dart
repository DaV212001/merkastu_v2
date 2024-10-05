import 'package:flutter/material.dart';

import '../constants/constants.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController inputController;
  final GlobalKey<FormState>? formKey;

  final Function(dynamic val) onChanged;

  const EmailInput(
      {super.key,
      required this.inputController,
      this.formKey,
      required this.onChanged});
  @override
  EmailInputFb1State createState() => EmailInputFb1State();
}

class EmailInputFb1State extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        controller: widget.inputController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter your email',
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
          errorStyle: const TextStyle(
            color: Colors.red,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an email';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}
