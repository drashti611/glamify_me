// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String img;
  final String imgtext;
  const ProductImage({super.key, required this.img, required this.imgtext});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
        child: Image.asset(
          img,
        ),
      ),
      Positioned(
        left: 110,
        top: 20,
        child: Text(
          imgtext,
          style: TextStyle(
              color: Color.fromARGB(255, 44, 32, 27),
              fontFamily: "DancingScript",
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
      )
    ]);
  }
}
