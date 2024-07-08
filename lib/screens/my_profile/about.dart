// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "About",
          style: TextStyle(
            fontSize: 18,
            color: colorFFFFFF,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: color5254A8,
                radius: 50,
              ),
            ).paddingOnly(bottom: 20),
            Text(
              'Welcome to our e-commerce application (“Glamify Me”)! We are a team of dedicated individuals who are passionate about providing you with a seamless and enjoyable shopping experience.\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Our App offers a wide selection of products, from Makeup and accessories to home goods, at affordable prices. We are committed to providing our customers with high-quality products, fast and reliable shipping, and excellent customer service. \n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "At our core, we value transparency, integrity, and innovation. We strive to exceed our customers' expectations by staying up-to-date with the latest technologies in the e-commerce industry. \n",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Thank you for choosing our App for your shopping needs. We appreciate your business and are committed to providing you with a satisfying and memorable shopping experience. \n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "If you have any questions or feedback, please don't hesitate to contact us at staticstartupdeveloper@gmail.com \n",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ).paddingAll(15),
      ),
    );
  }
}
