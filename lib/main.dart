import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/pages/Signup/phone.dart';
import 'package:untitled6/pages/Signup/verify.dart';
import 'package:untitled6/pages/accept_order/accept_order.dart';
import 'package:untitled6/pages/splash_screen/splash_screen.dart';
import 'package:untitled6/pages/thank_you_page/thank_you_page.dart';
import 'package:untitled6/test2.dart';
import 'package:untitled6/testMap.dart';
import 'home.dart';
import 'pages/cart_product_details/cart_product_details.dart';
import 'pages/login/login.dart';
import 'package:untitled6/helper/dependencies.dart' as dep;

import 'pages/payment/payment.dart';
import 'pages/user_profile/user_profile.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51NMSvDAd90R6y6g69QWrbnDFnWTbU2x5Zb6Wistfy5kzG5nbOyejdzi1tht2nxNa0ilgjdnCMzdiDjhhYrCyVoXd00v7MlEB7H';
  final KeepMe = GetStorage();
  await dep.init();

  runApp(GetMaterialApp(
    initialRoute: 'login',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone'          : (context) => const MyPhone(),
      'SplashScreen'   : (context) => const SplashScreen(),
      'verify'         : (context) => const MyVerify(),
      'login'          : (context) => const Login(),
      'home'           : (context) => const HomePage(),
      'cart'           : (context) => CartProductsDetails(),
    },
  ));
}
