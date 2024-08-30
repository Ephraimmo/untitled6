
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/utils/colors.dart';
import '../models/produt.dart';

class CartController extends GetxController {
  // Add a dict to store the products in the cart.
  var cartProductCounter = 0.obs;
  var cartProductTotal   = 0.obs;
  var removePrice = 0.obs;
  var addingTocart = 0.obs;
  var checkList = [].obs;
  var activeImageSlider = 0.obs;
  final userInformation = GetStorage();



  var cart = 0.obs;

  updateCart(){
    var Ref = FirebaseDatabase.instance.ref('${userInformation.read('Usernumbers')}').onValue.listen((event) {
      cart.value = 0;
      checkList.clear();
      Map? mydata = event.snapshot.value as Map?;
      mydata!.values.forEach((element) {
        cart.value += int.parse(element['number'].toString());
        checkList.add(element['productName']);
      });
    });
  }



  addToCart(String brancheName,productName, int price,String imageUrl){


    //generating a order number
    //var orderNumber = random(0,999999);
    addingTocart.value = 1;

    print('object2');

    DatabaseReference ref = FirebaseDatabase.instance.ref('${userInformation.read('Usernumbers')}/$productName');

    checkList.forEach((element) {
      print(element);
    });

    if (!checkList.contains(productName))
      {
        ref.set({
          'branche'    : brancheName,
          'productName': productName,
          'number' : cartProductCounter.value,
          "price"  : price,
          "imageUrl"  : imageUrl,
          "orderChecked" : true,
        }).then((value){
          addingTocart.value = 0;
          //Get.snackbar(
          //  'Added',
          //  'The product was successfully added to your cart wish list.',
          //  //"You'r trying to add a product that already exist on the cart wish list, ",
          //  colorText: Colors.white,
          //  backgroundColor: AppColors.mainColor,
          //  icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
          //);
        }).onError((error, stackTrace) {
          addingTocart.value = 0;
          Get.snackbar(
            'Danger',
            "you product was not added to cart",
            colorText: Colors.white,
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.dangerous, color: Colors.white),
          );
        });
      }
    else{
      ref.update({'number' : cartProductCounter.value,}).then((value){
        addingTocart.value = 0;
        Get.snackbar(
          'Updated',
          "The product was already added to cart successfully and quantity was updated",
          colorText: Colors.white,
          backgroundColor: AppColors.mainColor,
          icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
        );
      }).onError((error, stackTrace) {
        addingTocart.value = 0;
        Get.snackbar(
          'Updated',
          "The product was already added to cart successfully",
          colorText: Colors.white,
          backgroundColor: AppColors.mainColor,
          icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
        );
      });

    }

  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  setValue(int price){
    cartProductCounter.value = 1;
    cartProductTotal.value = price;
  }


  increment(int price){
    if (cartProductCounter != 10) {
      cartProductCounter.value++;
      cartProductTotal.value = cartProductCounter.value * price;
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

  decrement(int price){
    if (cartProductCounter != 1) {
      cartProductCounter.value--;
      cartProductTotal.value = cartProductCounter.value * price;
    }else{
      cartProductTotal.value = cartProductCounter.value * price;
    }
  }
}