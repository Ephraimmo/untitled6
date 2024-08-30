import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:untitled6/pages/Signup/phone.dart';
import '../../controllers/user_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/big_text.dart';
import '../login/login.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');
  UserController userController = Get.put(UserController());
  var smsCode = '';
  bool isLoading = false;
  bool KeepMeLogin = false;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );



    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        leading: IconButton(
          onPressed: isLoading ? null : () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        child: SingleChildScrollView(
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
                          height: Dimensions.bottomHeightBar120*2 + Dimensions.height45*5 + 10,
                          color: AppColors.iconColor2,
                        ),
                      )
                  ),
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: Dimensions.bottomHeightBar120*2 + Dimensions.height45,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                "Verify Numbers",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: Colors.black),
              ),
              Text(
                "The one and only place you get the best faster service!",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.paraColor
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Pinput(
                  length: 6,
                   //defaultPinTheme: defaultPinTheme,
                   focusedPinTheme: focusedPinTheme,
                   submittedPinTheme: submittedPinTheme,
                  onChanged: (value) => smsCode = value,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ),
              SizedBox(
                height: Dimensions.height10/8,
              ),
              Padding(
                padding: EdgeInsets.only(right: Dimensions.width20),
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
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
                child: SizedBox(
                  width: double.infinity,
                  height: Dimensions.height45*2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                          onPressed: isLoading ? null : () async {

                              setState(() {
                                isLoading = !isLoading;
                              });
                              try{
                                // Create a PhoneAuthCredential with the code
                                AuthCredential credential = PhoneAuthProvider.credential(verificationId: MyPhone.verify, smsCode: smsCode);

                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);

                                users.doc(MyPhone.phone_number).set({
                                  'Username' : MyPhone.username,
                                  'phone_numbers' : MyPhone.phone_number,
                                  'password' : MyPhone.password,
                                  'AdderssUsed' : '',
                                  'profile_picture' : box.read('profileUrl').toString(),
                                }).then((value) {
                                  userController.Username    = MyPhone.username;
                                  userController.password    = MyPhone.password;
                                  userController.Usernumbers = MyPhone.phone_number;
                                  box.write('Username',
                                      userController.Usernumbers);
                                  box.write('password',
                                      userController.password);
                                  box.write('Usernumbers',
                                      userController.Usernumbers);
                                  box.write('KeepMeLogin', KeepMeLogin);
                                  box.save();

                                  Navigator.pushNamedAndRemoveUntil(context, "home", (route) => false);
                                });

                              }catch(e){
                                print("Error: " + e.hashCode.toString());

                                setState(() {
                                  isLoading = !isLoading;
                                });
                              }

                          },
                      child: !isLoading ? BigText(text: "Verify Phone Number", color: Colors.white,)
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(text: "Please wait", color: Colors.white,),
                          SizedBox(width: Dimensions.width20,),
                          const CircularProgressIndicator(color: Colors.white,),
                        ],
                      ), //const Text("")
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: TextButton(
                    onPressed: isLoading ? null : () async {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone',
                            (route) => false,
                      );
                    },
                    child: BigText(text: "Edit Phone Number ?", color: Colors.white,)
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
