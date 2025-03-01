import 'dart:convert';

import 'package:atlas_gold_user/common/colo_extension.dart';
import 'package:atlas_gold_user/providers/banner.dart';
import 'package:atlas_gold_user/providers/category.dart';
import 'package:atlas_gold_user/providers/goldrate.dart';
import 'package:atlas_gold_user/providers/product.dart';
import 'package:atlas_gold_user/screens/product_list_screen.dart';
import 'package:atlas_gold_user/screens/profile.dart';
import 'package:atlas_gold_user/screens/transaction_screen.dart';
import 'package:atlas_gold_user/widgets/BannerWidget.dart';
import 'package:atlas_gold_user/widgets/categoryItem.dart';
import 'package:atlas_gold_user/widgets/productItem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen2 extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  int _selectedIndex = 0;

  List pages = [
    HomeScreen2(),
    TransactionScreen(),
    ProfileScreen(),
  ];
  bool _checkValue = false;

  Goldrate? db;
  List goldrateList = [];
  double pavanrate = 0;
  String golddate = "";
  String goldTime = "";
  String _userName = "";
  List categoryList = [];
  List productList = [];
  List banner = [];

  @override
  void initState() {
    super.initState();
    getUser();
    getCategory();
    getGoldrate();
    getProduct();
    getSlider();
  }

  getCategory() {
    Provider.of<Category>(context, listen: false).getCategory().then((onValue) {
      setState(() {
        categoryList = onValue;
      });
    });
  }

  getGoldrate() {
    Provider.of<Goldrate>(context, listen: false).read().then((value) {
      setState(() {
        goldrateList = value!;
        pavanrate = goldrateList[0]['pavan'];
        goldTime = goldrateList[0]['updateTime'];
        golddate = goldrateList[0]['updateDate'];
      });
    });
  }

  getProduct() {
    Provider.of<Product>(context, listen: false).getProduct().then((onValue) {
      setState(() {
        productList = onValue ?? [];
      });
    }).catchError((error) {
      print('Error fetching products: $error');
      setState(() {
        productList = []; // Fallback to empty list on error
      });
    });
  }

  List imgList = [];

  getSlider() {
    Provider.of<BannerProvider>(context, listen: false)
        .getSlide('Banner')
        .then((onvalue) {
      print(onvalue);
      setState(() {
        banner = onvalue;
        imgList = onvalue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(fontSize: 14, color: TColo.primaryColor2),
            ),
            Text(
              _userName,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColo.primaryColor2),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: TColo.primaryColor2),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: TColo.primaryColor2, // Replace with a valid color
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    categoryList.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: categoryList
                                  .map((category) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductListScreen(
                                                      category:
                                                          category['name'],
                                                    )));
                                      },
                                      child: CategoryItem(
                                          title: category['name'])))
                                  .toList(),
                              // CategoryItem(title: 'Fashion Jewellery'),
                              // CategoryItem(title: 'Traditional Jewellery'),
                              // CategoryItem(title: 'Designer Jewellery'),
                              // CategoryItem(title: 'Bridal Jewellery'),
                            ),
                          )
                        : Center(child: Text("No categories available")),
                    SizedBox(height: 20),
                    banner.isNotEmpty
                        ? imgList.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height *
                                        .25,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1.0,
                                  ),
                                  items: imgList.map((img) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(img["photo"]!),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bannerImg.jpeg"), // Replace with your image path
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                        : Text('No banners available'),

                    SizedBox(height: 16),

                    // Gold Rate Display
                    Container(
                      height: MediaQuery.of(context).size.height * .11,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xFFF5F1F1),
                                image: DecorationImage(
                                  image: AssetImage("assets/icons/statrs.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: MediaQuery.of(context).size.height * .11,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Gold Rate | 22K"),
                                    Row(
                                      children: [
                                        Text(
                                          pavanrate.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Color.fromARGB(
                                                255, 152, 38, 30),
                                          ),
                                        ),
                                        Text(" (8 gram)"),
                                      ],
                                    ),
                                    Text(
                                      "Updated at ${goldTime} on ${golddate}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 142, 139, 139),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Top Picks',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    productList.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              return ProductItem(
                                  title: productList[index]['productCode'],
                                  price: 'Rs. ${productList[index]['gram']}');
                            },
                          )
                        : Text('No products available'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //         child: ProductItem(
                    //             title: 'Party Wear Earrings',
                    //             price: 'Rs. 500')),
                    //     Expanded(
                    //         child: ProductItem(
                    //             title: 'Designer Bangle Sets',
                    //             price: 'Rs. 500')),
                    //   ],
                    // ),
                  ],
                ),
              ),
            )
          : pages[_selectedIndex],
    );
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      String? userData = pref.getString("user");

      if (userData != null) {
        Map<String, dynamic> user = json.decode(userData);
        setState(() {
          _userName = user['name'] ?? 'Maria';
        });
      }
    } else {
      setState(() {
        _userName = '';
      });
    }
  }
}
