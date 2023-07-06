import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/small_text.dart';

import '../../controllers/splash_screen_controller.dart';
import '../login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashScreenControllerNew = Get.put(SplashScreenControllerNew());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    splashScreenControllerNew.startSplashScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        color: AppColors.mainColor,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/54350-online-shopping-delivery.json'),
                SmallText(text: "Welcome to the one and only",color: AppColors.titleColor,size: Dimensions.font20,),
                SmallText(text: "KASI MONATE APP",color: AppColors.titleColor,size: Dimensions.font26,),
              ],
            )
        ),
      ),
    );
  }
}

