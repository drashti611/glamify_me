// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/auth/login_screen.dart';
import 'package:glamify_app_me/auth/register_screen.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/providers/user_provider.dart';
import 'package:glamify_app_me/screens/home/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late UserProvider userProvider;

  bool _isLoading = false;
  void _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'email': googleSignInAccount.email,
        'fullName': googleSignInAccount.displayName,
        'phoneNumber': '',
        'googleId': googleSignInAccount.id,
        'buyerId': FirebaseAuth.instance.currentUser!.uid,
        'address': '',
        'profile': googleSignInAccount.photoUrl,
      });
      Get.offAll(HomeScreen());
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with google failed'),
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok'),
                  ),
                ],
              ));
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with google failed'),
                content: Text('An unknown error occurred'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Ok'),
                  ),
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/bgimg.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image.asset(
            //   'assets/icons/shadow.png',
            //   fit: BoxFit.cover,
            // ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 150, top: 90, right: 10),
                  child: Text(
                    "glow today ",
                    style: TextStyle(
                        color: Color.fromARGB(255, 68, 46, 38),
                        fontFamily: "LibreBaskerville",
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        height: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 160, top: 10, right: 10),
                  child: Text(
                    "Glow everyday",
                    style: TextStyle(
                      color: Color.fromARGB(255, 68, 46, 38),
                      fontFamily: "DancingScript",
                      fontSize: 40,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 6,
                      right: MediaQuery.of(context).size.height / 27,
                      top: MediaQuery.of(context).size.height / 1.9),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 240,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 124, 84, 69))),
                            onPressed: () {
                              Get.to(LoginScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Login with E-mail",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SignInButton(
                        Buttons.Google,
                        padding: EdgeInsets.only(left: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        text: "Sign in with Google",
                        onPressed: () async {
                          _loginWithGoogle();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Don't Have Account?",
                        style: TextStyle(
                            color: colorFFFFFF,
                            letterSpacing: 2,
                            wordSpacing: 2),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(RegisterScreen());
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 124, 84, 69),
                              fontWeight: FontWeight.bold),
                        ),
                      ).paddingOnly(left: 10),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         fit: BoxFit.cover, image: AssetImage('assets/images/background.png')),
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Container(
      //         height: 400,
      //         width: double.infinity,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             Text('Sign in to continue'),
      //             Text(
      //               'Reflex',
      //               style:
      //               TextStyle(fontSize: 50, color: Colors.white, shadows: [
      //                 BoxShadow(
      //                   blurRadius: 5,
      //                   color: Colors.green.shade900,
      //                   offset: Offset(3, 3),
      //                 )
      //               ]),
      //             ),
      //             Column(
      //               children: [
      //                 SignInButton(
      //                   Buttons.Email,
      //                   text: "Sign in with Email",
      //                   onPressed: () {
      //                     Get.to(Login());
      //                   },
      //                 ),
      //                 SignInButton(
      //                   Buttons.Google,
      //                   text: "Sign in with Google",
      //                   onPressed: () async {
      //                     _loginWithGoogle();
      //                   },
      //                 ),
      //               ],
      //             ),
      //             Column(
      //               children: [
      //                 Text(
      //                   'By signing in you are agreeing to our',
      //                   style: TextStyle(
      //                     color: Colors.grey[800],
      //                   ),
      //                 ),
      //                 Text(
      //                   'Terms and Privacy Policy',
      //                   style: TextStyle(
      //                     color: Colors.grey[800],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
