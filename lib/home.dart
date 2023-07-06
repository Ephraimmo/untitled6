import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/pages/cart_product_details/cart_product_details.dart';
import 'package:untitled6/pages/home/main_food_page.dart';
import 'package:untitled6/pages/order_page/order_page.dart';
import 'package:untitled6/pages/payment/payment.dart';
import 'package:untitled6/pages/user_profile/user_profile.dart';
import 'package:untitled6/utils/colors.dart';
import 'controllers/order_controller.dart';
import 'controllers/product_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectPage = 0;
  List pages = [
    MainProductPage(),
    OrderPage(),
    CartProductsDetails(),
    UserProfile(),
  ];

  final CartProducController cartProducController = Get.put(CartProducController());
  final OrderController orderController = Get.put(OrderController());
  final KeepMe = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectPage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.mainColor,
        color: AppColors.mainColor,
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined,color: Colors.white),
            label: 'Home',
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
            label: 'Cart',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: "Roboto",
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity,color: Colors.white),
            label: 'Personal',
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
            _selectPage = index;
            cartProducController.hideBackBuutonCart.value = index;
            orderController.tabSelector.value = 0;
          });
        },
      ),
    );
  }
}
