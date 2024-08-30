import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/incoming_order.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class IncomingOrders extends StatefulWidget {
  const IncomingOrders({Key? key}) : super(key: key);

  @override
  State<IncomingOrders> createState() => _IncomingOrdersState();
}

class _IncomingOrdersState extends State<IncomingOrders> {
  List<ProductOrders> productOrders = [];

  late Stream<DatabaseEvent> stream = FirebaseDatabase.instance.ref("Branche 1").onValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream.listen((event) {

      setState(() {
        if (productOrders.isNotEmpty){
          productOrders.clear();
        }
      });
      if (event.snapshot.exists){
        Map? mydata = event.snapshot.value as Map?;

        mydata!.forEach((key, value) {
          print(value['type']);
          if (value['process'] == "Ready" && value['process'] != "Reject" && value['ready'] == false && value['type'] == "Delivery")
            {
              productOrders.add(ProductOrders(
                  name: value['Food List'],
                  branche: value['company name'],
                  number: value['Order_number'],
                  price: value['Total'].toString(),
                  path: value['path'],
                  Date: value['Date'],
                  Time: value['Time'],
                  paymentType: value['payWithCash']));
              setState(() {
              });
            }
        });

      }

    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          margin: EdgeInsets.only(
            top: Dimensions.height20,
            left: Dimensions.width20,
            right: Dimensions.width20,
          ),
          child: ListView.builder(
              itemCount: productOrders.length,
              itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10,bottom: Dimensions.height30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhysicalModel(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.height10,bottom: Dimensions.height10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                BigText(text: '${productOrders[index].Date}'),
                                SizedBox(width: Dimensions.width20,),
                                BigText(text: '${productOrders[index].Time}'),
                                SizedBox(width: Dimensions.width20,),
                                BigText(text: 'PM'),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                                child: SmallText(text: '${productOrders[index].name}',size: Dimensions.font15,color: Colors.black)),
                            Row(
                              children: [
                                SmallText(text: 'id',size: Dimensions.font15,color: Colors.black,),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: '#${productOrders[index].number}',size: Dimensions.font15,color: Colors.black),
                              ],
                            ),
                            Row(
                              children: [
                                SmallText(text: 'Payment',size: Dimensions.font15,color: Colors.black),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: '${productOrders[index].paymentType}',size: Dimensions.font15,color: Colors.black),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: '\R${productOrders[index].price}',size: Dimensions.font15,color: Colors.black),
                              ],
                            ),
                            SizedBox(height: Dimensions.height45,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: (){
                                    FirebaseDatabase.instance.ref("Branche 1").child(productOrders[index].path).update(
                                        {'ready': 'Accepted'}).then((value){

                                    });
                                  },
                                  child: Container(
                                    height: Dimensions.height45*2,
                                    width: Dimensions.screenWidth/4,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                                    ),
                                    child: Center(child: BigText(text: "Accept",color: Colors.white,)),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    FirebaseDatabase.instance.ref("Branche 1").child(productOrders[index].path).update(
                                        {'process': 'Reject'}).then((value){

                                    });

                                  },
                                  child: Container(
                                    height: Dimensions.height45*2,
                                    width: Dimensions.screenWidth/4,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                                    ),
                                    child: Center(child: BigText(text: "Reject",color: Colors.white,)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10/2,),
                    Divider(height: Dimensions.height45,indent: 45,thickness: 2,color: AppColors.mainColor),
                  ],
                ),
              );
            },

          )
      ),
    );
  }
}

