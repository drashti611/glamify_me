// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:glamify_app_me/config/colors.dart';
import 'package:glamify_app_me/config/text.dart';

import '../product_overview/product_overview.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? userName;
  String? userEmail;
  TextEditingController search = TextEditingController();

  Stream<QuerySnapshot>? _stream;

  List searchResult = [];

  void searchForCategory(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('products')
        .orderBy("productName")
        // where(
        //   'productCategory',
        //   isEqualTo: query.toLowerCase(),
        // )
        // .where('productName', isEqualTo: query)
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFFFFFF,
      appBar: AppBar(
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: search,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search Here ...",
              ),
              onChanged: (query) {
                searchForCategory(search.text);
              },
            ).paddingAll(15),
            StreamBuilder<QuerySnapshot>(
              stream: _stream,
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

                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          log("ERoooooooooooooooooooooo$searchResult");
                          Get.to(ProductOverview(
                            productId: searchResult[index]['productID'],
                            productImage: searchResult[index]['image'],
                            productName: searchResult[index]['productName'],
                            productPrice: searchResult[index]['productPrice'],
                            productDetail: searchResult[index]['productDetail'],
                            userName: '',
                            UserEmail: '',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 10,
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
                            child: ListTile(
                              leading: Image.network(
                                searchResult[index]['image'],
                                fit: BoxFit.fill,
                              ),
                              title: Text(
                                searchResult[index]['productName'],
                                style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins')
                                    .copyWith(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              subtitle: Text(
                                rupees +
                                    searchResult[index]['productPrice']
                                        .toString(),
                                style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins')
                                    .copyWith(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ).paddingOnly(left: 10);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDataScreen extends StatefulWidget {
  const FilterDataScreen({super.key});

  @override
  State<FilterDataScreen> createState() => _FilterDataScreenState();
}

class _FilterDataScreenState extends State<FilterDataScreen> {
  TextEditingController _searchController = TextEditingController();
  List _allList = [];
  List _resultList = [];

  getData() async {
    var data = await FirebaseFirestore.instance
        .collection("products")
        .orderBy("productName")
        .get();

    setState(() {
      _allList = data.docs;
    });
    resultList();
  }

  resultList() {
    var showrs = [];
    if (_searchController.text.isNotEmpty) {
      for (var element in _allList) {
        var name = element['productName'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showrs.add(element);
        }
      }
    } else {
      showrs = List.from(_allList);
    }
    setState(() {
      _resultList = showrs;
    });
  }

  @override
  void initState() {
    getData();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    log(":" + _searchController.text);
    resultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appbarclr,
        elevation: 0.0,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white),
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: "Search Here ...",
            ),
          ).paddingAll(15),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              scrollDirection: Axis.vertical,
              itemCount: _resultList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    log("ERoooooooooooooooooooooo$_resultList");
                    Get.to(ProductOverview(
                      productId: _resultList[index]['productID'],
                      productImage: _resultList[index]['image'],
                      productName: _resultList[index]['productName'],
                      productPrice: _resultList[index]['productPrice'],
                      productDetail: _resultList[index]['productDetail'],
                      userName: '',
                      UserEmail: '',
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 10, bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 10,
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
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          _resultList[index]['image'],
                          fit: BoxFit.fill,
                        ),
                        title: Text(
                          _resultList[index]['productName'],
                          style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Color(0xFF000000),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins')
                              .copyWith(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          rupees +
                              _resultList[index]['productPrice'].toString(),
                          style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins')
                              .copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ).paddingOnly(left: 10);
              },
            ),
          ),
        ],
      ),
    );
  }
}
