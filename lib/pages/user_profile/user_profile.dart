import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/pages/login/login.dart';
import '../../controllers/user_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../pick_address_location/address_save_page.dart';

class UserProfile extends StatelessWidget {
  UserProfile({Key? key}) : super(key: key);

  UserController userController = Get.put(UserController());

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController usernumber = TextEditingController();
  TextEditingController userAdderss = TextEditingController();
  final userInformation = GetStorage();

  @override
  Widget build(BuildContext context) {
    username.text   = userInformation.read('Username');
    usernumber.text = userInformation.read('Usernumbers');
    password.text   = userInformation.read('password');
    print('object ${userInformation.read('profileUrl')}');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: Dimensions.bottomHeightBar120 - Dimensions.height20*2,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                child: Center(child: BigText(
                  text: "User Profile", size: Dimensions.font26,)),
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
                  stream: FirebaseFirestore.instance.collection('imageURLs').doc('${userInformation.read('Usernumbers')}').snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return  Center(child: CircularProgressIndicator(),);
                    } else {
                      return Container(
                        padding: EdgeInsets.only(bottom: Dimensions.height45),
                        child: Column(
                          children: [
                            Padding(
                              child: CircleAvatar(
                                  radius: Dimensions.ListViewImgSize120,
                                  backgroundColor: AppColors.mainColor,
                                  child: Container(
                                    height: Dimensions.ListViewImgSize120*2 - 10,
                                    width: Dimensions.ListViewImgSize120*2 - 10,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                       borderRadius: BorderRadius.circular(120),
                                      image: DecorationImage(image: NetworkImage(
                                          userInformation.read('profileUrl').toString()))
                                    ),

                                  ),
                              ),
                              padding: EdgeInsets.only(top: Dimensions.height20),
                            ),
                            SizedBox(height: Dimensions.height20,),

                            Container(
                              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,bottom: Dimensions.height20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ]
                              ),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                enabled: false,
                                controller: username,
                                decoration: InputDecoration(
                                  hintText: 'username',
                                  prefixIcon: Icon(Icons.person,color: AppColors.yellowColor,),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: const BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,bottom: Dimensions.height20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ]
                              ),
                              child: TextField(
                                enabled: false,
                                controller: usernumber,
                                keyboardType: TextInputType.phone,
                                onChanged: (value){
                                  //phone = value;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  prefixIcon: Icon(Icons.phone_android,color: AppColors.yellowColor,),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: const BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,bottom: Dimensions.height10/2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      spreadRadius: 7,
                                      offset: const Offset(1, 10),
                                      color: Colors.grey.withOpacity(0.2),
                                    )
                                  ]
                              ),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: password,
                                enabled: false,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline,color: AppColors.yellowColor,),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: const BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Colors.white,
                                      )
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                                  ),
                                ),
                              ),
                            ),

                            /*Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Icon(Icons.people),
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                        },

                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10,),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Icon(Icons.phone_android),
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                        },
                                        controller: usernumber,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "+27 82 481 5280",
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10,),
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: Icon(Icons.password),
                                  ),
                                  const Text(
                                    "|",
                                    style: TextStyle(fontSize: 33, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                        },

                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "******",
                                        ),
                                      ))
                                ],
                              ),
                            ),*/
                            SizedBox(height: Dimensions.height10),
                            SizedBox(height: Dimensions.height30,),
                            Padding(
                              padding: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30),
                              child: SizedBox(
                                width: double.infinity,
                                height: Dimensions.height45*2,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: AppColors.mainColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    key: const Key("Send the code"),
                                    onPressed: () async {
                                      Get.to(AdderssView());
                                    },
                                    child: BigText(text: "Change Address",color: Colors.white,),),
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            SizedBox(height: Dimensions.height30,),
                            Padding(
                              padding: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30),
                              child: SizedBox(
                                width: double.infinity,
                                height: Dimensions.height45*2,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10))),
                                    key: const Key("Send the code"),
                                    onPressed: () async {
                                      userInformation.write('Usernumbers','');
                                      userInformation.write('password','');
                                      userInformation.write('Usernumbers','');
                                      userInformation.write('KeepMeLogin', false);
                                      userInformation.save();
                                      Get.to(const Login());
                                    },
                                    child: BigText(text: "Login out",color: Colors.white,)),
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                  }

              )
          )
        ],
      ),
    );
  }
}
