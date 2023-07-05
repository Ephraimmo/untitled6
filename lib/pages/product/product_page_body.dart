import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/icon_and_text_widget.dart';
import 'package:untitled6/widgets/small_text.dart';
import '../../controllers/order_path_controller.dart';
import '../product_list_details/product_list_details.dart';

class ProductPageBody extends StatefulWidget {
  const ProductPageBody({Key? key}) : super(key: key);
  static String branche = '';
  @override
  State<ProductPageBody> createState() => _ProductPageBodyState();
}

class _ProductPageBodyState extends State<ProductPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var    _currPagevalue = 0.0;
  var _counter = 1;
  double _scaleFactor   = 0.8;
  double _height = Dimensions.pageViewContataner;
  final OrderPathController orderPathController = Get.put(OrderPathController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPagevalue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //color: Colors.redAccent,
          height: Dimensions.pageView,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('BusinessesData').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return PageView.builder(
                    controller: pageController,
                    itemCount: snapshot.data!.docs.length >= 5 ? 5 : snapshot.data!.docs.length,
                    itemBuilder: (context,position){
                      _counter = snapshot.data!.docs.length >= 5 ? 5 : snapshot.data!.docs.length;
                      return _buildPageItem(snapshot.data!.docs[position],position);
                    },
                  );
                }
              }

          ),
        ),
        DotsIndicator(
          dotsCount: _counter,
          position: _currPagevalue,
          decorator: DotsDecorator(
            activeColor: AppColors.mainColor,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        SizedBox(height: Dimensions.iconSize24),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Popular"),
              SizedBox(width: Dimensions.width10),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: BigText(text: ".",color: Colors.black26),
              ),
              SizedBox(width: Dimensions.width10),
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: SmallText(text: "food pairing",color: Colors.black54),
              ),
            ],
          ),
        ),
        //List of food and image
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection('BusinessesData').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(),);
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){

                    if (index == 0){
                      orderPathController.listBrancheNames.clear();
                      orderPathController.listBrancheNames.add(snapshot.data!.docs[index].get('CompanyName'));
                    }else{
                      orderPathController.listBrancheNames.add(snapshot.data!.docs[index].get('CompanyName'));
                    }

                    return InkWell(
                      onTap: (){
                        if (snapshot.data!.docs[index].get('open'))
                          Get.to(ProductListDetails(branche: snapshot.data!.docs[index].get('CompanyName'),),);
                        else
                          {
                            Get.snackbar(
                              'Danger',
                              "Hi the shop now is close, please try again when the store open's.",
                              colorText: Colors.white,
                              backgroundColor: Colors.redAccent,
                              icon: const Icon(Icons.home, color: Colors.white),
                            );
                          }
                      },
                      child: Container(
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
                                      image: CachedNetworkImageProvider(snapshot.data!.docs[index].get('url')),//NetworkImage(snapshot.data!.docs[index].get('urlProfile')),
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
                                      Align(child: BigText(text: snapshot.data!.docs[index].get('CompanyName')),
                                            alignment: Alignment.topLeft,),
                                      SizedBox(height: Dimensions.height10/2,),
                                      Align(
                                          child: Row(
                                            children: [
                                              Icon(Icons.attach_email_rounded,size: Dimensions.iconSize15/1.1,color: AppColors.mainColor),
                                              SizedBox(width: Dimensions.width20,),
                                              SmallText(text: snapshot.data!.docs[index].get('UserEmail'))
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                      SizedBox(height: Dimensions.height10/2,),
                                      Align(
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on,size: Dimensions.iconSize15/1.1,color: AppColors.mainColor),
                                              SizedBox(width: Dimensions.width20,),
                                              SmallText(text: snapshot.data!.docs[index].get('UserAddress')),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                      SizedBox(height: Dimensions.height10/2,),
                                      Row(
                                        children: [
                                          IconAndTextWidget(
                                              icon: snapshot.data!.docs[index].get('open') ? Icons.online_prediction : Icons.highlight_off,
                                              text: snapshot.data!.docs[index].get('open') ? "open" : 'close',
                                              iconColor: snapshot.data!.docs[index].get('open') ? Colors.green : Colors.red),
                                          IconAndTextWidget(
                                              icon: snapshot.data!.docs[index].get('status') == 'true' ? Icons.gpp_good_outlined : Icons.gpp_bad_outlined,
                                              text: snapshot.data!.docs[index].get('status') == 'true' ? 'Active' : "Checking...",
                                              iconColor: AppColors.mainColor),
                                          IconAndTextWidget(
                                              icon: Icons.delivery_dining_outlined,
                                              text: "on / off",
                                              iconColor: AppColors.iconColor2),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }

        ),

        SizedBox(height: Dimensions.iconSize24),
      ],
    );
  }
  Widget _buildPageItem(var src,int index) {
    Matrix4 martrix = new Matrix4.identity();

    if (index == _currPagevalue.floor()){
      var currScale = 1 - (_currPagevalue - index)*(1-_scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      martrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else if (index == _currPagevalue.floor() + 1){
      var currScale = _scaleFactor + (_currPagevalue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      martrix = Matrix4.diagonal3Values(1, currScale, 1);
      martrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if (index == _currPagevalue.floor() - 1){
      var currScale = 1 - (_currPagevalue - index)*(1-_scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      martrix = Matrix4.diagonal3Values(1, currScale, 1);
      martrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{
      var currScale = 0.8;
      martrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height * ( 1 - _scaleFactor)/2, 1);
    }

    return Transform(
      transform: martrix,
      child: InkWell(
        onTap: (){
          if (src.get('open'))
          Get.to(ProductListDetails(branche: src.get('CompanyName'),));
          else{
            Get.snackbar(
              'Danger',
              "Hi the shop now is close, please try again when the store open's.",
              colorText: Colors.white,
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.home, color: Colors.white),
            );
          }

        },
        child: Stack(
          children: [
            Container(
              height: Dimensions.pageViewContataner,
              margin: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: index.isEven? const Color(0xFF69c5df) : const Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(src.get('url')),
                  )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Dimensions.ListViewImgSize120,
                margin: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30,bottom: Dimensions.height30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.white,
                        //blurRadius: 1.0,
                        offset: Offset(5, 0),
                      ),
                    ]

                ),
                child: Container(
                  padding: EdgeInsets.only(top: Dimensions.height15,left: Dimensions.width15,right: Dimensions.width15),
                  child: Column(

                    children: [
                      Align(child: BigText(text: src.get('CompanyName')),
                        alignment: Alignment.topLeft,),
                      SizedBox(height: Dimensions.height10/2,),
                      Align(
                          child: Row(
                            children: [
                              Icon(Icons.location_on,size: Dimensions.iconSize15/1.1,color: AppColors.mainColor),
                              SizedBox(width: Dimensions.width20,),
                              SmallText(text: src.get('UserAddress')),
                            ],
                          ),
                          alignment: Alignment.topLeft),
                      SizedBox(height: Dimensions.height10/2,),
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
                      SizedBox(height: Dimensions.height10/2,),
                      Row(
                        children: [
                          IconAndTextWidget(
                              icon: src.get('open') ? Icons.online_prediction : Icons.highlight_off,
                              text: src.get('open') ? "open" : 'close',
                              iconColor: src.get('open') ? Colors.green : Colors.red),
                          IconAndTextWidget(
                              icon: src.get('status') == 'true' ? Icons.gpp_good_outlined : Icons.gpp_bad_outlined,
                              text: src.get('status') == 'true' ? 'Active' : "Checking...",
                              iconColor: AppColors.mainColor),
                          IconAndTextWidget(
                              icon: Icons.delivery_dining_outlined,
                              text: "on / off",
                              iconColor: AppColors.iconColor2),
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
      ),
    );
  }
}


