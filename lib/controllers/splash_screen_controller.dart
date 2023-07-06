import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../pages/login/login.dart';

class SplashScreenControllerNew extends GetxController {

  static SplashScreenControllerNew get find => Get.find();
  final KeepMe = GetStorage();

  startSplashScreen(context) async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(const Login(), transition: Transition.fadeIn);
    if (!KeepMe.read('KeepMeLogin'))
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    else
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }
}