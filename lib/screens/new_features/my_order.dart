// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final Stream<QuerySnapshot> _orderCompleteStream = FirebaseFirestore.instance
      .collection('ReviewCart')
      .where('userName',
          isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
      .where('paymentStatus', isEqualTo: 'Payment Success')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        title: Text(
          "My Orders",
          style: TextStyle(fontSize: 18, color: Colors.white),
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
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _orderCompleteStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        final firebaseUser = FirebaseAuth.instance.currentUser;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    productData['cartImage'],
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    productData['cartName'],
                                    style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins')
                                        .copyWith(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ).paddingOnly(top: 10),
                                  Text(
                                    rupees +
                                        productData['cartPrice'].toString(),
                                    style: TextStyle(
                                            color: Color(0xFF999999),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins')
                                        .copyWith(fontSize: 18),
                                  ).paddingOnly(top: 5),
                                ],
                              ).paddingOnly(top: 10),
                            ),
                          ),
                        ).paddingOnly(left: 10);
                      },
                    ),
                  ),
                );

                //   return GridView.builder(
                //     shrinkWrap: true,
                //     itemCount: snapshot.data!.size,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //       mainAxisSpacing: 6,
                //       crossAxisSpacing: 6,
                //     ),
                //     itemBuilder: (context, index) {
                //       final productData = snapshot.data!.docs[index];
                //       return Column(
                //         children: [
                //           Image.network(
                //             productData['cartImage'],
                //             height: 100,
                //             width: 100,
                //             fit: BoxFit.fill,
                //           ),
                //           Text(
                //             productData['cartName'],
                //             style: TextStyle(
                //                     color: Color(0xFF000000),
                //                     fontSize: 18,
                //                     fontWeight: FontWeight.w500,
                //                     fontFamily: 'Poppins')
                //                 .copyWith(),
                //             overflow: TextOverflow.ellipsis,
                //             maxLines: 2,
                //           ).paddingOnly(top: 10),
                //           Text(
                //             rupees + productData['cartPrice'].toString(),
                //             style: TextStyle(
                //                     color: Color(0xFF999999),
                //                     fontSize: 12,
                //                     fontWeight: FontWeight.w400,
                //                     fontFamily: 'Poppins')
                //                 .copyWith(fontSize: 18),
                //           ).paddingOnly(top: 5),
                //           productData['deliveryStatus'] == 'Pending'
                //               ? Icon(Icons.pending_actions_rounded)
                //               : Icon(Icons.done_all_rounded),
                //         ],
                //       );
                //     },
                //   ).paddingOnly(top: 20, bottom: 3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
