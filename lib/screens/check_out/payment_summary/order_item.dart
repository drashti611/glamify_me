// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/text.dart';
import 'package:glamify_app_me/models/review_cart_model.dart';
import 'package:glamify_app_me/providers/review_cart_provider.dart';

class OrderItem extends StatelessWidget {
  final ReviewCartModel e;
  late ReviewCartProvider reviewCartProvider;
  OrderItem({required this.e});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        e.cartImage,
        width: 60,
      ),
      title: Text(e.cartName),
      subtitle: Text(e.cartQuantity.toString()),
      trailing: Text(rupees + e.cartPrice.toString()),
    ).paddingOnly(bottom: 10, top: 10);
  }
}
