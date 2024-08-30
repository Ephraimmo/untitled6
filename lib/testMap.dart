import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/pages/accept_order/accept_order.dart';
import 'package:untitled6/test2.dart';
import 'package:untitled6/utils/colors.dart';

class HomeD extends StatefulWidget {
  const HomeD({Key? key}) : super(key: key);

  @override
  State<HomeD> createState() => _HomeDState();
}

class _HomeDState extends State<HomeD> {
  int selecter = 0;
  final pages = [
    Center(child: Text('User profile')),
    Order(),
    Center(child: Text('completed Order Page'),)
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[selecter],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.mainColor,
        color: AppColors.mainColor,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.person,color: Colors.white),
            label: 'Profle',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Roboto",
            ),
          ),

          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_basket_outlined,color: Colors.white),
            label: 'Order',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Roboto",
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.shopping_cart_outlined,color: Colors.white),
            label: 'map',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Roboto",
            ),
          ),
        ],
        onTap: (index) {
          // Handle button tap
          setState(() {
            selecter = index;
          });
        },
      ),
    );
  }
}
