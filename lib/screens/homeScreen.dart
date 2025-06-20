import 'dart:convert';
import 'package:atlas_gold_user/common/colo_extension.dart';
import 'package:atlas_gold_user/providers/banner.dart';
import 'package:atlas_gold_user/providers/category.dart';
import 'package:atlas_gold_user/providers/goldrate.dart';
import 'package:atlas_gold_user/providers/product.dart';
import 'package:atlas_gold_user/screens/product_list_screen.dart';
import 'package:atlas_gold_user/widgets/categoryItem.dart';
import 'package:atlas_gold_user/widgets/productItem.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen2 extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  bool _checkValue = false;

  Goldrate? db;
  List goldrateList = [];
  double pavanrate = 0;
  String golddate = "";
  String goldTime = "";
  double gramRate = 0;
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
      print("-------");

      setState(() {
        goldrateList = value!;
        pavanrate = goldrateList[0]['pavan'];
        goldTime = goldrateList[0]['updateTime'];
        golddate = goldrateList[0]['updateDate'];
        gramRate = goldrateList[0]['gram'];
        eighteenGram = goldrateList[0]['18gram'];
      });
    });
  }

  double eighteenGram = 0;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(fontSize: 14, color: TColo.primaryColor2),
              ),
              if (_userName != "")
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                                  category: category['name'],
                                                )));
                                  },
                                  child: CategoryItem(title: category['name'])))
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
                                height:
                                    MediaQuery.of(context).size.height * .25,
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
                            height: MediaQuery.of(context).size.height * .25,
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
                  // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF8E1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.trending_up_rounded,
                                color: Color(0xFFFF8F00),
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Live Gold Rates",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Real-time pricing",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "LIVE",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF10B981),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // 22K Gold Section
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "22K",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF8F00).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "GOLD",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF8F00),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              // 1 Gram Rate
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Per Gram",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "₹${gramRate.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              // 8 Gram Rate
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "8 Grams",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "₹${pavanrate.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // 18K Gold Section
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "18K",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF8B5CF6).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "GOLD",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8B5CF6),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Per Gram",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "₹${eighteenGram.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1F2937),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24),

                        // Update Time Footer
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: Color(0xFF6B7280),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Last updated: $goldTime • $golddate",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Auto-refresh",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Top Picks',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                productList.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          return ProductItem(
                              title: productList[index]['productCode'],
                              price: '${productList[index]['gram']}');
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
        ));
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.containsKey("user")) {
      String? userData = pref.getString("user");

      if (userData != null) {
        Map<String, dynamic> user = json.decode(userData);
        setState(() {
          _userName = user['name'] ?? '';
        });
      }
    } else {
      setState(() {
        _userName = '';
      });
    }
  }
}
