// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, avoid_print, unused_element, await_only_futures, sized_box_for_whitespace, non_constant_identifier_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, unnecessary_this
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';
import 'package:glamify_app_me/providers/wishlist_provider.dart';
import 'package:glamify_app_me/screens/review_cart/review_cart.dart';
import 'package:glamify_app_me/widgets/count.dart';
import 'package:provider/provider.dart';

enum SinginCharacter { fill, outline }

class ProductOverview extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productPrice;
  final String productId;
  final String productDetail;
  final String userName;
  final String UserEmail;
  ProductOverview({
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productDetail,
    required this.userName,
    required this.UserEmail,
  });

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  // ignore: unused_field
  SinginCharacter _character = SinginCharacter.fill;

  Widget bonntonNavigatorBar({
    Color? iconColor,
    Color? backgroundColor,
    Color? color,
    String? title,
    IconData? iconData,
    Function? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(20),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 20,
                color: iconColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title!,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool wishListBool = false;

  getWishtListBool() {
    FirebaseFirestore.instance
        .collection("WishList")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("YourWishList")
        .doc(widget.productId)
        .get()
        .then((value) => {
              if (this.mounted)
                {
                  if (value.exists)
                    {
                      setState(
                        () {
                          wishListBool = value.get("wishList");
                        },
                      ),
                    }
                }
            });
  }

  final _formKey = GlobalKey<FormState>();
  // TextEditingController _reviewController = TextEditingController();
  // double _rating = 0.0;

  // final Stream<QuerySnapshot> _reviewStream = FirebaseFirestore.instance
  //     .collection('Ratings')
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .collection('Reviews')
  //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //     .snapshots();

  String? myEmail;
  String? myName;
  String? myProfile;

  String? paymentMethod;
  String? paymentStatus;

  @override
  Widget build(BuildContext context) {
    WishListProvider wishListProvider = Provider.of(context);
    getWishtListBool();
    return Scaffold(
      backgroundColor: colorFFFFFF,
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  wishListBool = !wishListBool;
                });
                if (wishListBool == true) {
                  wishListProvider.addWishListData(
                    wishListId: widget.productId,
                    wishListImage: widget.productImage,
                    wishListName: widget.productName,
                    wishListPrice: widget.productPrice,
                    wishListQuantity: 2,
                  );
                } else {
                  wishListProvider.wishlistDataDelete(widget.productId);
                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: addwish,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      wishListBool == false
                          ? Icons.favorite_outline
                          : Icons.favorite,
                      size: 20,
                      color: appbarclr,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Add To WishList',
                      style: TextStyle(color: appbarclr),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(ReviewCart());
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: appbarclr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shop_outlined,
                      size: 20,
                      color: addwish,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Go To Cart',
                      style: TextStyle(color: addwish),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: appbarclr,
        iconTheme: IconThemeData(color: colorFFFFFF),
        title: Text(
          "Product Overview",
          style: TextStyle(color: colorFFFFFF),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                        height: 250,
                        padding: EdgeInsets.all(40),
                        child: Image.network(
                          widget.productImage,
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text(
                        "Available Options",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Row(
                          //   children: [
                          //     CircleAvatar(
                          //       radius: 3,
                          //       backgroundColor: Colors.green[700],
                          //     ),
                          //     Radio(
                          //       value: SinginCharacter.fill,
                          //       groupValue: _character,
                          //       activeColor: Colors.green[700],
                          //       onChanged: (value) {
                          //         setState(() {
                          //           _character = value!;
                          //         });
                          //       },
                          //     ),
                          //   ],
                          // ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 340,
                                child: Text(
                                  widget.productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ).paddingOnly(bottom: 5),
                              ),
                              Row(
                                children: [
                                  Text(
                                    rupees + widget.productPrice.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 180,
                                  ),
                                  Count(
                                    productId: widget.productId,
                                    productImage: widget.productImage,
                                    productName: widget.productName,
                                    productPrice: widget.productPrice,
                                    userName: widget.userName,
                                    userEmail: widget.UserEmail,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // CountProduct(
                          //   productId: widget.productId,
                          //   productImage: widget.productImage,
                          //   productName: widget.productName,
                          //   productPrice: widget.productPrice,
                          //   userName: widget.userName,
                          //   userEmail: widget.UserEmail,
                          // ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 30,
                          //     vertical: 10,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: Colors.grey,
                          //     ),
                          //     borderRadius: BorderRadius.circular(
                          //       30,
                          //     ),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Icon(
                          //         Icons.add,
                          //         size: 17,
                          //         color: primaryColor,
                          //       ),
                          //       Text(
                          //         "ADD",
                          //         style: TextStyle(color: primaryColor),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About This Product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      // "of a customer. Wikipedi In marketing, a product is an object or system made available for consumer use; it is anything that can be offered to a market to satisfy the desire or need of a customer. Wikipedi",
                      widget.productDetail,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myEmail = ds.data()!['email'];
        myName = ds.data()!['fullName'];
        myProfile = ds.data()!['profile'];
        print(myName);
        print(myEmail);
        print(myProfile);
      }).catchError((e) {
        print(e);
      });
  }
}
