import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/small_text.dart';

import '../../../controllers/order_path_controller.dart';

class CartHistory extends StatefulWidget {
  CartHistory({Key? key}) : super(key: key);

  @override
  State<CartHistory> createState() => _CartHistoryState();
}

class _CartHistoryState extends State<CartHistory> {
  final OrderPathController orderPathController = Get.put(OrderPathController());
  final userInformation = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    orderPathController.ListPathOrder.clear();
    FirebaseDatabase.instance
        .ref('${userInformation.read('Usernumbers')}-path').onValue.listen((snapshot) {
      if (!snapshot.snapshot.exists)
        return;
      Map? mydata = snapshot.snapshot.value as Map?;

      mydata!.entries.forEach((orderNumber) {
        for(int i = 0; i < orderPathController.listBrancheNames.length; i++){

          FirebaseDatabase.instance
              .ref('${orderPathController.listBrancheNames[i]}/${userInformation.read('Usernumbers')}-${orderNumber.value}')
              .once().asStream().forEach((element) {
            if (element.snapshot.exists){
              Map? myValues = element.snapshot.value as Map?;
              if (myValues!['process'] != "Accepted" && myValues!['process'] != "pending" && myValues!['process'] != "Ready") {
                setState(() {
                  orderPathController.ListPathOrder.add(
                      '${orderNumber.value},${myValues!['process']}');
                });
              }
            }
          });
        }
      });
    });


    super.initState();
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
          child: orderPathController.ListPathOrder.length == 0 ? Center(child: BigText(text: 'No history orders',size: Dimensions.font26,color: AppColors.paraColor),) : ListView.builder(
      itemCount: orderPathController.ListPathOrder.length,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.only(left: Dimensions.width10,top: Dimensions.width10,bottom: Dimensions.height30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          SmallText(text: 'Order_ID:',color: AppColors.mainBlackColor,),
                          SizedBox(width: Dimensions.width20,),
                          SmallText(text: '#${orderPathController.ListPathOrder[index].split(',')[0]}',color: AppColors.mainBlackColor,),
                        ],
                      ),
                    ),
                    Container(
                      width: Dimensions.ListViewImgSize120 - Dimensions.width30*2,
                      height: Dimensions.height30*2,
                      decoration: BoxDecoration(
                          color: orderPathController.ListPathOrder[index].split(',')[1] == 'Reject'? Colors.red : AppColors.mainColor ,
                          borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                      ),
                      child: Center(child: SmallText(text: orderPathController.ListPathOrder[index].split(',')[1] == "Ready" ? "Delivering" : '${orderPathController.ListPathOrder[index].split(',')[1]}',color: Colors.white,)),
                    ),
                  ],
                ),
                Divider(height: Dimensions.height45,indent: 45,thickness: 2,color: AppColors.mainColor),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}

