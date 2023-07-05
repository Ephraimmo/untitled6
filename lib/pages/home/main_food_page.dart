import 'package:flutter/material.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/pages/product/product_page_body.dart';
import 'package:untitled6/widgets/small_text.dart';

class MainProductPage extends StatefulWidget {
  const MainProductPage({Key? key}) : super(key: key);

  @override
  State<MainProductPage> createState() => _MainProductPageState();
}

class _MainProductPageState extends State<MainProductPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height15,bottom: Dimensions.height15),
              padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(text: 'Kasi Monate App',color: AppColors.mainColor),
                      Row(
                        children: [
                          SmallText(text: "Monate o teng...",color: Colors.black54),
                          Icon(Icons.arrow_drop_down_rounded,size: Dimensions.iconSize24,)
                        ],
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      width: Dimensions.height45*2,
                      height: Dimensions.height45*2,
                      child: Icon(Icons.search,color: Colors.white,size: Dimensions.iconSize24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius15/2),
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: ProductPageBody()),)
        ],
      )
    ));
  }
}


