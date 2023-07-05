import 'package:flutter/material.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/small_text.dart';

class CartHistory extends StatelessWidget {
  CartHistory({Key? key}) : super(key: key);

  List<String> ImageList = [
    'https://img.freepik.com/free-photo/top-view-table-full-delicious-food-composition_23-2149141353.jpg',
    'https://img.freepik.com/free-photo/top-view-table-full-delicious-food-composition_23-2149141353.jpg',
    'https://img.freepik.com/free-photo/top-view-table-full-delicious-food-composition_23-2149141353.jpg',
    //'https://img.freepik.com/free-photo/top-view-table-full-delicious-food-composition_23-2149141353.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height20,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10,bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    children: [
                      BigText(text: '18/06/2023'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: '01:21'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: 'PM'),
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
                                          image: NetworkImage(ImageList[index]),
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
                            BigText(text: 'Branche',color: AppColors.mainColor),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Total',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: 'R10.50',size: Dimensions.font15),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Items',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: ImageList.length.toString(),size: Dimensions.font15),
                              ],
                            ),
                          ],
                        )
                      ]
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10,bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    children: [
                      BigText(text: '18/06/2023'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: '01:21'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: 'PM'),
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
                                          image: NetworkImage(ImageList[index]),
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
                            BigText(text: 'Branche',color: AppColors.mainColor),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Total',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: 'R10.50',size: Dimensions.font15),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Items',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: ImageList.length.toString(),size: Dimensions.font15),
                              ],
                            ),
                          ],
                        )
                      ]
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width10,bottom: Dimensions.height30),
              child: Column(
                children: [
                  Row(
                    children: [
                      BigText(text: '18/06/2023'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: '01:21'),
                      SizedBox(width: Dimensions.width20,),
                      BigText(text: 'PM'),
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
                                          image: NetworkImage(ImageList[index]),
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
                            BigText(text: 'Branche',color: AppColors.mainColor),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Total',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: 'R10.50',size: Dimensions.font15),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BigText(text: 'Items',size: Dimensions.font15),
                                SizedBox(width: Dimensions.width10,),
                                SmallText(text: ImageList.length.toString(),size: Dimensions.font15),
                              ],
                            ),
                          ],
                        )
                      ]
                  )
                ],
              ),
            ),
          ],
        )
        ),
    );
  }
}
