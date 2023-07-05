import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';

class YourMapView extends StatefulWidget {
  final ListBracheNames;
  final double productTotal;

  YourMapView({required this.ListBracheNames, required this.productTotal});
  @override
  _YourMapViewState createState() => _YourMapViewState();

}

class _YourMapViewState extends State<YourMapView> {
  final markers = Set<Marker>();
  MarkerId markerId = MarkerId("PickUp");
  MarkerId UserCurrentPostion = MarkerId("User Location");
  LatLng latLng = LatLng(43.2994, 74.2179);
  late LatLng latLngPickUp;
  List<String> nameOfOrders = [];
  late double total;
  Map<String, dynamic>? paymentIntent;


  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return Future.error("Location service are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error("Location permission are denied");
      }
    }

    if (permission == LocationPermission.deniedForever){
      return Future.error("Location permission are denied, we cannot request");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
      print(latLng);

    _getCurrentLocation().then((value){
      setState(() {
        nameOfOrders = widget.ListBracheNames;
        total = widget.productTotal;
        latLng = LatLng(value.latitude, value.longitude);
        markers.add(
          Marker(
            markerId: markerId,
            infoWindow: InfoWindow(title: "Pick Up Point"),
            position: latLng,
          ),
        );
        markers.add(
          Marker(
            markerId: UserCurrentPostion,
            infoWindow: InfoWindow(title: "User Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
            position: latLng,
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: 'Delivery Point'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
      ),
      body: latLng == LatLng(43.2994, 74.2179) ? Center(child: CircularProgressIndicator(),) : GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng,zoom: 16),
        onMapCreated: (map){
          map.showMarkerInfoWindow(MarkerId("User Location"));
          map.showMarkerInfoWindow(MarkerId("PickUp"));
        },
        markers: markers,
        onCameraMove: (position){
          setState(() {
            markers.add(Marker(markerId: markerId,position: position.target));
            latLngPickUp = LatLng(position.target.latitude, position.target.longitude);

          });
        },
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30,bottom: Dimensions.height45,top: Dimensions.height10),
          width: double.maxFinite,
          color: AppColors.mainColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  key: const Key("Send the code"),
                  onPressed: () async {
                    //print("Lag : " + markers.elementAt(0).position.latitude.toString() + " long : " + markers.elementAt(0).position.longitude.toString());
                    //print("Lag : " + latLngPickUp.latitude.toString() + " long : " + latLngPickUp.longitude.toString());

                    await makePayment(latitude: markers.elementAt(0).position.latitude,longitude: markers.elementAt(0).position.longitude,total: total.toString().replaceAll('.', ''));
                    },
                  child: const Text("Use User Point")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),

                  onPressed: () async {
                    //print("Lag : " + markers.elementAt(0).position.latitude.toString() + " long : " + markers.elementAt(0).position.longitude.toString());
                    //print("Lag : " + latLngPickUp.latitude.toString() + " long : " + latLngPickUp.longitude.toString());

                    await makePayment(latitude: latLngPickUp.latitude,longitude: latLngPickUp.longitude,total: total.toString().replaceAll('.', ''));
                    
                  },
                  child: const Text("Use Pick Point")),
            ],
          )
      ),
    );
  }

  /*checkOrderBranch() async {

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
        }
      });
    });

  }*/

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future<void> makePayment({required double latitude, required double longitude,required String total}) async {
    try {
      paymentIntent = await createPaymentIntent( total, 'ZAR');

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
      displayPaymentSheet(latitude: latitude,longitude: longitude);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet({required double latitude, required double longitude}) async {
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
                'latitude'          : latitude,
                'longitude'         : longitude,
                'Food_List_image'   : foodUrlList,
                'Order_number'      : '${orderNumber}',
                'Total'             : total,
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

         Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
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
