// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';
import 'package:glamify_app_me/models/review_cart_model.dart';
import 'package:glamify_app_me/providers/review_cart_provider.dart';
import 'package:glamify_app_me/screens/check_out/delivery_details/delivery_details.dart';
import 'package:glamify_app_me/screens/home/home_screen.dart';
import 'package:glamify_app_me/widgets/single_item.dart';
import 'package:provider/provider.dart';

class ReviewCart extends StatelessWidget {
  late ReviewCartProvider reviewCartProvider;
  showAlertDialog(BuildContext context, ReviewCartModel delete) {
    // set up the buttons
    Widget cancelButton = MaterialButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = MaterialButton(
      child: Text("Yes"),
      onPressed: () {
        reviewCartProvider.reviewCartDataDelete(delete.cartId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cart Product"),
      content: Text("Are you devete on cartProduct?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String? paymentMethod;
  String? paymentStatus;
  int? cartQuantity;

  @override
  Widget build(BuildContext context) {
    reviewCartProvider = Provider.of<ReviewCartProvider>(context);
    reviewCartProvider.getReviewCartData();
    return Scaffold(
      backgroundColor: colorFFFFFF,
      bottomNavigationBar: ListTile(
        title: Text(
          "Total Amount",
          style: TextStyle(color: appbarclr),
        ),
        subtitle: Text(
          rupees + reviewCartProvider.getTotalPrice().toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.green[900],
          ),
        ),
        trailing: reviewCartProvider.getReviewCartDataList.isEmpty
            ? Container(
                width: 190,
                child: MaterialButton(
                  color: appbarclr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  onPressed: () {
                    Get.off(HomeScreen());
                  },
                  child: Text(
                    "Buy Product",
                    style: TextStyle(color: colorFFFFFF),
                  ),
                ),
              )
            : Container(
                //  width: 190,
                child: MaterialButton(
                  color: appbarclr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                  ),
                  onPressed: () {
                    if (reviewCartProvider.getReviewCartDataList.isEmpty) {
                      // return Fluttertoast.showToast(msg: "No Cart Data Found");
                      // return Center(child: Text('No Cart Data Found'));
                    }
                    Get.off(DeliveryDetails());
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => DeliveryDetails(),
                    //   ),
                    // );
                  },
                  child: Text(
                    "Proceed to Buy (" +
                        reviewCartProvider.getReviewCartDataList.length
                            .toString() +
                        " item)",
                    style: TextStyle(color: colorFFFFFF),
                  ),
                ),
              ),
      ),
      appBar: AppBar(
        backgroundColor: appbarclr,
        title: Text(
          "Add To Cart",
          style: TextStyle(color: colorFFFFFF, fontSize: 18),
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
      body: reviewCartProvider.getReviewCartDataList.isEmpty
          ? Center(
              child: Text("NO DATA"),
            )
          : ListView.builder(
              itemCount: reviewCartProvider.getReviewCartDataList.length,
              itemBuilder: (context, index) {
                ReviewCartModel data =
                    reviewCartProvider.getReviewCartDataList[index];
                cartQuantity = data.cartQuantity;
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SingleItem(
                      isBool: true,
                      wishList: false,
                      productImage: data.cartImage,
                      productName: data.cartName,
                      productPrice: data.cartPrice,
                      productId: data.cartId,
                      productQuantity: data.cartQuantity,
                      paymentMethod: data.paymentMethod,
                      paymentStatus: data.paymentStatus,
                      deliveryStatus: data.deliveryStatus,
                      userName: data.userName,
                      userEmail: data.userEmail,
                      onDelete: () {
                        showAlertDialog(context, data);
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
