// ignore_for_file: sort_child_properties_last, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';
import 'package:glamify_app_me/providers/review_cart_provider.dart';
import 'package:glamify_app_me/screens/check_out/payment_summary/order_item.dart';
import 'package:provider/provider.dart';

class Invoice extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String customerEmail;
  final double totalAmount;
  final double totalPrice;
  final double shippingCharge;
  final double discountPrice;

  Invoice({
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.totalAmount,
    required this.totalPrice,
    required this.shippingCharge,
    required this.discountPrice,
  });

  @override
  Widget build(BuildContext context) {
    ReviewCartProvider reviewCartProvider = Provider.of(context);
    reviewCartProvider.getReviewCartData();
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        title: Text(
          'Invoice Summary',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: color5254A8,
                  radius: 50,
                ),
              ),
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  color: appbarclr,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(top: 10),
              SizedBox(height: 10),
              Text(
                'Invoice ID: $orderId',
                style: TextStyle(
                  color: appbarclr,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Customer Name: $customerName',
                style: TextStyle(
                  color: appbarclr,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Customer Email: $customerEmail',
                style: TextStyle(
                  color: appbarclr,
                ),
              ),
              SizedBox(height: 20),
              ExpansionTile(
                initiallyExpanded: true,
                children: reviewCartProvider.getReviewCartDataList.map(
                  (e) {
                    return OrderItem(
                      e: e,
                    );
                  },
                ).toList(),
                title: Text(
                  "Order Items ${reviewCartProvider.getReviewCartDataList.length}",
                  style: TextStyle(
                    fontSize: 20,
                    color: appbarclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              ListTile(
                minVerticalPadding: 5,
                leading: Text(
                  "Sub Total",
                  style: TextStyle(
                    color: appbarclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  rupees + totalPrice.toString(),
                  style: TextStyle(
                    color: appbarclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                minVerticalPadding: 5,
                leading: Text(
                  "Shipping Charge",
                  style: TextStyle(
                    color: appbarclr,
                  ),
                ),
                trailing: Text(
                  rupees + shippingCharge.toString(),
                  style: TextStyle(
                    color: appbarclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                minVerticalPadding: 5,
                leading: Text(
                  "Compen Discount",
                  style: TextStyle(
                    color: appbarclr,
                  ),
                ),
                trailing: Text(
                  rupees + discountPrice.toString(),
                  style: TextStyle(
                    color: appbarclr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Add your list of items here
              SizedBox(height: 20),
              Text(
                'Total Amount: ' + rupees + '$totalAmount',
                style: TextStyle(
                  fontSize: 20,
                  color: appbarclr,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
