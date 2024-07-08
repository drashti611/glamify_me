// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';

import 'package:glamify_app_me/config/common_text_field.dart';
import 'package:glamify_app_me/config/text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  late String email;

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      const snackBar = SnackBar(
        content: Text('Password Reset Link Sent! Check Your Email...'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'invalid-email':
          message = 'The email you entered was invalid';
          break;
        case 'user-disabled':
          message = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          message = 'The user you tried to log into was not found';
          break;
        default:
          message = 'Enter Email';
          break;
      }

      print(message);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      // appBar: AppBar(
      //   toolbarHeight: 50,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Get.back();
      //     },
      //     child: Image.asset('assets/icons/ArrowLeft.png'),
      //   ),
      //   backgroundColor: colorFFFFFF,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/forpass.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 310, left: 0, right: 0),
                    child: Center(
                      child: Container(
                        height: 330,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.shade400.withOpacity(0.5),
                              offset: Offset(1, 0),
                              blurRadius: 6,
                              spreadRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 68, 46, 38),
                                  // fontFamily: "LibreBaskerville",
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 100,
                                width: 270,
                                color: Color.fromARGB(130, 200, 163, 127),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Enter your email address \n assocation with your account",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      // color: Color.fromARGB(255, 68, 46, 38),
                                      // fontFamily: "LibreBaskerville",
                                      fontSize: 15,

                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              commonTextField(
                                icons: Icons.person,
                                suggestionTxt: enterMail,
                                controller: emailController,
                                action: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Email Field Must Not Be Empty';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      passwordReset();
                                    }
                                  },
                                  height: 50,
                                  minWidth: 220,
                                  color: Colors.brown.shade500,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Reset Password',
                                            style: TextStyle(
                                              letterSpacing: 5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // Text(
                  //   forgot,
                  //   style: color000000w90022.copyWith(
                  //       fontWeight: FontWeight.bold, fontSize: 35),
                  // ),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // commonTextField(
                  //   icons: Icons.person,
                  //   suggestionTxt: enterMail,
                  //   controller: emailController,
                  //   action: TextInputAction.next,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Please Email Field Must Not Be Empty';
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   onChanged: (value) {
                  //     email = value;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: commonButton(
                  //     onPressed: () {
                  //       if (_formKey.currentState != null &&
                  //           _formKey.currentState!.validate()) {
                  //         passwordReset();
                  //       }
                  //     },
                  //     child: Center(
                  //       child: _isLoading
                  //           ? CircularProgressIndicator(
                  //               color: Colors.white,
                  //             )
                  //           : Text(
                  //               'Reset Password',
                  //               style: TextStyle(
                  //                 letterSpacing: 5,
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize: 19,
                  //               ),
                  //             ),
                  //     ),
                  //     buttonColor: color5254A8,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: Form(
      //       key: _formKey,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           const SizedBox(
      //             height: 25,
      //           ),
      //           Text(
      //             forGet,
      //             style: color000000w90022.copyWith(
      //                 fontWeight: FontWeight.bold, fontSize: 35),
      //           ),
      //           const SizedBox(
      //             height: 40,
      //           ),
      //           const Text(
      //               'Enter Your Email and we will send you a password reset link...',
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                 fontSize: 20
      //               ),
      //           ).paddingOnly(top: 50),
      //           _TextFieldPassword(
      //             label: 'Email',
      //             controller: emailController,
      //             keyboardType: TextInputType.emailAddress,
      //             validator: _requiredValidator,
      //           ).paddingOnly(top: 20),
      //           Container(
      //             width: MediaQuery.of(context).size.width,
      //             height: 50,
      //             margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(90),
      //             ),
      //             child: ElevatedButton(
      //               onPressed: (){
      //                 if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      //                   passwordReset();
      //                 }
      //               },
      //               style: ButtonStyle(
      //                 backgroundColor: MaterialStateProperty.resolveWith((states) {
      //                   if (states.contains(MaterialState.pressed)) {
      //                     return Colors.black26;
      //                   }
      //                   return Theme.of(context).primaryColor;
      //                 }),
      //                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      //                   RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(30),
      //                   ),
      //                 ),
      //               ),
      //               child: const Text(
      //                 'Reset Password',
      //                 style: TextStyle(
      //                   color: colorFFFFFF,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 16,
      //                 ),
      //               ),
      //             ),
      //           ).paddingOnly(top: 40),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
