import 'dart:convert';
import 'dart:math';
import  'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:untitled6/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../pick_address_location/address_save_page.dart';
import '../thank_you_page/thank_you_page.dart';

bool isLoading = false;

class Payment extends StatefulWidget {
  final ListBracheNames;
  final double productTotal;
  Payment({Key? key,required this.ListBracheNames, required this.productTotal}) : super(key: key);

  @override State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntent;
  final userNote = TextEditingController();
  final userphone = TextEditingController();
  final userInformation = GetStorage();
  bool payWithCard = false;
  bool payWithCash = false;
  bool deliveryOrder = false;
  bool PickupOrder = false;
  double longitude = 0;
  double latitude = 0;
  List<String> nameOfOrders = [];
  late double total;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameOfOrders = widget.ListBracheNames;
    setState(() {
      userphone.text = userInformation.read('Usernumbers');
    });
    total = widget.productTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text('Check out'),
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10,top: Dimensions.width10,bottom: Dimensions.width10),
              child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: AppIcon(icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.mainColor,)),
            ),
            backgroundColor: AppColors.mainColor,
        ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
              top: Dimensions.width30, bottom: Dimensions.width30),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('AppUsers').doc(
                  '${userphone.text}').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  if (snapshot.data!.get('AdderssUsed') != '') {
                    var positionLength = snapshot.data!
                        .get('AdderssUsed')
                        .toString()
                        .split(',')
                        .length;
                    longitude = double.parse(snapshot.data!
                        .get('AdderssUsed')
                        .toString()
                        .split(',')[positionLength - 2]);
                    latitude = double.parse(snapshot.data!
                        .get('AdderssUsed')
                        .toString()
                        .split(',')[positionLength - 1]);
                  }
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
                            height: Dimensions.height10*9,
                            padding: EdgeInsets.all(Dimensions.width10-2),
                            margin: EdgeInsets.only(top: Dimensions.height10-5,left: Dimensions.width10,right: Dimensions.width10),
                            child: PhysicalModel(
                                color: Colors.white,
                                elevation: 5,
                                shadowColor: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: Dimensions.width20*24,
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: List.generate(snapshot.data!
                                              .get('AdderssUsed')
                                              .toString()
                                              .split(',')
                                              .length - 2, (index) =>
                                          index == 0 ? Row(children: [
                                            SizedBox(width: Dimensions.width10,),
                                            SmallText(text: '${snapshot.data!.get(
                                                'AdderssUsed').toString().split(
                                                ',')[index]},',
                                                size: Dimensions.font15,
                                                color: AppColors.paraColor)
                                          ],) : SmallText(text: '${snapshot.data!.get(
                                              'AdderssUsed').toString().split(
                                              ',')[index]},',
                                              size: Dimensions.font15,
                                              color: AppColors.paraColor),)
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimensions.width20,
                                          right: Dimensions.width20,
                                          top: Dimensions.height10
                                      ),
                                      child: InkWell(
                                        onTap: isLoading ? null : () => Get.to(const AdderssView()),
                                        child: Column(
                                          children: [
                                            AppIcon(
                                                icon: Icons.edit_location_alt,
                                                backgroundColor: AppColors
                                                    .iconColor1),
                                            SmallText(text: 'Change',
                                              color: Colors.black,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(height: Dimensions.height10,),
                          BigText(text: "Payment Method"),
                          Divider(color: AppColors.mainColor,
                              indent: Dimensions.width30,
                              endIndent: Dimensions.width30),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: isLoading ? null : () {
                                setState(() {
                                  payWithCash = true;
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
                                    AppIcon(icon: Icons.monetization_on_outlined,
                                      iconColor: Colors.green,),
                                    SmallText(text: 'Pay with cash',
                                        size: Dimensions.font15),
                                    SizedBox(width: Dimensions.width30,),
                                    SizedBox(width: Dimensions.width30,),
                                    Checkbox(
                                        value: payWithCash, onChanged: isLoading ? null : (value) {
                                      setState(() {
                                        payWithCash = true;
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
                              onTap: isLoading ? null : () {
                                setState(() {
                                  payWithCard = true;
                                  payWithCash = false;
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
                                    SmallText(text: 'Pay with card',
                                        size: Dimensions.font15),
                                    SizedBox(width: Dimensions.width30,),
                                    SizedBox(width: Dimensions.width30,),
                                    Checkbox(
                                        value: payWithCard, onChanged: isLoading ? null : (value) {
                                      setState(() {
                                        payWithCard = true;
                                        payWithCash = false;
                                      });
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.height10,),
                          BigText(text: "Deliver/Pickup Method"),
                          Divider(color: AppColors.mainColor,
                              indent: Dimensions.width30,
                              endIndent: Dimensions.width30),

                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30),
                            child: PhysicalModel(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: isLoading ? null : (){
                                      setState(() {
                                        deliveryOrder = false;
                                        PickupOrder = true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SmallText(text: 'Pickup order',size: Dimensions.font15),
                                        Checkbox(value: PickupOrder, onChanged: isLoading ? null : (value){
                                          setState(() {
                                            deliveryOrder = false;
                                            PickupOrder = true;
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: isLoading ? null : (){
                                      setState(() {
                                        deliveryOrder = true;
                                        PickupOrder = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SmallText(text: 'Deliver order',size: Dimensions.font15),
                                        Checkbox(value: deliveryOrder, onChanged: isLoading ? null : (value){
                                          setState(() {
                                            deliveryOrder = true;
                                            PickupOrder = false;
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          SizedBox(height: Dimensions.height10,),
                          BigText(text: "Note"),
                          Divider(color: AppColors.mainColor,
                              indent: Dimensions.width30,
                              endIndent: Dimensions.width30),
                          Container(
                            height: Dimensions.height10*12,
                            margin: EdgeInsets.only(left: Dimensions.width30,
                                right: Dimensions.width30,bottom: Dimensions.height10),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Expanded(
                                child: TextField(
                                  onChanged: (value) {},
                                  controller: userNote,
                                  enabled: isLoading ? false : true,
                                  maxLines: 8,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    hintText: "Please Add Note here...",
                                    border: InputBorder.none,
                                  ),
                                )),
                          ),
                        ],
                      )
                  );
                }
              }

          ),
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
                  onPressed: isLoading ? null : () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (!payWithCard && !payWithCash) {
                      Get.snackbar('Payment Method',
                          'Plaese choose payment method...');
                      setState(() {
                        isLoading = false;
                      });
                    }
                    else if (!deliveryOrder && !PickupOrder) {
                      Get.snackbar('Delivery/Pickup Method',
                          'Plaese choose Delivery or Pickup method');
                      setState(() {
                        isLoading = false;
                      });
                    }
                    else if (payWithCash){
                      if (PickupOrder){
                        placeOrderOnPickup('cash');
                      }else if (deliveryOrder){
                        placeOrderOnDelivery('cash');
                      }

                    }else if (payWithCard){
                      await makePayment(latitude: latitude,longitude: longitude,total: total.toString().replaceAll('.', ''));
                    }

                  },
                  child: !isLoading ? BigText(text: "Place Order", color: Colors.white,)
                                     : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BigText(text: "Please wait", color: Colors.white,),
                                            SizedBox(width: Dimensions.width20,),
                                            const CircularProgressIndicator(color: Colors.white,),
                                          ],
                                         ),
              ),
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
          .then((value) {
      });

      //STEP 3: Display Payment sheet
      displayPaymentSheet(latitude: latitude, longitude: longitude);
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  displayPaymentSheet(
      {required double latitude, required double longitude}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        if (PickupOrder){
          placeOrderOnPickup('card');
        }else if (deliveryOrder){
          placeOrderOnDelivery('card');
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

  placeOrderOnPickup(var payWith){
    int orderNumber = random(1000, 999999);
    String foodList = '';
    String foodUrlList = '';
    int counter = -1;
    nameOfOrders.forEach((element) async {
      counter++;
      await FirebaseDatabase.instance
          .ref('${userInformation.read('Usernumbers')}/$element')
          .once().asStream().forEach((orders) async {
        Map? mydata = orders.snapshot.value as Map?;

        print('mydata![orderChecked]: ${mydata!['orderChecked']} ');

        if (mydata!['orderChecked']) {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          String dateTime = DateFormat("HH:mm:ss").format(DateTime.now());

          foodList +=
              ',' + mydata['productName'] + ' x ${mydata['number']}';
          if (foodUrlList == '')
            {
              foodUrlList = mydata['imageUrl'];
            }else{
            foodUrlList += "}}?|\|" + mydata['imageUrl'];
          }

          await FirebaseDatabase.instance.ref(
              '${mydata!['branche']}/${userInformation.read('Usernumbers')}-${orderNumber}').set({
            'Accepted delivery': false,
            'Date': date.toString().replaceAll(' 00:00:00.000',' ') + dateTime,
            'Food List': foodList,
            'Food_List_image': foodUrlList,
            'Order_number': '${orderNumber}',
            'Total': total,
            'Time': dateTime,
            'companyName': mydata['branche'],
            'Note' : userNote.text.trim(),
            'ready': false,
            'Placed Order': true,
            'path': '${userInformation.read('Usernumbers')}-${orderNumber}',
            'type': 'Pickup',
            'user': "?",
            'process': 'pending',
            'payWithCash': payWith,
            'Preparing Food': false
          }).then((value) {
            FirebaseDatabase.instance
                .ref('${userInformation.read('Usernumbers')}/$element').remove().then((value) {
              print(
                  'nameOfOrders.remove(element) : ${nameOfOrders.length}');

              FirebaseDatabase.instance
                  .ref('${userInformation.read('Usernumbers')}-path/${orderNumber}').set(
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ThankYou(paymentMethod: payWith,)),);
    setState(() {
      isLoading = false;
    });
  }
  placeOrderOnDelivery(var payWith){
    int orderNumber = random(1000, 999999);
    String foodList = '';
    String foodUrlList = '';
    int counter = -1;
    nameOfOrders.forEach((element) async {
      counter++;
      await FirebaseDatabase.instance
          .ref('${userInformation.read('Usernumbers')}/$element')
          .once().asStream().forEach((orders) async {
        Map? mydata = orders.snapshot.value as Map?;

        print('mydata![orderChecked]: ${mydata!['orderChecked']} ');

        if (mydata!['orderChecked']) {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          String dateTime = DateFormat("HH:mm:ss").format(DateTime.now());

          foodList +=
              ',' + mydata['productName'] + ' x ${mydata['number']}';
          if (foodUrlList == '')
          {
            foodUrlList = mydata['imageUrl'];
          }else{
            foodUrlList += "}}?|\|" + mydata['imageUrl'];
          }
          await FirebaseDatabase.instance.ref(
              '${mydata!['branche']}/${userInformation.read('Usernumbers')}-${orderNumber}').set({
            'Accepted delivery': false,
            'Date': date.toString().replaceAll(' 00:00:00.000',' ') + dateTime,
            'Food List': foodList,
            'latitude': latitude,
            'longitude': longitude,
            'Food_List_image': foodUrlList,
            'Order_number': '${orderNumber}',
            'Total': total,
            'Time': dateTime,
            'Note' : userNote.text.trim(),
            'DeliveryMan' : '',
            'companyName': mydata['branche'],
            'ready': false,
            'payWithCash': payWith,
            'Placed Order': true,
            'path': '${userInformation.read('Usernumbers')}-${orderNumber}',
            'type': 'Delivery',
            'user': "?",
            'process': 'pending',
            'Preparing Food': false
          }).then((value) {
            FirebaseDatabase.instance
                .ref('${userInformation.read('Usernumbers')}/$element').remove().then((value) {
              print(
                  'nameOfOrders.remove(element) : ${nameOfOrders.length}');

              FirebaseDatabase.instance
                  .ref('${userInformation.read('Usernumbers')}-path/${orderNumber}').set(
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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ThankYou(paymentMethod: payWith,)),);
    setState(() {
      isLoading = false;
    });
  }
}


