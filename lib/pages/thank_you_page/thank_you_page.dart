import 'package:flutter/material.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/app_icon.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/small_text.dart';

class ThankYou extends StatelessWidget {
  ThankYou({Key? key, required this.paymentMethod}) : super(key: key);

  final String paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width30),
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Dimensions.bottomHeightBar120*2,
                width: Dimensions.bottomHeightBar120*2,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(Dimensions.bottomHeightBar120),
                  ),
                child: Icon( paymentMethod == 'cash' ? Icons.attach_money : Icons.credit_card,size: Dimensions.bottomHeightBar120,color: Colors.white,),
              ),
              SizedBox(
                height: Dimensions.height45*2,
              ),
              Container(
                child: Column(
                  children: [
                    BigText(text: 'Thank You!',color: Colors.green,size: Dimensions.font20*2),
                    BigText(text: 'Order was Successfully',color: Colors.black,size: Dimensions.font20),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.height45*2,
              ),
              Align(
                alignment: Alignment.center,
                  child: SmallText(
                      text: "You will be redirected to the home page",
                      size: Dimensions.font15,
                      color: AppColors.paraColor
                  )
              ),
              Align(
                  alignment: Alignment.center,
                  child: SmallText(
                      text: "by click on the home button",
                      size: Dimensions.font15,
                      color: AppColors.paraColor
                  )
              ),
              SizedBox(
                height: Dimensions.height45*2,
              ),
              SizedBox(
                width: double.infinity,
                height: Dimensions.height45*2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  key: const Key("Home"),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false),
                  child: BigText(text: 'Home',color: Colors.white,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
