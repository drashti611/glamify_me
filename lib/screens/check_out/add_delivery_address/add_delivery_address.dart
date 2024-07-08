// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/providers/check_out_provider.dart';
import 'package:glamify_app_me/widgets/custome_text_field.dart';
import 'package:provider/provider.dart';

class AddDeliverAddress extends StatefulWidget {
  @override
  _AddDeliverAddressState createState() => _AddDeliverAddressState();
}

enum AddressTypes {
  Home,
  Work,
  Other,
}

class _AddDeliverAddressState extends State<AddDeliverAddress> {
  var myType = AddressTypes.Home;
  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        title: Text(
          "Add Delivery Address",
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 48,
        child: checkoutProvider.isloadding == false
            ? MaterialButton(
                onPressed: () {
                  checkoutProvider.validator(context, myType);
                },
                child: Text(
                  "Add Address",
                  style: TextStyle(
                    color: colorFFFFFF,
                  ),
                ),
                color: appbarclr,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListView(
          children: [
            CostomTextField(
              labText: "First name",
              controller: checkoutProvider.firstName,
              keyboardType: TextInputType.name,
            ),
            CostomTextField(
              labText: "Last name",
              controller: checkoutProvider.lastName,
              keyboardType: TextInputType.name,
            ),
            CostomTextField(
              labText: "Mobile No",
              controller: checkoutProvider.mobileNo,
              keyboardType: TextInputType.number,
            ),
            CostomTextField(
              labText: "Alternate Mobile No",
              controller: checkoutProvider.alternateMobileNo,
              keyboardType: TextInputType.number,
            ),
            CostomTextField(
              labText: "Scoiety",
              controller: checkoutProvider.scoiety,
              keyboardType: TextInputType.text,
            ),
            CostomTextField(
              labText: "Street",
              controller: checkoutProvider.street,
              keyboardType: TextInputType.text,
            ),
            CostomTextField(
              labText: "Landmark",
              controller: checkoutProvider.landmark,
              keyboardType: TextInputType.text,
            ),
            CostomTextField(
              labText: "City",
              controller: checkoutProvider.city,
              keyboardType: TextInputType.text,
            ),
            CostomTextField(
              labText: "Area",
              controller: checkoutProvider.aera,
              keyboardType: TextInputType.streetAddress,
            ),
            CostomTextField(
              labText: "Pincode",
              controller: checkoutProvider.pincode,
              keyboardType: TextInputType.number,
            ),
            ListTile(
              title: Text("Address Type*"),
            ),
            RadioListTile(
              fillColor: MaterialStateColor.resolveWith((states) => appbarclr),
              value: AddressTypes.Home,
              groupValue: myType,
              title: Text(
                "Home",
                style: TextStyle(color: appbarclr),
              ),
              onChanged: (value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: Icon(
                Icons.home_outlined,
                color: appbarclr,
              ),
            ),
            RadioListTile(
              value: AddressTypes.Work,
              groupValue: myType,
              title: Text(
                "Work",
                style: TextStyle(color: appbarclr),
              ),
              onChanged: (value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: Icon(
                Icons.work_outline_outlined,
                color: appbarclr,
              ),
            ),
            RadioListTile(
              value: AddressTypes.Other,
              groupValue: myType,
              title: Text(
                "Other",
                style: TextStyle(color: appbarclr),
              ),
              onChanged: (value) {
                setState(() {
                  myType = value!;
                });
              },
              secondary: Icon(
                Icons.devices_other_outlined,
                color: appbarclr,
              ),
            )
          ],
        ),
      ),
    );
  }
}
