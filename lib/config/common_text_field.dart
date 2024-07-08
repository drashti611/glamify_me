// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text_style.dart';

Widget commonTextField(
    {TextEditingController? controller,
    bool? enabled,
    TextInputType? keyBoard,
    String? suggestionTxt,
    TextInputAction? action,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    IconData? icons}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        enabled: enabled,
        validator: validator,
        onChanged: onChanged,
        textInputAction: action,
        controller: controller,
        cursorColor: color5254A8,
        keyboardType: keyBoard,
        decoration: InputDecoration(
          hintText: suggestionTxt,
          fillColor: Color.fromARGB(255, 196, 167, 157),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.brown)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color.fromARGB(255, 240, 240, 240)),
          ),
          suffixIcon: Icon(icons),
        ),
      ),
    ],
  );
}

Widget commonPasswordTextField({
  TextEditingController? controller,
  String? hintText,
  String? suggestionTxt,
  Function()? onPressed,
  TextInputAction? action,
  required bool obsecure,
  IconButton? btn,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        validator: validator,
        onChanged: onChanged,
        obscureText: obsecure,
        controller: controller,
        textInputAction: action,
        cursorColor: color5254A8,
        decoration: InputDecoration(
          hintText: suggestionTxt,
          fillColor: Color.fromARGB(255, 196, 167, 157),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.brown)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color.fromARGB(255, 240, 240, 240)),
          ),
          suffixIcon: btn,
        ),
      ),
    ],
  );
}
