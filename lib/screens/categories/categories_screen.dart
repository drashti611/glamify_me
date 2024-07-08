// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/screens/categories/Hair_categories_screen.dart';

import 'package:glamify_app_me/screens/categories/makeup_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/skincare_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/nailcare_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/fragrences_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/wardrobes_categories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Stream<QuerySnapshot> _categorieStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "Categories",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _categorieStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.cyan,
              ),
            );
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    if (productData['categoryName'] == 'Makeup') {
                      Get.to(MakeupCategoriesScreen());
                    } else if (productData['categoryName'] == 'Haircare') {
                      Get.to(HairCategoriesScreen());
                    } else if (productData['categoryName'] == 'Skincare') {
                      Get.to(SkinCategoriesScreen());
                    } else if (productData['categoryName'] == 'Nailcare') {
                      Get.to(NailcareCategoriesScreen());
                    } else if (productData['categoryName'] == 'Fragrences') {
                      Get.to(FragrencesCategoriesScreen());
                    } else {
                      Get.to(WardrobesCategoriesScreen());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 221, 221),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            blurStyle: BlurStyle.outer,
                            offset: Offset.zero,
                            color: Color.fromARGB(255, 77, 49, 49),
                          ),
                          BoxShadow(
                            blurRadius: 2,
                            blurStyle: BlurStyle.outer,
                            offset: Offset.zero,
                            color: Color.fromARGB(255, 217, 203, 203),
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              productData['image'],
                              fit: BoxFit.fill,
                              height: 150,
                              width: 150,
                            ).paddingOnly(top: 10, bottom: 10),
                          ),
                          Text(
                            productData['categoryName'],
                            style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins')
                                .copyWith(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ).paddingOnly(left: 20),
                        ],
                      ).paddingOnly(top: 10, bottom: 10),
                    ),
                  ),
                ).paddingOnly(left: 10);
              },
            ),
          );
        },
      ),
    );
  }
}
