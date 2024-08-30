import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import 'package:untitled6/widgets/big_text.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/small_text.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String phone_number = '';
  static String username = '';
  static String url = '';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController password          = TextEditingController();
  TextEditingController username          = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');
  final FirebaseAuth  auth  = FirebaseAuth.instance;
  UserController userController = Get.put(UserController());
  var phone = '';
  bool isLoading = false;
  bool KeepMeLogin = false;
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Opacity(
                    opacity: 0.3,
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: Dimensions.screenHeight/2 + 10,
                        color: AppColors.iconColor2,
                      ),
                    )
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: Dimensions.screenHeight/2,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(AppColors.mainColor.withOpacity(1), BlendMode.multiply),
                        image: NetworkImage('https://media.istockphoto.com/id/1409892847/photo/businessman-analyzing-digital-financial-balance-sheet-of-company-working-with-digital-virtual.jpg?s=612x612&w=0&k=20&c=eBiGxbiNCKlLwvaH-4uUUibssXW_4UfoeHXxnzRgo_U=',),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 90,left: 20),
                  child: const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150,left: 20),
                  child: const Text(
                    "The one and only place you get the best faster service!",
                    style: TextStyle(
                      fontSize: 16,
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),

            SizedBox(
              height: 25,
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
                keyboardType: TextInputType.phone,
                onChanged: (value){
                  phone = value;
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
                controller: password,
                obscureText: true,
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
                      key: const Key('Phone'),
                      child: TextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                    child: Icon(Icons.lock),
                  ),
                  const Text(
                    "|",
                    style: TextStyle(fontSize: 33, color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      key: const Key('Password'),
                      child: TextField(
                        onChanged: (value) {
                          password.text = value;
                        },
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                        ),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 0,
            ),*/
            Padding(
              padding: const EdgeInsets.only(right: 20,bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Keep me login?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Checkbox(// The named parameter 'title' isn't defined.
                    value: KeepMeLogin,
                    onChanged: !isLoading ? (newValue) {
                      setState(() {
                        KeepMeLogin = newValue!;
                      });
                    } : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  key: const Key("LoginButton"),
                  onPressed: isLoading ? null : () async {

                    var user       = users.snapshots();
                    var user_found = false;

                    var user_number = validation(phone,'g','h');

                    if (user_number != '')
                    {
                      if (password.text.isEmpty || phone.isEmpty)
                      {
                        Get.snackbar(
                          'Empty Fields',
                          "Phone numbers and Password are mandatory Fields.",
                          colorText: Colors.white,
                          backgroundColor: Colors.redAccent,
                          icon: const Icon(Icons.home, color: Colors.white),
                        );
                        return;
                      }
                      else {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        user.forEach((docsList) {

                          var numberOfUsers = docsList.docs.length;
                          var countUsers = 0;

                          docsList.docs.forEach((docsListValues) {

                            countUsers++;
                            if (docsListValues.get('password') == password.text
                                && docsListValues.get('phone_numbers') == user_number) {
                              Login.phone_number = docsListValues.get('phone_numbers');
                              Login.username = docsListValues.get('Username');
                              Login.url = docsListValues.get('profile_picture');

                              userController.Username = docsListValues.get('Username');
                              userController.password = docsListValues.get('password');
                              userController.Usernumbers = docsListValues.get('phone_numbers');

                              box.write('Username',
                                  userController.Username);
                              box.write('password',
                                  userController.password);
                              box.write('Usernumbers',
                                  userController.Usernumbers);
                              box.write('KeepMeLogin', KeepMeLogin);
                              box.write('profileUrl',docsListValues.get('profile_picture'));
                              box.save();


                              user_found = true;
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'home', (route) => false);
                              return;
                            }

                            if (countUsers == numberOfUsers && user_found == false)
                            {setState(() {
                              isLoading = false;
                            });
                            Get.snackbar(
                              'No User Found/Network',
                              "You user was not found, please try again or use a different user or create a user or please check your network connection...",
                              colorText: Colors.white,
                              backgroundColor: Colors.redAccent,
                              icon: const Icon(Icons.person_add_disabled, color: Colors.white),
                            );
                            }
                          });
                        });
                      }
                    }


                  },
                  child: !isLoading ? BigText(text: 'Login',color: Colors.white,)
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BigText(text: 'Please wait',color: Colors.white,),
                      SizedBox(width: Dimensions.width20,),
                      const CircularProgressIndicator(color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            /*SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        key: const Key("Signup"),
                        onPressed: isLoading ? null : () async {
                          Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
                        },
                        child: BigText(text: 'Signup or Forgot password',color: Colors.white,)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallText(text: "Signup/Forgot password?",size: Dimensions.font15,color: Colors.black),
                TextButton(onPressed: isLoading ? null : (){
                  Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
                }, child: Text("click here",style: TextStyle(fontSize: Dimensions.font15 + 2, fontWeight: FontWeight.bold),)),
              ],
            )
          ],
        ),
      ), /*Stack(
        children: [
          ClipPath(
            clipper: WaveClipper(),
            child: Container(

              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(AppColors.mainColor.withOpacity(1), BlendMode.multiply),
                  image: NetworkImage('https://media.istockphoto.com/id/1409892847/photo/businessman-analyzing-digital-financial-balance-sheet-of-company-working-with-digital-virtual.jpg?s=612x612&w=0&k=20&c=eBiGxbiNCKlLwvaH-4uUUibssXW_4UfoeHXxnzRgo_U=',),
                ),
              ),
            ),
          ),

        ],
      )*/
    );
  }
  String validation(String phone,String password,String Username){

    var title = '';
    var message = '';
    String currentPhoneNumber = phone.trim();
    bool returnValue = true;

    if (password == '' || Username == '' || currentPhoneNumber == ''){
      title = 'Empty Fields';
      message = "Phone numbers,Password and Username are mandatory Fields.";
      returnValue = false;
    }else if (currentPhoneNumber[0] == '+' && currentPhoneNumber.length != 12 ||
        currentPhoneNumber[0]+currentPhoneNumber[1] == '27' ||
        currentPhoneNumber[0] == '0' && currentPhoneNumber.length != 10){
      title = 'Error';
      message = 'You have entered invalid phone numbers';
      returnValue = false;
    }else if (currentPhoneNumber[0] == '0' && currentPhoneNumber.length == 10) {
      currentPhoneNumber = currentPhoneNumber.replaceRange(0, 1, '+27');
      returnValue = true;
    }

    if (!returnValue){
      Get.snackbar(
        title,
        message,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.home, color: Colors.white),
      );
      return '';
    }


    return currentPhoneNumber;
  }
}

class WaveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = Path();

    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset( size.width - (size.width / 3.24), size.height - 105);
    var secondEnd = Offset(size.width, size.height - 10.0);

    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
  
}
