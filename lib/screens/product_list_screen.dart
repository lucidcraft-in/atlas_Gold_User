import 'package:flutter/material.dart';

import '../screens/productView.dart';
import '../providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListScreen extends StatefulWidget {
  static const routeName = '/product-screen';
  ProductListScreen({Key? key, this.category}) : super(key: key);
  String? category;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isSelect = true;
  var selectItem = [];
  Stream? products;
  String branchName = "";
  Product? db;
  List userList = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('product');

  Stream? _queryDb() {
    products = FirebaseFirestore.instance
        .collection('product')
        .where("category", isEqualTo: CategoryName)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) => doc.data()),
        );
    return null;
  }

  String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String? CategoryName;
  initialise() {
    setState(() {
      CategoryName = widget.category;
    });

    db = Product();
    db!.initiliase();
    db!.read(CategoryName!).then((value) => {
          setState(() {
            userList = value != null ? value : userList;
          }),
          // print("---------------------"),
        });
  }

  @override
  void initState() {
    _queryDb();
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3c0139),
          title: const Text(
            'Products',
          ),
        ),
        body: userList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.98),
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // print(userList[index]['branch']);
                    if (userList[index]['branch'] == 0) {
                      branchName = "Alathur";
                    } else if (userList[index]['branch'] == 1) {
                      branchName = "Chittur";
                    } else if (userList[index]['branch'] == 2) {
                      branchName = "Vadakkencherri";
                    }
                    // print(branchName);

                    return userList != null
                        ? GestureDetector(
                            onTap: () {
                              // print(userList[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SwapableProductView(
                                            category: CategoryName!,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 229, 221, 229),
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .18,
                                      image: NetworkImage(
                                          userList[index]["photo"]),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ));
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Text('Error loading image');
                                      },
                                    ),

                                    //  Image.network(
                                    //   userList[index]["photo"],
                                    //   fit: BoxFit.contain,
                                    //   height:
                                    //       MediaQuery.of(context).size.height *
                                    //           .18,
                                    // ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Flexible(
                                      child: Text(
                                        userList[index]['productName'] != null
                                            ? capitalizeAllWord(
                                                userList[index]['productName'],
                                              )
                                            : userList[index]['productName'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                    //   },
                    // );
                  },
                ),
              )
            : Center(
                child: Text("No data found it this category...."),
              ));
  }
}
