import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/expendable_text_widget.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/small_text.dart';

class RecommendedFoodDetails extends StatelessWidget {
  RecommendedFoodDetails({Key? key, required this.listImage, required this.ProductName, required this.ProductSelling, required this.ProductDescription, required this.brancheName, required this.ProductQuantity}) : super(key: key);
  var activeIndex = 0;
  final List<String> listImage;
  final String ProductName;
  final int ProductSelling;
  final String ProductDescription;
  final String brancheName;
  final String ProductQuantity;

  final CartController cartController = Get.put(CartController());



  @override
  Widget build(BuildContext context) {
    cartController.setValue(ProductSelling);
    cartController.updateCart();
    cartController.activeImageSlider.value = 0;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: Dimensions.height45*2,
              leading: Padding(
                padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20-5,top: 1,bottom: 1),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: AppIcon(icon: Icons.arrow_back_ios_new_outlined,iconColor: AppColors.mainColor,)),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  InkWell(child: Badge(
                    largeSize: Dimensions.iconSize15,
                    label: Obx(() => Text(cartController.cart.value.toString())),
                    child: AppIcon(icon: Icons.shopping_cart_outlined,iconColor: AppColors.mainColor,),
                  ),onTap: () => Navigator.pushNamed(context, 'cart'),)
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Container(
                  child: Column(
                    children: [
                      Center(child: BigText(text: ProductName,size: Dimensions.font26,)),
                      SizedBox(height: Dimensions.height10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(child: AppIcon(icon: Icons.remove,backgroundColor: AppColors.mainColor,iconColor: Colors.white),
                          onTap: () {
                            cartController.decrement(ProductSelling);
                          } ,
                          ),
                          Obx(() => BigText(text: "\R" + ProductSelling.toString() + " x " + cartController.cartProductCounter.toString()),),
                          InkWell(child: AppIcon(icon: Icons.add,backgroundColor: AppColors.mainColor,iconColor: Colors.white),
                          onTap: (){
                            cartController.increment(ProductSelling);

                          },
                          )
                        ],
                      ),

                    ],
                  ),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 5,bottom: 10),
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
              expandedHeight: Dimensions.ListViewImgSize120*3,
              flexibleSpace: FlexibleSpaceBar(
                background: buildSliderImage(listImage),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index){
                              return Icon(Icons.star,color: AppColors.mainColor,size: Dimensions.iconSize15,);
                            }),
                          ),
                          SizedBox(width: Dimensions.width10,),
                          SmallText(text: "4.5"),
                          SizedBox(width: Dimensions.width10,),
                          SmallText(text: '1287'),
                          SizedBox(width: Dimensions.width10,),
                          SmallText(text: 'comments'),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconAndTextWidget(
                              icon: Icons.circle_sharp,
                              text: "Normal",
                              iconColor: AppColors.iconColor1),
                          IconAndTextWidget(
                              icon: Icons.location_on,
                              text: "1.7km",
                              iconColor: AppColors.mainColor),
                          IconAndTextWidget(
                              icon: Icons.access_time_rounded,
                              text: "32min",
                              iconColor: AppColors.iconColor2),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10,),
                      ProductQuantity == '0' ? Row(
                        children: [
                          BigText(text: 'Quantity'),
                          SizedBox(width: Dimensions.width10,),
                          BigText(text: ':'),
                          SizedBox(width: Dimensions.width10,),
                          SmallText(text: 'Out of stock',size: Dimensions.font20,),
                        ],
                      ) :  Row(
                        children: [
                          BigText(text: 'Quantity'),
                          SizedBox(width: Dimensions.width10,),
                          BigText(text: ':'),
                          SizedBox(width: Dimensions.width10,),
                          SmallText(text: '${ProductQuantity}',size: Dimensions.font20,),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10,),
                      BigText(text: 'Description'),
                      ExpendableTextWidget(text: ProductDescription == null ? '' : ProductDescription,),
                      SizedBox(height: Dimensions.height20,)
                    ],
                  )),
              )
          ],
        ),
        bottomNavigationBar: Container(
          height: Dimensions.bottomHeightBar120 - Dimensions.height45,
          padding: EdgeInsets.only(top: Dimensions.height30,bottom: Dimensions.height30*2,left: Dimensions.height45,right: Dimensions.height45),
          decoration: BoxDecoration(
            color: AppColors.buttonBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20*4),
              topRight: Radius.circular(Dimensions.radius20*4),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AppColors.mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                key: const Key("Send the code"),
                onPressed: () async {
                  if (ProductQuantity != '0') {
                    cartController.addToCart(
                        brancheName, ProductName, ProductSelling, listImage[0]);
                  }else{
                    Get.snackbar('Out of stock', "This product is out of stock, you cant place order or add to cart");
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => BigText(text: 'R' + cartController.cartProductTotal.toString()),),
                    SizedBox(width: Dimensions.width10,),
                    Obx(() => BigText(text: cartController.addingTocart.value == 0 ? 'Add to cart' : " Adding...  "),)
                  ],
                )),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                ),
                child: AppIcon(icon: Icons.favorite,backgroundColor: Colors.white,iconColor: AppColors.mainColor),
              ),
              InkWell(
                onTap: (){


                },
                child: Container(
                  padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: AppColors.mainColor,
                  ),
                  child: Row(
                    children: [
                      //Icon(Icons.add_shopping_cart_outlined,color: AppColors.signColor,),
                      //SizedBox(width: Dimensions.width10,),

                    ],
                  ),
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
  Widget buildSliderImage(List<String> src){
    return Stack(
      children: [
        Container(
          color: Colors.white70,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              height: 800.0,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(seconds: 2),
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              onPageChanged: (index, reason){
                  cartController.activeImageSlider.value = index;
              },
            ),
            itemCount: src.length,
            itemBuilder: (context, index, rea){
              return CachedNetworkImage(
                imageUrl: src[index],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );//Image.network(src[index],fit: BoxFit.cover,width: double.maxFinite,);
            },

          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, Dimensions.bottomHeightBar120),
              child: Obx(() => buildSliderImageIndicator(),)
            )
        )
      ],
    );
  }
  Widget buildSliderImageIndicator() => AnimatedSmoothIndicator(
    key: const Key('AnimatedSmoothIndicator'),
    count: listImage.length,
    activeIndex: cartController.activeImageSlider.value,
    effect: SlideEffect(
        spacing:  Dimensions.width10,
        dotColor:  Colors.grey,
        //radius:  4.0,
        //dotWidth:  24.0,
        //dotHeight:  16.0,
        //paintStyle:  PaintingStyle.stroke,
        //strokeWidth:  1.5,
        activeDotColor:  AppColors.mainColor
    ),
  );
  Widget buildImages() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
    itemCount: 5,
    itemBuilder: (context, index) => ImageWidget(index: index),
  );
}
