import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  String label = '';
  TextInputType keyboardType;
  TextEditingController controller;
  String? Function(String?) validator;
  bool isPassword;

  TextFormFieldWidget({
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.validator,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label),
          // labelStyle: TextStyle(color: Color(0xff797979)),
        ),
        controller: controller,
        validator: validator,
        obscureText: isPassword,
      ),
    );
  }
}
