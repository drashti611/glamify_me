// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, prefer_final_fields, unused_field, curly_braces_in_flow_control_structures, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';
import 'package:glamify_app_me/providers/product_provider.dart';
import 'package:glamify_app_me/providers/user_provider.dart';
import 'package:glamify_app_me/screens/categories/Hair_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/fragrences_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/nailcare_categories_screen.dart';
import 'package:glamify_app_me/screens/categories/skincare_categories_screen.dart';

import 'package:glamify_app_me/screens/home/drawer_side.dart';
import 'package:glamify_app_me/screens/home/search_screen.dart';
import 'package:glamify_app_me/screens/product_overview/product_overview.dart';
import 'package:glamify_app_me/screens/review_cart/review_cart.dart';
import 'package:glamify_app_me/widgets/banner_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/wishlist_provider.dart';
import '../categories/makeup_categories_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductProvider productProvider;

  String? userName;
  String? userEmail;

  final Stream<QuerySnapshot> _bannerStream =
      FirebaseFirestore.instance.collection('banners').snapshots();

  final List _bannerImage = [];
  getBanners() {
    return FirebaseFirestore.instance.collection('banners').get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          setState(() {
            _bannerImage.add(doc['image']);
          });
        });
      },
    );
  }

  String selectedItemIdMake = '';
  String selectedItemIdHair = '';
  String selectedItemIdSkin = '';
  String selectedItemIdFrag = '';
  String selectedItemIdNail = '';
  // bool wishListBool = false;
  bool wishListBoolHair = false;
  bool wishListBoolSkin = false;
  bool wishListBoolNail = false;
  bool wishListBoolFrag = false;
  PageController bannercontroller = PageController();
  final Stream<QuerySnapshot> _makeup = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Makeup')
      .snapshots();
  final Stream<QuerySnapshot> _haircare = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Haircare')
      .snapshots();
  final Stream<QuerySnapshot> _skincare = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Skincare')
      .snapshots();
  final Stream<QuerySnapshot> _fragrences = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Fragrences')
      .snapshots();
  final Stream<QuerySnapshot> _nailcare = FirebaseFirestore.instance
      .collection('products')
      .where('productCategory', isEqualTo: 'Nailcare')
      .snapshots();
  // final Stream<QuerySnapshot> _sofaStream = FirebaseFirestore.instance
  //     .collection('products')
  //     .where('productCategory', isEqualTo: 'Sofa')
  //     .snapshots();
  // final Stream<QuerySnapshot> _wardrobesStream = FirebaseFirestore.instance
  //     .collection('products')
  //     .where('productCategory', isEqualTo: 'Wardrobes')
  //     .snapshots();

  TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;

  // final Stream<QuerySnapshot> _reviewStream = FirebaseFirestore.instance
  //     .collection('Ratings')
  //     .doc(FirebaseAuth.instance.currentUser?.uid)
  //     .collection('Reviews')
  //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //     .snapshots();

  // getWishtListBool() {
  //   FirebaseFirestore.instance
  //       .collection("WishList")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("YourWishList")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((value) => {
  //             if (this.mounted)
  //               {
  //                 if (value.exists)
  //                   {
  //                     setState(
  //                       () {
  //                         wishListBool = value.get("wishList");
  //                       },
  //                     ),
  //                   }
  //               }
  //           });
  // }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  List<String> selectedProductIds = [];
  List<String> selectedProductHair = [];
  List<String> selectedProductSkin = [];
  List<String> selectedProductFrag = [];
  List<String> selectedProductNail = [];

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of(context);
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    WishListProvider wishListProvider = Provider.of(context);
    // getWishtListBool();
    return Scaffold(
      backgroundColor: colorFFFFFF,
      drawer: DrawerSide(
        userProvider: userProvider,
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 77, 49, 49),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 246, 202, 202)),
        title: FutureBuilder(
          future: _fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 246, 202, 202))
                    .paddingOnly(top: 20),
              );
            return Text(
              'Hello, ' + userName!,
              style: TextStyle(
                  color: Color.fromARGB(255, 246, 202, 202), fontSize: 17),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              color: textColor,
              onPressed: () {
                Get.to(FilterDataScreen());

                // Get.to(SearchScreen());
              },
              icon: Icon(
                Icons.search_rounded,
                color: Color.fromARGB(255, 246, 202, 202),
                size: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              color: textColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReviewCart(),
                  ),
                );
              },
              icon: Icon(
                Icons.card_travel,
                color: Color.fromARGB(255, 246, 202, 202),
                size: 25,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/icons/collectionBg.png'),
              ),
              color: Color.fromARGB(255, 157, 120, 120),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 130, bottom: 10),
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 155, 92, 91),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Glamify\n    Me',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromARGB(255, 73, 48, 48),
                                  shadows: [
                                    BoxShadow(
                                        color: const Color.fromARGB(
                                            255, 204, 194, 191),
                                        blurRadius: 5,
                                        offset: Offset(3, 3))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '10% Off',
                          style: TextStyle(
                              fontSize: 40,
                              color: Color.fromARGB(255, 78, 15, 15),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'On all Beuty products',
                            style: TextStyle(
                              color: color000000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('Collections',
                    style: TextStyle(
                      color: Color.fromARGB(255, 68, 46, 38),
                      fontFamily: "LibreBaskerville",
                      fontSize: 15,
                      // decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    )).paddingSymmetric(vertical: 20).paddingOnly(bottom: 15),
              ),
              BannerWidget().paddingAll(15),
            ],
          ),

          ////1.MakeUp
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Makeup',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 46, 38),
                          fontFamily: "LibreBaskerville",
                          fontSize: 15,
                          // decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(MakeupCategoriesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: appbarclr,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _makeup,
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
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.builder(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: productData['productID'],
                                productImage: productData['image'],
                                productName: productData['productName'],
                                productPrice: productData['productPrice'],
                                productDetail: productData['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
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
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 160,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15)),
                                            child: Image.network(
                                              productData['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedProductIds
                                                      .contains(productData[
                                                          'productID'])) {
                                                    // If the product ID is already in the list, remove it
                                                    selectedProductIds.remove(
                                                        productData[
                                                            'productID']);
                                                  } else {
                                                    // If the product ID is not in the list, add it
                                                    selectedProductIds.add(
                                                        productData[
                                                            'productID']);
                                                  }
                                                });

                                                // Update wishlist based on selectedProductIds list
                                                if (selectedProductIds.contains(
                                                    productData['productID'])) {
                                                  wishListProvider
                                                      .addWishListData(
                                                    wishListId: productData[
                                                        'productID'],
                                                    wishListImage:
                                                        productData['image'],
                                                    wishListName: productData[
                                                        'productName'],
                                                    wishListPrice: productData[
                                                        'productPrice'],
                                                    wishListQuantity: 2,
                                                  );
                                                } else {
                                                  wishListProvider
                                                      .wishlistDataDelete(
                                                          productData[
                                                              'productID']);
                                                }
                                              },
                                              icon: Icon(
                                                selectedProductIds.contains(
                                                        productData[
                                                            'productID'])
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 20,
                                                color: appbarclr,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              productData['productName'],
                                              style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 77, 49, 49),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins')
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ).paddingOnly(top: 10),
                                          ),
                                          Text(
                                            rupees +
                                                productData['productPrice']
                                                    .toString(),
                                            style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 77, 49, 49),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins')
                                                .copyWith(fontSize: 18),
                                          ).paddingOnly(top: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 10),
                              ),
                            ),
                          ).paddingOnly(left: 10);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // 2. 'Haircare'
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Haircare',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 46, 38),
                          fontFamily: "LibreBaskerville",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(HairCategoriesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            color: appbarclr,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _haircare,
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
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.builder(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: productData['productID'],
                                productImage: productData['image'],
                                productName: productData['productName'],
                                productPrice: productData['productPrice'],
                                productDetail: productData['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
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
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 160,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15)),
                                            child: Image.network(
                                              productData['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedProductHair
                                                      .contains(productData[
                                                          'productID'])) {
                                                    // If the product ID is already in the list, remove it
                                                    selectedProductHair.remove(
                                                        productData[
                                                            'productID']);
                                                  } else {
                                                    // If the product ID is not in the list, add it
                                                    selectedProductHair.add(
                                                        productData[
                                                            'productID']);
                                                  }
                                                });

                                                // Update wishlist based on selectedProductIds list
                                                if (selectedProductHair
                                                    .contains(productData[
                                                        'productID'])) {
                                                  wishListProvider
                                                      .addWishListData(
                                                    wishListId: productData[
                                                        'productID'],
                                                    wishListImage:
                                                        productData['image'],
                                                    wishListName: productData[
                                                        'productName'],
                                                    wishListPrice: productData[
                                                        'productPrice'],
                                                    wishListQuantity: 2,
                                                  );
                                                } else {
                                                  wishListProvider
                                                      .wishlistDataDelete(
                                                          productData[
                                                              'productID']);
                                                }
                                              },
                                              icon: Icon(
                                                selectedProductHair.contains(
                                                        productData[
                                                            'productID'])
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 20,
                                                color: appbarclr,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              productData['productName'],
                                              style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 77, 49, 49),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins')
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ).paddingOnly(top: 10),
                                          ),
                                          Text(
                                            rupees +
                                                productData['productPrice']
                                                    .toString(),
                                            style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 77, 49, 49),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins')
                                                .copyWith(fontSize: 18),
                                          ).paddingOnly(top: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 10),
                              ),
                            ),
                          ).paddingOnly(left: 10);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          ///3.Skincare
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Skincare',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 46, 38),
                          fontFamily: "LibreBaskerville",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SkinCategoriesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            color: appbarclr,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _skincare,
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
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.builder(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: productData['productID'],
                                productImage: productData['image'],
                                productName: productData['productName'],
                                productPrice: productData['productPrice'],
                                productDetail: productData['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
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
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 160,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15)),
                                            child: Image.network(
                                              productData['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedProductSkin
                                                      .contains(productData[
                                                          'productID'])) {
                                                    // If the product ID is already in the list, remove it
                                                    selectedProductSkin.remove(
                                                        productData[
                                                            'productID']);
                                                  } else {
                                                    // If the product ID is not in the list, add it
                                                    selectedProductSkin.add(
                                                        productData[
                                                            'productID']);
                                                  }
                                                });

                                                // Update wishlist based on selectedProductIds list
                                                if (selectedProductSkin
                                                    .contains(productData[
                                                        'productID'])) {
                                                  wishListProvider
                                                      .addWishListData(
                                                    wishListId: productData[
                                                        'productID'],
                                                    wishListImage:
                                                        productData['image'],
                                                    wishListName: productData[
                                                        'productName'],
                                                    wishListPrice: productData[
                                                        'productPrice'],
                                                    wishListQuantity: 2,
                                                  );
                                                } else {
                                                  wishListProvider
                                                      .wishlistDataDelete(
                                                          productData[
                                                              'productID']);
                                                }
                                              },
                                              icon: Icon(
                                                selectedProductSkin.contains(
                                                        productData[
                                                            'productID'])
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 20,
                                                color: appbarclr,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              productData['productName'],
                                              style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 77, 49, 49),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins')
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ).paddingOnly(top: 10),
                                          ),
                                          Text(
                                            rupees +
                                                productData['productPrice']
                                                    .toString(),
                                            style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 77, 49, 49),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins')
                                                .copyWith(fontSize: 18),
                                          ).paddingOnly(top: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 10),
                              ),
                            ),
                          ).paddingOnly(left: 10);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          ///4.Fragrences
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Fragrences',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 46, 38),
                          fontFamily: "LibreBaskerville",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(FragrencesCategoriesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            color: appbarclr,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _fragrences,
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
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.builder(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: productData['productID'],
                                productImage: productData['image'],
                                productName: productData['productName'],
                                productPrice: productData['productPrice'],
                                productDetail: productData['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
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
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 160,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15)),
                                            child: Image.network(
                                              productData['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedProductFrag
                                                      .contains(productData[
                                                          'productID'])) {
                                                    // If the product ID is already in the list, remove it
                                                    selectedProductFrag.remove(
                                                        productData[
                                                            'productID']);
                                                  } else {
                                                    // If the product ID is not in the list, add it
                                                    selectedProductFrag.add(
                                                        productData[
                                                            'productID']);
                                                  }
                                                });

                                                // Update wishlist based on selectedProductIds list
                                                if (selectedProductFrag
                                                    .contains(productData[
                                                        'productID'])) {
                                                  wishListProvider
                                                      .addWishListData(
                                                    wishListId: productData[
                                                        'productID'],
                                                    wishListImage:
                                                        productData['image'],
                                                    wishListName: productData[
                                                        'productName'],
                                                    wishListPrice: productData[
                                                        'productPrice'],
                                                    wishListQuantity: 2,
                                                  );
                                                } else {
                                                  wishListProvider
                                                      .wishlistDataDelete(
                                                          productData[
                                                              'productID']);
                                                }
                                              },
                                              icon: Icon(
                                                selectedProductFrag.contains(
                                                        productData[
                                                            'productID'])
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 20,
                                                color: appbarclr,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              productData['productName'],
                                              style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 77, 49, 49),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins')
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ).paddingOnly(top: 10),
                                          ),
                                          Text(
                                            rupees +
                                                productData['productPrice']
                                                    .toString(),
                                            style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 77, 49, 49),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins')
                                                .copyWith(fontSize: 18),
                                          ).paddingOnly(top: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 10),
                              ),
                            ),
                          ).paddingOnly(left: 10);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          ///5.Nailcare
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Nailcare',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 46, 38),
                          fontFamily: "LibreBaskerville",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(NailcareCategoriesScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'view all',
                          style: TextStyle(
                            color: appbarclr,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _nailcare,
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
                      height: MediaQuery.of(context).size.height / 3.2,
                      child: ListView.builder(
                        // padding: const EdgeInsets.symmetric(horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final productData = snapshot.data!.docs[index];
                          final firebaseUser =
                              FirebaseAuth.instance.currentUser;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductOverview(
                                productId: productData['productID'],
                                productImage: productData['image'],
                                productName: productData['productName'],
                                productPrice: productData['productPrice'],
                                productDetail: productData['productDetail'],
                                userName: userName!,
                                UserEmail: userEmail!,
                              ));
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width / 2,
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
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            width: 160,
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15)),
                                            child: Image.network(
                                              productData['image'],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (selectedProductNail
                                                      .contains(productData[
                                                          'productID'])) {
                                                    // If the product ID is already in the list, remove it
                                                    selectedProductNail.remove(
                                                        productData[
                                                            'productID']);
                                                  } else {
                                                    // If the product ID is not in the list, add it
                                                    selectedProductNail.add(
                                                        productData[
                                                            'productID']);
                                                  }
                                                });

                                                // Update wishlist based on selectedProductIds list
                                                if (selectedProductNail
                                                    .contains(productData[
                                                        'productID'])) {
                                                  wishListProvider
                                                      .addWishListData(
                                                    wishListId: productData[
                                                        'productID'],
                                                    wishListImage:
                                                        productData['image'],
                                                    wishListName: productData[
                                                        'productName'],
                                                    wishListPrice: productData[
                                                        'productPrice'],
                                                    wishListQuantity: 2,
                                                  );
                                                } else {
                                                  wishListProvider
                                                      .wishlistDataDelete(
                                                          productData[
                                                              'productID']);
                                                }
                                              },
                                              icon: Icon(
                                                selectedProductNail.contains(
                                                        productData[
                                                            'productID'])
                                                    ? Icons.favorite
                                                    : Icons.favorite_outline,
                                                size: 20,
                                                color: appbarclr,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              productData['productName'],
                                              style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Color.fromARGB(
                                                          255, 77, 49, 49),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Poppins')
                                                  .copyWith(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ).paddingOnly(top: 10),
                                          ),
                                          Text(
                                            rupees +
                                                productData['productPrice']
                                                    .toString(),
                                            style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 77, 49, 49),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Poppins')
                                                .copyWith(fontSize: 18),
                                          ).paddingOnly(top: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingOnly(top: 10),
                              ),
                            ),
                          ).paddingOnly(left: 10);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
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
