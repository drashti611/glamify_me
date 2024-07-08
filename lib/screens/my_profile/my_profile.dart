// ignore_for_file: prefer_const_constructors, must_be_immutable, curly_braces_in_flow_control_structures, override_on_non_overriding_member, sized_box_for_whitespace, unused_local_variable, use_key_in_widget_constructors, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/auth/sign_in.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text_style.dart';
import 'package:glamify_app_me/providers/user_provider.dart';
import 'package:glamify_app_me/screens/check_out/delivery_details/delivery_address.dart';
import 'package:glamify_app_me/screens/my_profile/about.dart';
import 'package:glamify_app_me/screens/my_profile/edit_profile_page.dart';
import 'package:glamify_app_me/screens/my_profile/privacy_policy.dart';
import 'package:glamify_app_me/screens/new_features/my_order.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyProfile extends StatefulWidget {
  UserProvider userProvider;
  MyProfile({required this.userProvider});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? myEmail;
  String? myName;
  String? myProfile;

  @override
  Widget listTile({IconData? icon, String? title}) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(icon),
          title: Text(title!),
          trailing: Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;

    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "My Profile",
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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 100,
                color: colorFFFFFF,
              ),
              Container(
                height: 548,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: appbarclr.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: colorCCCCCC,
                    width: 2,
                  ),
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: _fetch(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done)
                              return Text(
                                'Loading Data...Please Wait',
                                style: colorFFFFFFw80024,
                              ).paddingOnly(top: 30);
                            // return Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       myName!,
                            //       style: colorFFFFFFw80024.copyWith(fontSize: 22,color: color000000),
                            //     ).paddingOnly(top: 30),
                            //     Text(
                            //       myEmail!,
                            //       style: colorFFFFFFw50016.copyWith(fontSize: 15,color: color000000),
                            //     ).paddingOnly(top: 20),
                            //   ],
                            // );

                            return Container(
                              width: 250,
                              height: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        myName!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: appbarclr),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        myEmail!,
                                        style: TextStyle(color: appbarclr),
                                      ),
                                    ],
                                  ),
                                  // CircleAvatar(
                                  //   radius: 15,
                                  //   backgroundColor: colorCCCCCC,
                                  //   child: CircleAvatar(
                                  //     radius: 12,
                                  //     child: GestureDetector(
                                  //       child: Icon(
                                  //         Icons.edit,
                                  //         color: colorCCCCCC,
                                  //         size: 20,
                                  //       ),
                                  //       onTap: () {},
                                  //     ),
                                  //     backgroundColor: colorFFFFFF,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                        // Container(
                        //   width: 250,
                        //   height: 80,
                        //   padding: EdgeInsets.only(left: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             userData?.userName ?? '',
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: textColor),
                        //           ),
                        //           SizedBox(
                        //             height: 10,
                        //           ),
                        //           Text(userData?.userEmail ?? ''),
                        //         ],
                        //       ),
                        //       CircleAvatar(
                        //         radius: 15,
                        //         backgroundColor: colorCCCCCC,
                        //         child: CircleAvatar(
                        //           radius: 12,
                        //           child: GestureDetector(
                        //             child: Icon(
                        //               Icons.edit,
                        //               color: colorCCCCCC,
                        //               size: 20,
                        //             ),
                        //             onTap: (){},
                        //           ),
                        //           backgroundColor: colorFFFFFF,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.edit, color: appbarclr),
                          title: Text(
                            'Edit Profile',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Get.to(EditProfilePage());
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.shop_outlined, color: appbarclr),
                          title: Text(
                            'My Orders',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Get.to(MyOrder());
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.location_on_outlined,
                              color: appbarclr),
                          title: Text(
                            'My Delivery Address',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Get.to(DeliveryAddress());
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.file_copy_outlined, color: appbarclr),
                          title: Text(
                            'Terms & Conditions',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Fluttertoast.showToast(
                              msg: 'Comming Soon...',
                            );
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.policy_outlined, color: appbarclr),
                          title: Text(
                            'Privacy Policy',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Get.to(PrivacyPolicy());
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.person_outline, color: appbarclr),
                          title: Text(
                            'Refer A Friends',
                            style: TextStyle(color: appbarclr),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Fluttertoast.showToast(msg: 'Comming Soon...');
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.add_chart, color: appbarclr),
                          title:
                              Text('About', style: TextStyle(color: appbarclr)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () {
                            Get.to(About());
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.exit_to_app_outlined,
                              color: appbarclr),
                          title: Text('Log Out',
                              style: TextStyle(color: appbarclr)),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: appbarclr),
                          onTap: () async {
                            Get.offAll(SignIn());
                            FirebaseAuth.instance.signOut();
                            await GoogleSignIn(scopes: ['email']).signOut();
                            print('User is currently signed out!');
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30),
            child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ).paddingOnly(top: 20),
                  );
                return CircleAvatar(
                  backgroundImage: myProfile == null || myProfile == ''
                      ? AssetImage('assets/icons/accountrb.png')
                          as ImageProvider
                      : NetworkImage(myProfile!),
                  backgroundColor: color5254A8,
                  radius: 50,
                );
              },
            ),
          ),
        ],
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
