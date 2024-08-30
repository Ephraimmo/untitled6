import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/cart_controller.dart';
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
  final CartController cartController = Get.put(CartController());
  var skipProduct = 0;



  @override
  Widget build(BuildContext context) {
    //getCollectionInCollection();
    //cartController.updateCart();
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: Dimensions.bottomHeightBar120 - Dimensions.height20*2,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: AppIcon(icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.mainColor,)),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(child: Badge(
                      largeSize: Dimensions.iconSize15,
                      label: Obx(() => Text(cartController.cart.value.toString())),
                      child: AppIcon(icon: Icons.shopping_cart_outlined,iconColor: AppColors.mainColor,),
                    ),onTap: () => Navigator.pushNamed(context, 'cart'),)
                  )
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
                  stream: FirebaseFirestore.instance.collection('imageURLs').doc(branche).collection('meun').orderBy('Status_Product', descending: true).snapshots(),
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
                            if(snapshot.data!.docs[index].get('Status_Product')){
                              return InkWell(
                                onTap: () {
                                  List<String> listImage = [
                                    snapshot.data!.docs[index]
                                        .get('url')
                                        .toString(),
                                    snapshot.data!.docs[index]
                                        .get('url1')
                                        .toString(),
                                    snapshot.data!.docs[index]
                                        .get('url2')
                                        .toString()
                                  ];
                                  int price = int.parse(snapshot
                                      .data!.docs[index]
                                      .get('ProductSelling'));
                                  Get.to(RecommendedFoodDetails(
                                    brancheName: branche,
                                    listImage: listImage,
                                    ProductName: snapshot.data!.docs[index]
                                        .get('ProductName'),
                                    ProductSelling: price,
                                    ProductQuantity: snapshot
                                        .data!.docs[index]
                                        .get('ProductQuantity'),
                                    ProductDescription: snapshot
                                        .data!.docs[index]
                                        .get('ProductDescription'),
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.width20),
                                  child: PhysicalModel(
                                    color: Colors.white,
                                    elevation: 5,
                                    shadowColor: AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius30),
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: AppIcon(
                                              icon: Icons
                                                  .add_shopping_cart_outlined,
                                              backgroundColor: Colors.green,
                                            )),
                                        Container(
                                          height:
                                          Dimensions.bottomHeightBar120 *
                                              2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                Dimensions.radius20),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                              CachedNetworkImageProvider(
                                                  snapshot
                                                      .data!.docs[index]
                                                      .get('url')),
                                            ),
                                            color: AppColors.mainColor,
                                          ),
                                        ),
                                        Opacity(
                                          child: Container(
                                            height: Dimensions
                                                .bottomHeightBar120 -
                                                Dimensions.height10,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  Dimensions.radius20),
                                              color: Colors.white,
                                            ),
                                          ),
                                          opacity: 0.5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Dimensions.height10,
                                              bottom: Dimensions.height10,
                                              left: Dimensions.height10,
                                              right: Dimensions.height10),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              BigText(
                                                  text: snapshot
                                                      .data!.docs[index]
                                                      .get(
                                                      'ProductName')),
                                              SizedBox(
                                                height: Dimensions.height10,
                                              ),
                                              BigText(
                                                  text:
                                                  "\R${double.parse(snapshot.data!.docs[index].get('ProductSelling')).toStringAsFixed(2)}"),
                                              SizedBox(
                                                height: Dimensions.height10,
                                              ),
                                              Row(
                                                children: [
                                                  SmallText(
                                                      text: "4.5",
                                                      color: AppColors
                                                          .mainBlackColor),
                                                  SizedBox(
                                                    width:
                                                    Dimensions.width10 /
                                                        2,
                                                  ),
                                                  Wrap(
                                                    children: List.generate(5,
                                                            (index) {
                                                          return Icon(
                                                            Icons.star,
                                                            color: AppColors
                                                                .mainColor,
                                                            size: Dimensions
                                                                .iconSize15,
                                                          );
                                                        }),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    Dimensions.width10 /
                                                        2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            right: 0,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                if (snapshot.data!.docs[index]
                                                    .get(
                                                    'ProductQuantity') !=
                                                    '0' &&
                                                    snapshot.data!.docs[index]
                                                        .get(
                                                        'ProductQuantity') !=
                                                        null) {
                                                  cartController
                                                      .cartProductCounter
                                                      .value = 1;
                                                  cartController.addToCart(
                                                      snapshot
                                                          .data!.docs[index]
                                                          .get('store'),
                                                      snapshot
                                                          .data!.docs[index]
                                                          .get('ProductName'),
                                                      int.parse(snapshot
                                                          .data!.docs[index]
                                                          .get(
                                                          'ProductSelling')),
                                                      snapshot
                                                          .data!.docs[index]
                                                          .get('url')
                                                          .toString());
                                                } else {
                                                  Get.snackbar('Out of stock',
                                                      'This product is out of stock');
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    Dimensions.width20 / 2),
                                                child: AppIcon(
                                                    icon: snapshot.data!.docs[index]
                                                        .get(
                                                        'ProductQuantity') ==
                                                        "0" ||
                                                        snapshot.data!.docs[index]
                                                            .get(
                                                            'ProductQuantity') ==
                                                            null
                                                        ? Icons
                                                        .remove_shopping_cart
                                                        : Icons
                                                        .add_shopping_cart_outlined,
                                                    backgroundColor: snapshot
                                                        .data!
                                                        .docs[
                                                    index]
                                                        .get(
                                                        'ProductQuantity') ==
                                                        "0" ||
                                                        snapshot.data!
                                                            .docs[index]
                                                            .get('ProductQuantity') ==
                                                            null
                                                        ? Colors.red
                                                        : AppColors.mainColor,
                                                    iconColor: Colors.white),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            }
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