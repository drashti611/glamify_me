import 'package:flutter/material.dart';

import '../../../config/colors.dart';

class SingleDeliveryItem extends StatelessWidget {
  final String title;
  final String address;
  final String number;
  final String addressType;
  SingleDeliveryItem(
      {required this.title,
      required this.addressType,
      required this.address,
      required this.number});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: appbarclr, fontWeight: FontWeight.w600),
              ),
              Container(
                width: 60,
                padding: EdgeInsets.all(1),
                height: 30,
                decoration: BoxDecoration(
                    color: appbarclr, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    addressType,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorFFFFFF,
                    ),
                  ),
                ),
              ),
            ],
          ),
          leading: CircleAvatar(
            radius: 8,
            backgroundColor: appbarclr,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: TextStyle(color: appbarclr, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                number,
                style: TextStyle(color: appbarclr, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Divider(
          height: 35,
        ),
      ],
    );
  }
}
