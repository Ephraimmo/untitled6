
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/utils/colors.dart';
import '../models/produt.dart';

class OrderController extends GetxController {
  // Add a dict to store the products in the cart.
  var tabSelector = 0.obs;

  changeTabOrderselector(int value){
    tabSelector.value = value;
  }

}