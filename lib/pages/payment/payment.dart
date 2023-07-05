import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:untitled6/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../pick_address_location/address_save_page.dart';


class Payment extends StatefulWidget {
  final ListBracheNames;
  final double productTotal;
  Payment({Key? key,required this.ListBracheNames, required this.productTotal}) : super(key: key);

  @override State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntent;
  bool payWithCard = false;
  bool payOnDelivery = false;
  double longitude = 0;
  double latitude = 0;
  List<String> nameOfOrders = [];
  late double total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameOfOrders = widget.ListBracheNames;
    total = widget.productTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('Check out'),
            centerTitle: true,
            backgroundColor: AppColors.mainColor,
        ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(
            top: Dimensions.width30, bottom: Dimensions.width30),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('AppUsers').doc(
                '+27824815280').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              } else {
                var positionLength =snapshot.data!.get('AdderssUsed').toString().split(',').length;
                longitude = double.parse(snapshot.data!.get('AdderssUsed').toString().split(',')[positionLength - 2]);
                latitude = double.parse(snapshot.data!.get('AdderssUsed').toString().split(',')[positionLength - 1]);
                return snapshot.data!.get('AdderssUsed') == '' ? BigText(
                    text: 'Select the adderss to use for delivery')
                    :
                PhysicalModel(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height45,),
                        BigText(text: "Used Delivery Adderss"),
                        Divider(color: AppColors.mainColor,
                            indent: Dimensions.width30,
                            endIndent: Dimensions.width30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions
                                .radius20),
                          ),
                          child: Padding(padding: EdgeInsets.all(Dimensions
                              .width20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: List.generate(snapshot.data!
                                          .get('AdderssUsed')
                                          .toString()
                                          .split(',')
                                          .length - 2, (index) =>
                                          SmallText(text: '${snapshot.data!.get(
                                              'AdderssUsed').toString().split(
                                              ',')[index]},',
                                              size: Dimensions.font15,
                                              color: AppColors.paraColor),)
                                  ),),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.width20,
                                        right: Dimensions.width20),
                                    child: InkWell(
                                      onTap: () => Get.to(const AdderssView()),
                                      child: Column(
                                        children: [
                                          AppIcon(
                                              icon: Icons.location_on_outlined,
                                              backgroundColor: AppColors
                                                  .iconColor1),
                                          SmallText(text: 'Change',
                                            color: AppColors.mainColor,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: Dimensions.height20,),
                        BigText(text: "Payment Method"),
                        Divider(color: AppColors.mainColor,
                            indent: Dimensions.width30,
                            endIndent: Dimensions.width30),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                payOnDelivery = true;
                                payWithCard = false;
                              });
                            },
                            child: PhysicalModel(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  AppIcon(icon: Icons.money,
                                    iconColor: Colors.green,),
                                  SmallText(text: 'cash on delivery',
                                      size: Dimensions.font15),
                                  SizedBox(width: Dimensions.width30,),
                                  SizedBox(width: Dimensions.width30,),
                                  Checkbox(
                                      value: payOnDelivery, onChanged: (value) {
                                    setState(() {
                                      payOnDelivery = true;
                                      payWithCard = false;
                                    });
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                payWithCard = true;
                                payOnDelivery = false;
                              });
                            },
                            child: PhysicalModel(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  AppIcon(icon: Icons.credit_card,
                                      iconColor: Colors.black),
                                  SizedBox(width: 1,),
                                  SmallText(text: 'Pay with card',
                                      size: Dimensions.font15),
                                  SizedBox(width: Dimensions.width30,),
                                  SizedBox(width: Dimensions.width30,),
                                  Checkbox(
                                      value: payWithCard, onChanged: (value) {
                                    setState(() {
                                      payWithCard = true;
                                      payOnDelivery = false;
                                    });
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height20,),
                        BigText(text: "User Information"),
                        Divider(color: AppColors.mainColor,
                            indent: Dimensions.width30,
                            endIndent: Dimensions.width30),
                        Container(
                          height: 55,
                          margin: EdgeInsets.only(left: Dimensions.width30,
                              right: Dimensions.width30),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: Icon(Icons.people),
                              ),
                              const Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 33, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                    onChanged: (value) {},
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height10,),
                        Container(
                          height: 55,
                          margin: EdgeInsets.only(left: Dimensions.width30,
                              right: Dimensions.width30),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: Icon(Icons.phone_android),
                              ),
                              const Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 33, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                    onChanged: (value) {},
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "+27 82 481 5280",
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height10,),
                        Container(
                          height: 55,
                          margin: EdgeInsets.only(left: Dimensions.width30,
                              right: Dimensions.width30),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: Icon(Icons.password),
                              ),
                              const Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 33, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                    onChanged: (value) {},
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "******",
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height10),
                        Spacer(),
                      ],
                    )
                );
              }
            }

        ),
      ),
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeightBar120,
        padding: EdgeInsets.only(top: Dimensions.height30,bottom: Dimensions.height30*2,left: Dimensions.width20,right: Dimensions.width20),
        decoration: BoxDecoration(
          color: AppColors.buttonBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*2),
            topRight: Radius.circular(Dimensions.radius20*2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: Dimensions.height10/2,bottom: Dimensions.height10/2,left: Dimensions.width10,right: Dimensions.width10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BigText(text: 'Total:'),
                    SizedBox(width: Dimensions.width20,),
                    BigText(text: '\R${total}0')
                  ],
                )
            ),
            Container(
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: AppColors.mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  key: const Key("Place Order"),
                  onPressed: () async {
                    if (!payWithCard && !payOnDelivery)
                      Get.snackbar('Payment Method',
                          'Plaese choose payment method...');
                    else if (payWithCard) {
                      print('object');
                      if (latitude == 0 && longitude == 0)
                        Get.snackbar('Pickup Adderss', "The pickup adderss point was not found");
                      else{
                        await makePayment(latitude: latitude,longitude: longitude,total: total.toString().replaceAll('.', ''));
                      }
                    } else if (payOnDelivery) {
                      placeOrderOnPickup();
                    }
                  },
                  child: BigText(text: "Place Order", color: Colors
                      .white,)),
            ),
          ],
        ),
      ),
    );
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future<void> makePayment(
      {required double latitude, required double longitude, required String total}) async {
    print(total);
    try {
      paymentIntent = await createPaymentIntent('${total}0', 'ZAR');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "ZA",
          currencyCode: "ZAR",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Abhi',
              googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(latitude: latitude, longitude: longitude);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(
      {required double latitude, required double longitude}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        placeOrderOnDelivery();
      });
    } catch (e) {
      Get.snackbar('Payment Error', 'Your order was not successfully',
          backgroundColor: AppColors.mainColor);
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51NMSvDAd90R6y6g6BGGcFBOxxQGheydXf4mGfeZ1fv04c8oelik3RGcbPE7aXQpEFmiPxIpGTRivqMWHoJBNRgCb00BtYLYqVj',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  placeOrderOnPickup(){
    int orderNumber = random(1000, 999999);
    String foodList = '';
    List<String> foodUrlList = [];
    int counter = -1;
    nameOfOrders.forEach((element) async {
      counter++;
      await FirebaseDatabase.instance
          .ref('+27 82 481 5280/$element')
          .once().asStream().forEach((orders) async {
        Map? mydata = orders.snapshot.value as Map?;

        print('mydata![orderChecked]: ${mydata!['orderChecked']} ');

        if (mydata!['orderChecked']) {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          foodList +=
              ',' + mydata['productName'] + ' x ${mydata['number']}';
          foodUrlList.add(mydata['imageUrl']);
          await FirebaseDatabase.instance.ref(
              '${mydata!['branche']}/+27 82 481 5280-${orderNumber}').set({
            'Accepted delivery': false,
            'Date': date.toString().replaceAll('00:00:00.000', ''),
            'Food List': foodList,
            'Food_List_image': foodUrlList,
            'Order_number': '${orderNumber}',
            'Total': total,
            'Time': '19:16',
            'company name': mydata['branche'],
            'ready': false,
            'Placed Order': true,
            'path': '+27 82 481 5280-${orderNumber}',
            'type': 'Pickup',
            'process': 'pending',
            'Preparing Food': false
          }).then((value) {
            FirebaseDatabase.instance
                .ref('+27 82 481 5280/$element').remove().then((value) {
              print(
                  'nameOfOrders.remove(element) : ${nameOfOrders.length}');

              FirebaseDatabase.instance
                  .ref('+27 82 481 5280-path/${orderNumber}').set(
                  orderNumber);

              print('nameOfOrders[counter] : ${nameOfOrders[counter]}');
              nameOfOrders.removeAt(counter);
              print(
                  'nameOfOrders.remove(element)2 : ${nameOfOrders.length}');
            });
          });
        }
      });
    });
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    Get.snackbar('Payment Successfully', 'Your order was successfully',
        backgroundColor: AppColors.mainColor);
  }
  placeOrderOnDelivery(){
    int orderNumber = random(1000, 999999);
    String foodList = '';
    List<String> foodUrlList = [];
    int counter = -1;
    nameOfOrders.forEach((element) async {
      counter++;
      await FirebaseDatabase.instance
          .ref('+27 82 481 5280/$element')
          .once().asStream().forEach((orders) async {
        Map? mydata = orders.snapshot.value as Map?;

        print('mydata![orderChecked]: ${mydata!['orderChecked']} ');

        if (mydata!['orderChecked']) {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          foodList +=
              ',' + mydata['productName'] + ' x ${mydata['number']}';
          foodUrlList.add(mydata['imageUrl']);
          await FirebaseDatabase.instance.ref(
              '${mydata!['branche']}/+27 82 481 5280-${orderNumber}').set({
            'Accepted delivery': false,
            'Date': date.toString().replaceAll('00:00:00.000', ''),
            'Food List': foodList,
            'latitude': latitude,
            'longitude': longitude,
            'Food_List_image': foodUrlList,
            'Order_number': '${orderNumber}',
            'Total': total,
            'Time': '19:16',
            'company name': mydata['branche'],
            'ready': false,
            'Placed Order': true,
            'path': '+27 82 481 5280-${orderNumber}',
            'type': 'Delivery',
            'process': 'pending',
            'Preparing Food': false
          }).then((value) {
            FirebaseDatabase.instance
                .ref('+27 82 481 5280/$element').remove().then((value) {
              print(
                  'nameOfOrders.remove(element) : ${nameOfOrders.length}');

              FirebaseDatabase.instance
                  .ref('+27 82 481 5280-path/${orderNumber}').set(
                  orderNumber);

              print('nameOfOrders[counter] : ${nameOfOrders[counter]}');
              nameOfOrders.removeAt(counter);
              print(
                  'nameOfOrders.remove(element)2 : ${nameOfOrders.length}');
            });
          });
        }
      });
    });
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    Get.snackbar('Payment Successfully', 'Your order was successfully',
        backgroundColor: AppColors.mainColor);
  }
}


