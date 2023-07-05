import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../Recommended_Food_Details/recommended_food_details.dart';

class ProductListDetails extends StatelessWidget {
  final String branche;
  ProductListDetails({Key? key, required this.branche}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    getCollectionInCollection();
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: Dimensions.bottomHeightBar120 - Dimensions.height20*2,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  InkWell(child: AppIcon(icon: Icons.clear,),
                    onTap: () => Navigator.pop(context),),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  child: Center(child: BigText(
                    text: branche, size: Dimensions.font26,)),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimensions.radius20),
                        topLeft: Radius.circular(Dimensions.radius20),
                      )
                  ),
                ),
              ),
              pinned: true,
              backgroundColor: AppColors.mainColor,
              expandedHeight: Dimensions.height30,
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('imageURLs').doc(branche).collection('meun').snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(),);
                    } else {
                      return Container(
                        height: Dimensions.bottomHeightBar120*5 + Dimensions.height20*5,
                        margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, ),
                        child: AlignedGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 4,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: (){
                                List<String> listImage = [
                                  snapshot.data!.docs[index].get('url').toString(),
                                  snapshot.data!.docs[index].get('url1').toString(),
                                  snapshot.data!.docs[index].get('url2').toString()
                                ];
                                int price = int.parse(snapshot.data!.docs[index].get('Price'));
                                Get.to(RecommendedFoodDetails(
                                  brancheName: branche,
                                  listImage: listImage,
                                  productName: snapshot.data!.docs[index].get('Name'),
                                  productPrice: price,
                                  productDscr: snapshot.data!.docs[index].get('dec'),));
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    height: Dimensions.bottomHeightBar120*2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(snapshot.data!.docs[index].get('url')),
                                      ),
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                  Opacity(

                                    child: Container(
                                        height: Dimensions.bottomHeightBar120 - Dimensions.height10,
                                        decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                                        color: Colors.white,
                                      ),
                                      ),
                                    opacity: 0.5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: Dimensions.height10,bottom: Dimensions.height10,left: Dimensions.height10,right: Dimensions.height10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BigText(text: snapshot.data!.docs[index].get('Name')),
                                        SizedBox(height: Dimensions.height10,),
                                        BigText(text: "\R${snapshot.data!.docs[index].get('Price')}"),
                                        SizedBox(height: Dimensions.height10,),
                                        Row(
                                          children: [
                                            Wrap(
                                              children: List.generate(5, (index){
                                                return Icon(Icons.star,color: AppColors.mainColor,size: Dimensions.iconSize15,);
                                              }),
                                            ),
                                            SizedBox(width: Dimensions.width10/2,),
                                            SmallText(text: "4.5",color: AppColors.mainBlackColor),
                                            SizedBox(width: Dimensions.width10/2,),
                                            SmallText(text: '',color: AppColors.mainBlackColor),
                                            SizedBox(width: Dimensions.width10/2,),
                                            SmallText(text: 'comments',color: AppColors.mainBlackColor),
                                          ],
                                        ),


                                      ],
                                    ),

                                  ),

                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }

              )
            )
          ],
        ),
      ),
    );
  }

}
getCollectionInCollection() {
  FirebaseFirestore.instance.collection('imageURLs').doc(' Branche 1').collection('meun').get().then((value){
    print("value.docs.length: " + value.docs.length.toString());
  });

  FirebaseFirestore.instance.collection('imageURLs').snapshots().listen((event) {
    print("event.docs.length: " + event.docs.length.toString());
    event.docs.forEach((element) {
      print(element.id);

    });
  });

}