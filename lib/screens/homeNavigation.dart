import 'package:atlas_gold_user/screens/homeScreen.dart';
import 'package:atlas_gold_user/screens/home_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashBoard.dart';
import 'profile.dart';
import 'transaction_screen.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation>
    with TickerProviderStateMixin {
  var _selectedTab = _SelectedTab.home;
  var selectIndex = 0;
  void _handleIndexChanged(int i) {
    // print(i);
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      selectIndex = i;
    });
  }

  bool checkValue = false;

  var user;
  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkValue = prefs.containsKey('user');
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
    return Scaffold(
      // body: Container(
      //   child: Image.asset("lib/img/1.png"),
      // ),
      body: PageView.builder(
          // controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                // onTap: () {
                //   pageController.jumpToPage(index); // for regular jump
                //   // pageController.animateToPage(_position,
                //   //     curve: Curves.decelerate,
                //   //     duration: Duration(
                //   //         milliseconds:
                //   //             300)); // for animated jump. Requires a curve and a duration
                // },
                child: pages[selectIndex]);
          }),
      extendBody: true, //<------like this
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: EdgeInsets.only(left: 10, right: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 50,
          // enableFloatingNavBar: false,
          onTap: _handleIndexChanged,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              unselectedColor: Colors.blueGrey,
              selectedColor: Theme.of(context).primaryColor,
            ),

            /// Likes
            // if (checkValue == true)
            DotNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              unselectedColor: Colors.blueGrey,
              selectedColor: Theme.of(context).primaryColor,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: Icon(Icons.person),
              unselectedColor: Colors.blueGrey,
              selectedColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  List pages = [
    HomeScreen2(),
    // GoogleMapScreen(place: "Kakkodi"),
    TransactionScreen(),
    ProfileScreen()
  ];
}

enum _SelectedTab { home, favorite, search, person }
