// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors, unused_local_variable, curly_braces_in_flow_control_structures, sized_box_for_whitespace, prefer_const_constructors, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/auth/sign_in.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text_style.dart';
import 'package:glamify_app_me/providers/user_provider.dart';
import 'package:glamify_app_me/screens/categories/categories_screen.dart';
import 'package:glamify_app_me/screens/my_profile/my_profile.dart';
import 'package:glamify_app_me/screens/new_features/my_order.dart';
import 'package:glamify_app_me/screens/review_cart/review_cart.dart';
import 'package:glamify_app_me/screens/wish_list/wish_list.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DrawerSide extends StatefulWidget {
  UserProvider userProvider;
  DrawerSide({required this.userProvider});
  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  String? myEmail;
  String? myName;
  String? myProfile;

  Widget listTile(
      {required String title,
      required IconData iconData,
      required Function onTap}) {
    return Container(
      height: 50,
      child: ListTile(
        onTap: () {},
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          title,
          style: TextStyle(color: Color.fromARGB(255, 246, 202, 202)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Drawer(
      child: Container(
        color: colorFFFFFF,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Image(
                  image: AssetImage('assets/images/draover.jpg'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 290,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: const Icon(
                          Icons.clear,
                          color: colorFFFFFF,
                          size: 30,
                        ),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ).paddingOnly(top: 20),
                    FutureBuilder(
                      future: _fetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Center(
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ).paddingOnly(top: 20),
                          );
                        return Center(
                          child: CircleAvatar(
                            backgroundImage: myProfile == null ||
                                    myProfile == ''
                                ? const AssetImage('assets/icons/accountrb.png')
                                    as ImageProvider
                                : NetworkImage(myProfile!),
                            backgroundColor: color5254A8,
                            radius: 50,
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: _fetch(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return const Text(
                            'Loading Data...Please Wait',
                            style: colorFFFFFFw80024,
                          ).paddingOnly(top: 30);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myName!,
                              style: colorFFFFFFw80024.copyWith(fontSize: 22),
                            ).paddingOnly(top: 30),
                            Text(
                              myEmail!,
                              style: colorFFFFFFw50016.copyWith(fontSize: 15),
                            ).paddingOnly(top: 20),
                          ],
                        );
                      },
                    ),
                  ],
                ).paddingAll(25),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'Home',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.home_outlined,
                      size: 28,
                    ),
                    onTap: () => Get.back(),
                  ),
                ),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'My Profile',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.person_outlined,
                      size: 28,
                    ),
                    onTap: () =>
                        Get.to(MyProfile(userProvider: widget.userProvider)),
                  ),
                ).paddingOnly(top: 25),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'My Orders',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.shop_outlined,
                      size: 28,
                    ),
                    onTap: () => Get.to(MyOrder()),
                  ),
                ).paddingOnly(top: 25),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'Categories',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.category_outlined,
                      size: 28,
                    ),
                    onTap: () => Get.to(CategoriesScreen()),
                  ),
                ).paddingOnly(top: 25),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'Review Cart',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.shop_outlined,
                      size: 28,
                    ),
                    onTap: () => Get.to(ReviewCart()),
                  ),
                ).paddingOnly(top: 25),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'Wishlist',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.favorite_outline,
                      size: 28,
                    ),
                    onTap: () => Get.to(WishLsit()),
                  ),
                ).paddingOnly(top: 25),
                // Container(
                //   height: 30,
                //   child: ListTile(
                //     title: Text(
                //       'Rating & Review',
                //       style: TextStyle(color: textColor),
                //     ),
                //     leading: Icon(
                //       Icons.star_outline,
                //       size: 28,
                //     ),
                //     onTap: () {
                //       Get.to(RatingAndReview());
                //     },
                //   ),
                // ).paddingOnly(top: 25),
                Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      'Logout',
                      style: TextStyle(color: textColor),
                    ),
                    leading: const Icon(
                      Icons.logout_outlined,
                      size: 28,
                    ),
                    onTap: () async {
                      Get.offAll(SignIn());
                      FirebaseAuth.instance.signOut();
                      await GoogleSignIn(scopes: ['email']).signOut();
                      print('User is currently signed out!');
                    },
                  ),
                ).paddingOnly(top: 25),
              ],
            ).paddingAll(25),
          ],
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
