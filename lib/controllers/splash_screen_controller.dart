import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../pages/login/login.dart';

class SplashScreenControllerNew extends GetxController {

  static SplashScreenControllerNew get find => Get.find();
  final KeepMe = GetStorage();

  startSplashScreen(context) async {
    await Future.delayed(const Duration(seconds: 3));
    print("object");
    if (!KeepMe.read('KeepMeLogin') &&  KeepMe.read('KeepMeLogin') != null)
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    else
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }
}