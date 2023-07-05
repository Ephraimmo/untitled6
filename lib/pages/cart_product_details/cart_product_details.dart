import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/app_icon.dart';
import '../../controllers/order_path_controller.dart';
import '../../controllers/product_controller.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../payment/payment.dart';
import '../pick_address_location/pick_address_location.dart';

class CartProductsDetails extends StatelessWidget {
  CartProductsDetails({Key? key}) : super(key: key);

  final CartProducController cartProducController = Get.put(CartProducController());
  final OrderPathController orderPathController = Get.put(OrderPathController());

  late List<String> nameOfOrders = [];
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    cartProducController.updateTotal();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Container(


          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cartProducController.hideBackBuutonCart.value == 2 ? SizedBox(width: Dimensions.width10,) : InkWell(child: AppIcon(icon: Icons.arrow_back_ios,backgroundColor: Colors.white,iconColor: AppColors.mainColor ),onTap: () => Navigator.pop(context),),
              BigText(text: 'Shipping Cart',size: Dimensions.iconSize24,color: Colors.white),
              InkWell(child: AppIcon(icon: Icons.home_outlined,backgroundColor: Colors.white,iconColor: AppColors.mainColor),onTap: () => Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false),),
            ],
          ),
        )),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainColor,
      ),
      body: Container(
        margin: EdgeInsets.all(Dimensions.width20),
        child: FirebaseAnimatedList(
          defaultChild: Center(child: CircularProgressIndicator()),
          query: FirebaseDatabase.instance.ref('+27 82 481 5280'),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map? mydata = snapshot.value as Map?;
            mydata!['key'] = snapshot.key;

            if (index == 0){
              nameOfOrders.clear();
              nameOfOrders.add(mydata['productName']);
            }else{
              nameOfOrders.add(mydata['productName']);
            }

            print("nameOfOrders: ${nameOfOrders.length}");



            return Container(
              margin: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30,top: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white70,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(5, 5),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      //blurRadius: 1.0,
                      offset: Offset(5, 0),
                    ),
                  ]

              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white12,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(mydata['imageUrl']),
                            fit: BoxFit.cover
                        )
                    ),
                    width: Dimensions.ListViewImgSize120,
                    height: Dimensions.ListViewImgSize120,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white12,
                      ),
                      height: Dimensions.ListViewTextConSize,
                      child: Padding(
                        padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
                        child: Column(

                          children: [
                            Container(
                              height: Dimensions.height45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BigText(text: mydata['productName']),
                                  Checkbox(value: mydata['orderChecked'],onChanged: (value){

                                    cartProducController.selectOrders(mydata['productName'], mydata['orderChecked']);
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10,),
                            Align(
                                child: SmallText(text: mydata['branche']),
                                alignment: Alignment.topLeft),
                            SizedBox(height: Dimensions.height10,),
                            Row(
                              children: [
                                BigText(text: '\R${mydata['price'] * mydata['number']}'),
                                Container(
                                  //padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                                    color: Colors.white70,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(child: Icon(Icons.remove,color: AppColors.mainColor,),
                                        onTap: (){
                                          var number = mydata['number'] - 1;
                                          cartProducController.decrement(number, mydata['productName']);
                                        },
                                      ),
                                      SizedBox(width: Dimensions.width30,),
                                      BigText(text: '${mydata['number']}'),
                                      SizedBox(width: Dimensions.width30,),
                                      InkWell(child: Icon(Icons.add,color: AppColors.mainColor,),
                                        onTap: (){
                                          var number = mydata['number'] + 1;
                                          cartProducController.increment(number, mydata['productName']);

                                        },

                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
      height: Dimensions.bottomHeightBar120 + Dimensions.height45*2,
      padding: EdgeInsets.only(top: Dimensions.height30,bottom: Dimensions.height30*2,left: Dimensions.width20,right: Dimensions.width20),
      decoration: BoxDecoration(
        color: AppColors.buttonBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radius20*2),
          topRight: Radius.circular(Dimensions.radius20*2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),
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
                  Obx(() => BigText(text: '\R${cartProducController.productTotal.value}.00'))
                ],
              )
          ),
          SizedBox(
            width: double.infinity,
            height: Dimensions.height45*2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green, // AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              key: const Key("Send the code"),
              onPressed: () async {

                print("nameOfOrders.length: ${nameOfOrders.length}");

                if (nameOfOrders.length == 0){
                  print("checkOrderBranch()");
                  Get.snackbar(
                    'Empty Cart',
                    "Your cart wish list is empty, please add some orders.",
                    colorText: Colors.white,
                    backgroundColor: Colors.redAccent,
                    icon: const Icon(Icons.home, color: Colors.white),
                  );
                  return;
                }else {

                  await checkOrderBranch();
                  double total = double.parse(cartProducController.productTotal.value.toString());
                  Get.to(Payment(ListBracheNames: nameOfOrders, productTotal: total,),transition: Transition.leftToRightWithFade,duration: Duration(milliseconds: 800));
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigText(text: "Check out",color: Colors.white,),
                  SizedBox(width: Dimensions.width30,),
                  Icon(Icons.check_circle_outline)
                ],
              ),),
          ),
        ],
      ),
    ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );
    Widget No_Button = TextButton(
      child: Text("No"),
      onPressed:  () async {

        await makePayment(total: cartProducController.productTotal.value.toString().replaceAll('.', ''));
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      },
    );
    Widget Yes_Button = TextButton(
      child: Text("Yes"),
      onPressed: () {
        double total = double.parse(cartProducController.productTotal.value.toString());
        Navigator.pop(context);
        Get.to(YourMapView(ListBracheNames: nameOfOrders, productTotal: total,),transition: Transition.zoom);
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.mainColor,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text("Order Method"),
      content: Text("Do you want your order to be delivery  at your location?"),
      actions: [
        cancelButton,
        No_Button,
        Yes_Button,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  checkOrderBranch() async {

    List<String> allBranches = [];
    List<String> allOrderNumber = [];
    int counter = 0;

    nameOfOrders.forEach((element) async {
      counter++;
      await FirebaseDatabase.instance.ref('+27 82 481 5280/$element').onValue.forEach((orders) {
        Map? mydata = orders.snapshot.value as Map?;

        print(mydata!['orderChecked'] && !allBranches.contains(mydata!['branche']));
        if (mydata!['orderChecked'] && !allBranches.contains(mydata!['branche'])){
          allBranches.add(mydata!['branche']);
          print('allBranches.length != 1: ${allBranches.length != 1}' );
          if (allBranches.length != 1){
            Get.snackbar(
              'Error Order',
              "Please order from one store.",
              colorText: Colors.white,
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.home, color: Colors.white),
            );
            return;
          }
          print('massage 1');
        }
      });
    });

  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future<void> makePayment({required String total}) async {
    try {
      paymentIntent = await createPaymentIntent('10099', 'ZAR');

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
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
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

            if (mydata!['orderChecked']){

              DateTime now = DateTime.now();
              DateTime date = DateTime(now.year, now.month, now.day);
              foodList += ',' + mydata['productName'] + ' x ${mydata['number']}';
              foodUrlList.add(mydata['imageUrl']);
              await FirebaseDatabase.instance.ref('${mydata!['branche']}/+27 82 481 5280-${orderNumber}').set({
                'Accepted delivery' : false,
                'Date'              : date.toString().replaceAll('00:00:00.000', ''),
                'Food List'         : foodList,
                'Food_List_image'   : foodUrlList,
                'Order_number'      : '${orderNumber}',
                'Total'             : cartProducController.productTotal.value,
                'Time'              : '19:16',
                'company name'      : mydata['branche'],
                'ready'             : false,
                'Placed Order'      : true,
                'path'              : '+27 82 481 5280-${orderNumber}',
                'type'              : 'Pickup',
                'process'           : 'pending',
                'Preparing Food'    : false
              }).then((value) {
                FirebaseDatabase.instance
                    .ref('+27 82 481 5280/$element').remove().then((value){
                  print('nameOfOrders.remove(element) : ${nameOfOrders.length}');

                  FirebaseDatabase.instance
                      .ref('+27 82 481 5280-path/${orderNumber}').set(orderNumber);

                  print('nameOfOrders[counter] : ${nameOfOrders[counter]}');
                  nameOfOrders.removeAt(counter);
                  print('nameOfOrders.remove(element)2 : ${nameOfOrders.length}');
                });


              });

            }
          });
        });

        Get.snackbar('Payment Successfully', 'Your order was successfully',backgroundColor: AppColors.mainColor);
      });
    } catch (e) {
      Get.snackbar('Payment Error', 'Your order was not successfully',backgroundColor: AppColors.mainColor);
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
}
