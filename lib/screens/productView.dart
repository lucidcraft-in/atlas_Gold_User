import 'package:flutter/material.dart';
import '../providers/product.dart';

class SwapableProductView extends StatefulWidget {
  SwapableProductView({Key? key, this.category}) : super(key: key);
  String? category;

  @override
  State<SwapableProductView> createState() => _SwapableProductViewState();
}

class _SwapableProductViewState extends State<SwapableProductView> {
  var categoryName;
  List productList = [];
  String branchName = "";
  Future getCategory() async {
    setState(() {
      categoryName = widget.category;
    });
    // print(categoryName);
    var db = Product();
    db.initiliase();
    db.read(categoryName).then((value) => {
          setState(() {
            productList = value!;
          })
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3c0139),
          title: Text("${categoryName}".toUpperCase()),
        ),
        body: PageView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: NetworkImage(productList[index]["photo"]),
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * .7,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     Text(
                            //       " Product Name :    ",
                            //       style: TextStyle(
                            //           fontSize: 15,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //     Text(
                            //       productList[index]["productName"],
                            //       style: TextStyle(
                            //           fontSize: 15,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Code :      ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  productList[index]["productCode"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Description :    ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(productList[index]["description"]),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Weight :      ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  productList[index]["gram"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
