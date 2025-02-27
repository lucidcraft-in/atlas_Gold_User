import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:empty_widget/empty_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/transaction.dart';

class TransactionList extends StatefulWidget {
  static const routeName = "/transaction_list";

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var selectedIndex = -1;
  bool isClick = false;
  var user;
  Transaction? db;
  List transactionList = [];
  double customerBalance = 0;
  double totalGram = 0;
  List alllist = [];
  initialise() {
    db = Transaction();

    db!.initiliase();

    db!.read(user['id']).then((value) {
      print(value);
      setState(() {
        alllist = value!;
        transactionList = alllist[0];
        customerBalance = alllist[1];
        totalGram = alllist[2];
      });
      print(transactionList);
      // print("user"),
      // print(transactionList),
    });
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = jsonDecode(prefs.getString('user')!);

    await initialise();
    // user = prefs.containsKey('user');
  }

  int _expandedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: transactionList.length > 0
          ? ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DateTime myDateTime = (transactionList[index]['date']).toDate();
                bool isExpanded = index == _expandedIndex;
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 35,
                      color: Colors.grey.shade300,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat.yMMMd()
                                // .add_jm()
                                .format(myDateTime)
                                .toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    SizedBox(height: 3),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_expandedIndex == index) {
                            _expandedIndex = -1; // Collapse if tapped again
                          } else {
                            _expandedIndex = index; // Expand new item
                          }
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height * .1,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(41, 154, 106, 156),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: transactionList[index]
                                                    ['transactionType'] ==
                                                0
                                            ? Color(0xFFdbdfde)
                                            : Color.fromARGB(
                                                255, 247, 216, 210),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Icon(
                                      transactionList[index]
                                                  ['transactionType'] ==
                                              0
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: transactionList[index]
                                                  ['transactionType'] ==
                                              0
                                          ? Color(0xFF69948f)
                                          : Color(0xFFb84d3f),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${transactionList[index]['note']}"
                                                    .toUpperCase()),
                                            Text(
                                              transactionList[index]
                                                          ['transactionMode'] ==
                                                      "online"
                                                  ? "Online Payment"
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "latto",
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      221, 47, 144, 37)),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 80,
                                          child: Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons
                                                    .indianRupeeSign,
                                                size: 14,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "${transactionList[index]['amount'].toString()}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                transactionList[index]['transactionMode'] ==
                                        "online"
                                    ? "Transaction Id : ${transactionList[index]['merchentTransactionId']}"
                                    : "",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "latto",
                                    color: Color.fromARGB(221, 41, 42, 41)),
                              ),
                              // if (isExpanded)
                              //   Container(
                              //     width: double.infinity,
                              //     margin: EdgeInsets.only(top: 8),
                              //     padding: EdgeInsets.all(8),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           "Gram Price  : ${transactionList[index]['gramPriceInvestDay'].toString()}",
                              //           style: TextStyle(fontSize: 14),
                              //         ),
                              //         Text(
                              //           "Gram Weight  :  ${transactionList[index]['gramWeight'].toString()}",
                              //           style: TextStyle(fontSize: 14),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: transactionList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 5);
              },
            )
          : Center(
              child: Text("No Transaction available yet"),
              // child: EmptyWidget(
              //   image: null,
              //   packageImage: PackageImage.Image_1,
              //   title: 'No data found',
              //   subTitle: 'No  transaction available yet',
              //   titleTextStyle: TextStyle(
              //     fontSize: 22,
              //     color: Color(0xff9da9c7),
              //     fontWeight: FontWeight.w500,
              //   ),
              //   subtitleTextStyle: TextStyle(
              //     fontSize: 14,
              //     color: Color(0xffabb8d6),
              //   ),
              // ),
            ),
    );
  }
}
