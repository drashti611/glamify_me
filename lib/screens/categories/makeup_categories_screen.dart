// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/screens/product_overview/product_overview.dart';
import 'package:provider/provider.dart';

import '../../config/text.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/wishlist_provider.dart';

class MakeupCategoriesScreen extends StatefulWidget {
  const MakeupCategoriesScreen({super.key});

  @override
  State<MakeupCategoriesScreen> createState() => _MakeupCategoriesScreenState();
}

class _MakeupCategoriesScreenState extends State<MakeupCategoriesScreen> {
  @override
  void initState() {
    _fetchUser();
    // TODO: implement initState
    super.initState();
  }

  final Stream<QuerySnapshot> _chairCategorieStream = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Makeup')
      .snapshots();
  bool isSortingAscending = true;
  String? userName;
  String? userEmail;
  void _showSortOptions() {
    showModalBottomSheet(
      //  ` elevation: 10,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sort By:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Low to High'),
                leading: Radio(
                  activeColor: Color.fromARGB(255, 77, 49, 49),
                  value: true,
                  groupValue: isSortingAscending,
                  onChanged: (value) {
                    setState(() {
                      isSortingAscending = value as bool;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('High to Low'),
                leading: Radio(
                  activeColor: Color.fromARGB(255, 77, 49, 49),
                  value: false,
                  groupValue: isSortingAscending,
                  onChanged: (value) {
                    setState(() {
                      isSortingAscending = value as bool;
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  late ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    WishListProvider wishListProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "Make Up",
          style: TextStyle(
            fontSize: 18,
            color: colorFFFFFF,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chairCategorieStream,
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
          if (snapshot.hasData) {
            final List<DocumentSnapshot>? documnets = snapshot.data?.docs;
            documnets?.sort((a, b) {
              double priceA = double.parse(a["productPrice"].toString());
              double priceB = double.parse(b["productPrice"].toString());
              return isSortingAscending
                  ? priceA.compareTo(priceB)
                  : priceB.compareTo(priceA);
            });
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 221, 221),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "All the makeup product",
                              style: TextStyle(
                                  color: appbarclr,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: _showSortOptions,
                              icon: Icon(
                                Icons.sort,
                                color: appbarclr,
                                weight: 100,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: documnets!.length,
                      itemBuilder: (context, index) {
                        final firebaseUser = FirebaseAuth.instance.currentUser;
                        // final productData = snapshot.data!.docs[index];
                        // final List<DocumentSnapshot>? documnets =
                        //     snapshot.data?.docs;
                        // documnets?.sort((a, b) {
                        //   double priceA = double.parse(a["price"].toString());
                        //   double priceB = double.parse(b["price"].toString());
                        //   return isSortingAscending
                        //       ? priceA.compareTo(priceB)
                        //       : priceB.compareTo(priceA);
                        // });
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: documnets![index]['productID'],
                                productImage: documnets![index]['image'],
                                productName: documnets![index]['productName'],
                                productPrice: documnets![index]['productPrice'],
                                productDetail: documnets![index]
                                    ['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Container(
                              width: 180,
                              height: 130,
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
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          documnets![index]['image'],
                                          fit: BoxFit.fill,
                                          height: 150,
                                          width: 150,
                                        ).paddingOnly(top: 10, bottom: 10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          documnets![index]['productName'],
                                          style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Color(0xFF000000),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')
                                              .copyWith(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ).paddingOnly(left: 20),
                                      ),
                                      Text(
                                        rupees +
                                            ' ' +
                                            documnets![index]['productPrice']
                                                .toString(),
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
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  _fetchUser() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection("buyers")
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        userName = ds.data()!['fullName'];
        userEmail = ds.data()!['email'];
        print(userName);
        print(userEmail);
      }).catchError((e) {
        print(e);
      });
  }
}

void _openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200, // Adjust the height of the bottom sheet as needed
        child: Center(
          child: Text('This is the bottom sheet.'),
        ),
      );
    },
  );
}
