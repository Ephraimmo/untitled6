import 'package:get/get.dart';
import '../pages/login/login.dart';

class SplashScreenControllerNew extends GetxController {

  static SplashScreenControllerNew get find => Get.find();

  startSplashScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(const Login(), transition: Transition.fadeIn);
  }
}