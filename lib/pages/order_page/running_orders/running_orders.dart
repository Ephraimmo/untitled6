import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/utils/dimensions.dart';
import '../../../controllers/order_path_controller.dart';
import '../../../utils/colors.dart';
import '../../../widgets/small_text.dart';

class RunningOrder extends StatefulWidget {
  const RunningOrder({Key? key}) : super(key: key);

  @override
  State<RunningOrder> createState() => _RunningOrderState();
}

class _RunningOrderState extends State<RunningOrder> {

  final OrderPathController orderPathController = Get.put(OrderPathController());
  @override
  void initState() {
    // TODO: implement initState
    orderPathController.ListPathOrder.clear();
    FirebaseDatabase.instance
        .ref('+27 82 481 5280-path').onValue.listen((snapshot) {
          Map? mydata = snapshot.snapshot.value as Map?;

          mydata!.entries.forEach((orderNumber) {
            for(int i = 0; i < orderPathController.listBrancheNames.length; i++){

              FirebaseDatabase.instance
                  .ref('${orderPathController.listBrancheNames[i]}/+27 82 481 5280-${orderNumber.value}')
                  .once().asStream().forEach((element) {
                if (element.snapshot.exists){
                  Map? myValues = element.snapshot.value as Map?;
                  setState(() {
                    //if (!orderPathController.ListPathOrder.contains(snapshot.snapshot.value.toString().split(':')[0].replaceAll('{', '')))
                    orderPathController.ListPathOrder.add('${orderNumber.value},${myValues!['process']}');
                  });
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
          child: ListView.builder(
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
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(Dimensions.radius20/2)
                          ),
                          child: Center(child: SmallText(text: '${orderPathController.ListPathOrder[index].split(',')[1]}',color: Colors.white,)),
                        ),
                      ],
                    ),
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

