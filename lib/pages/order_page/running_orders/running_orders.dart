import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/utils/dimensions.dart';
import '../../../controllers/order_path_controller.dart';
import '../../../utils/colors.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/small_text.dart';

class RunningOrder extends StatefulWidget {
  const RunningOrder({Key? key}) : super(key: key);

  @override
  State<RunningOrder> createState() => _RunningOrderState();
}

class _RunningOrderState extends State<RunningOrder> {

  final OrderPathController orderPathController = Get.put(OrderPathController());
  final userInformation = GetStorage();
  List<String> ImageList = [];
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
                  if (myValues!['process'] != "Reject" && myValues!['process'] != "Pickup" && myValues!['process'] != "Delivery") {
                setState(() {
                  orderPathController.ListPathOrder.add(
                      '${orderNumber.value},${myValues!['process']},${myValues!['Date']},${myValues!['Time']},R${myValues!['Total'].toString()},${myValues!['companyName']},${myValues!['Food_List_image']},${myValues!['type']}');
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
          child: orderPathController.ListPathOrder.length == 0 ? Center(child: BigText(text: 'No running orders',size: Dimensions.font26,color: AppColors.paraColor),) : ListView.builder(
            itemCount: orderPathController.ListPathOrder.length,
            itemBuilder: (context,index){
              ImageList = orderPathController.ListPathOrder[index].split(',')[6].split("}}?|\|");
              return Container(
                margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10,bottom: Dimensions.height30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BigText(text: '${orderPathController.ListPathOrder[index].split(',')[2]}'),
                        SizedBox(width: Dimensions.width20*2,),
                        Spacer(),
                        SmallText(text: '#${orderPathController.ListPathOrder[index].split(',')[0]}',size: Dimensions.font20,),
                        Spacer(),
                      ],
                    ),
                    SizedBox(width: Dimensions.width10,),
                    Row(
                        children: [
                          Wrap(
                            children: List.generate(3, (index){
                              return Container(
                                width: Dimensions.screenWidth/5,
                                height: Dimensions.screenWidth/5,
                                margin: EdgeInsets.only(top: Dimensions.height10/2, right: Dimensions.width10/2),
                                decoration: BoxDecoration(
                                  color: ImageList.length <= index ? Colors.white12 : AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                                ),
                                child: ImageList.length <= index ? const Text('') :
                                Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.height10/4,
                                        left: Dimensions.width10/4,
                                        right: Dimensions.width10/4,
                                        bottom: Dimensions.height10/4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(ImageList[index]),
                                            fit: BoxFit.cover
                                        )
                                    )
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: Dimensions.width10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BigText(text: '${orderPathController.ListPathOrder[index].split(',')[5]}',color: AppColors.mainColor),
                              SmallText(text: '${orderPathController.ListPathOrder[index].split(',')[4]}',size: Dimensions.font15),
                              Container(
                                width: Dimensions.ListViewImgSize120 - Dimensions.width30*2,
                                height: Dimensions.height30*2,
                                decoration: BoxDecoration(
                                    color: orderPathController.ListPathOrder[index].split(',')[1] == 'pending'? AppColors.signColor : orderPathController.ListPathOrder[index].split(',')[1] == 'Accepted'? Colors.green : AppColors.mainColor ,
                                    borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                                ),
                                child: Center(child: SmallText(text: orderPathController.ListPathOrder[index].split(',')[1] == "Ready" ? orderPathController.ListPathOrder[index].split(',')[7] == 'Pickup' ? "Pickup" : "Delivering" : '${orderPathController.ListPathOrder[index].split(',')[1]}',color: Colors.white,)),
                              ),

                            ],
                          ),

                        ]
                    ),
                    Divider(height: Dimensions.height45,indent: 45,thickness: 2,color: AppColors.mainColor),
                  ],
                ),
              );
            },

          ) /*ListView.builder(
      itemCount: orderPathController.ListPathOrder.length,
        itemBuilder: (context, index){
          return orderPathController.ListPathOrder[index].split(',')[1] == "Reject" ? null : Container(
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
                          color: orderPathController.ListPathOrder[index].split(',')[1] == 'pending'? AppColors.signColor : orderPathController.ListPathOrder[index].split(',')[1] == 'Accepted'? Colors.green : AppColors.mainColor ,
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
      )*/
      ),
    );
  }
}

