import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isObsecureText;

  const AuthField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isObsecureText = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return '$labelText is empty';
        }
        return null;
      },
      decoration: InputDecoration(labelText: labelText),
      obscureText: isObsecureText,
    );
  }
}
