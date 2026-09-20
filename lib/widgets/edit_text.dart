import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  const EditText({super.key, required this.label, required this.obscureText});

  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: Colors.white), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),),
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
    );
  }
}