import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/screens/product_overview/product_overview.dart';

import '../../config/text.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WardrobesCategoriesScreen extends StatefulWidget {
  const WardrobesCategoriesScreen({super.key});

  @override
  State<WardrobesCategoriesScreen> createState() =>
      _WardrobesCategoriesScreenState();
}

class _WardrobesCategoriesScreenState extends State<WardrobesCategoriesScreen> {
  final Stream<QuerySnapshot> _tablesCategorieStream = FirebaseFirestore
      .instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Wardrobes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: color5254A8,
        elevation: 0.0,
        title: Text(
          "Wardrobes",
          style: TextStyle(
            fontSize: 18,
            color: colorFFFFFF,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _tablesCategorieStream,
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
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(ProductOverview(
                        productId: productData['productID'],
                        productImage: productData['image'],
                        productName: productData['productName'],
                        productPrice: productData['productPrice'],
                        productDetail: productData['productDetail'],
                        userName: "",
                        UserEmail: "",
                      ));
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                            ),
                          ]),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productData['productName'],
                                style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')
                                    .copyWith(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ).paddingOnly(left: 20),
                              Text(
                                rupees +
                                    ' ' +
                                    productData['productPrice'].toString(),
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
                          ),
                        ],
                      ).paddingOnly(top: 10, bottom: 10),
                    ).paddingOnly(left: 10),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
