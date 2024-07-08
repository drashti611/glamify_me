// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:glamify_app_me/config/text_style.dart';

Widget commonButton({
  Function()? onPressed,
  Color? buttonColor,
  double width = 50,
  Widget? child,
}) {
  return MaterialButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    onPressed: onPressed,
    minWidth: width,
    height: 60,
    color: Color.fromARGB(255, 68, 46, 38),
    elevation: 0,
    child: child,
  );
}

Widget commonWelcomeButton({
  VoidCallback? onPressed,
  Color? buttonColor,
  String? txt,
  double minWidth = 60,
}) {
  return MaterialButton(
    minWidth: minWidth,
    onPressed: onPressed,
    height: 50,
    color: buttonColor,
    child: Text(
      txt ?? '',
      style: color172F49w70016.copyWith(fontSize: 20),
    ),
  );
}
