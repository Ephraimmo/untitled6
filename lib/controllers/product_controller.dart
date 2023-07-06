import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/utils/colors.dart';

import '../models/produt.dart';

class CartProducController extends GetxController {
  // Add a dict to store the products in the cart.
  var productTotal = 0.obs;
  var hideBackBuutonCart = 0.obs;
  var product = <Product>[].obs;
  final userInformation = GetStorage();

  selectOrders(String productName, bool value){
    FirebaseDatabase.instance.ref('${userInformation.read('Usernumbers')}/$productName').update({
      'orderChecked' : !value,
    });
  }

  increment(int number,String productName){
    if (number != 10) {
      FirebaseDatabase.instance.ref("${userInformation.read('Usernumbers')}").child(productName).update({
        'number' : number,
      });
    }
    else {
      Get.snackbar(
        'Danger',
        "you order more than 10 items",
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.dangerous, color: Colors.white),
      );
    }
  }

  decrement(int number,String productName){
    if (number != 0) {
      FirebaseDatabase.instance.ref("${userInformation.read('Usernumbers')}").child(productName).update({
        'number' : number,
      });
    }else if (number == 0){
      FirebaseDatabase.instance.ref("${userInformation.read('Usernumbers')}").child(productName).remove();
      Get.snackbar(
        'Removed',
        "The product was removed from cart list",
        colorText: Colors.white,
        backgroundColor: AppColors.mainColor,
        icon: const Icon(Icons.delete_forever, color: Colors.red),
      );
    }
  }

  updateTotal(){
    var Ref = FirebaseDatabase.instance.ref('${userInformation.read('Usernumbers')}').onValue.listen((event) {
      print("event.snapshot.value");
      productTotal.value = 0;
      Map? mydata = event.snapshot.value as Map?;
      mydata!.values.forEach((element) {
        int price = element['price'] * element['number'];
        productTotal.value = productTotal.value + price;
      });
    });
  }
}