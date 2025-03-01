import 'package:atlas_gold_user/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import '../common/colo_extension.dart';
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
  int selectedNavBarIndex = 0;

  List<Widget> screens = [HomeScreen2(), TransactionScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color navBarBackgroundColor = screens.length == 4
        ? const Color.fromARGB(255, 255, 255, 255)
        : Colors.white;
    return Scaffold(
      body: screens[selectedNavBarIndex],
      extendBody: true, //<------like this
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navBarBackgroundColor, // Set background color to white
        showSelectedLabels: true,
        selectedItemColor: TColo.primaryColor1, // Selected item color
        unselectedItemColor:
            Color.fromARGB(255, 189, 189, 189), // Unselected item color
        selectedLabelStyle: TextStyle(
          color: TColo.primaryColor1,
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          color: Color.fromARGB(255, 189, 189, 189),
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        currentIndex: selectedNavBarIndex,
        onTap: (index) {
          setState(() {
            selectedNavBarIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 189, 189, 189),
            ),
            activeIcon: Icon(
              Icons.home,
              color: TColo.primaryColor1,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.aod_outlined,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
              activeIcon: Icon(
                Icons.aod,
                color: TColo.primaryColor1,
              ),
              label: "Transaction"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Color.fromARGB(255, 189, 189, 189),
              ),
              activeIcon: Icon(
                Icons.settings,
                color: TColo.primaryColor1,
              ),
              label: "Profile"),

          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.assignment_ind_outlined,
          //       color: Color.fromARGB(255, 189, 189, 189),
          //     ),
          //     activeIcon:
          //         Icon(Icons.assignment_ind, color: TColo.primaryColor1),
          //     label: "Profile"),
        ],
      ),
    );
  }
}
