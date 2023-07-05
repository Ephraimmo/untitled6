import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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


  @override
  Widget build(BuildContext context) {
    username.text   = userController.Username;
    usernumber.text = userController.Usernumbers;
    password.text   = userController.password;
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
                  stream: FirebaseFirestore.instance.collection('imageURLs').doc('+27824815280').snapshots(),
                  builder: (context,snapshot) {
                    if (!snapshot.hasData) {
                      return  Center(child: CircularProgressIndicator(),);
                    } else {
                      return Container(
                        padding: EdgeInsets.only(left: Dimensions.width30*2,right: Dimensions.width30*2,bottom: Dimensions.height45),
                        child: Column(
                          children: [
                            Padding(
                              child: CircleAvatar(
                                  radius: Dimensions.ListViewImgSize120,
                                  backgroundColor: AppColors.mainColor,
                                  child: Container(
                                    height: 240,
                                    width: 240,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                       borderRadius: BorderRadius.circular(120),
                                      image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo7CzD_doftOQmpBK5_0dhzlqtnD_Fqe8T432aUzcHTQ&s'))
                                    ),

                                  ),
                              ),
                              padding: EdgeInsets.only(top: Dimensions.height20),
                            ),
                            SizedBox(height: Dimensions.height20,),
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
                                        enabled: false,
                                        controller: username,
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
                                        controller: password,
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "******",
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.height10),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.mainColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  key: const Key("Send the code"),
                                  onPressed: () async {
                                    Get.to(AdderssView());
                                  },
                                  child: Row(
                                    children: [
                                      AppIcon(icon: Icons.location_on),
                                      SizedBox(width: Dimensions.width30,),
                                      BigText(text: "Change Address",color: Colors.white,),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  )),
                            ),
                            SizedBox(height: Dimensions.height10),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: AppColors.mainColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  key: const Key("Send the code"),
                                  onPressed: () async {

                                  },
                                  child: BigText(text: "Edit",color: Colors.white,)),
                            ),
                            SizedBox(height: Dimensions.height30,),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10))),
                                  key: const Key("Send the code"),
                                  onPressed: () async {
                                    Get.to(const Login());
                                  },
                                  child: BigText(text: "Login out",color: Colors.white,)),
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
