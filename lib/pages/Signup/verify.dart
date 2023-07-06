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
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                 //defaultPinTheme: defaultPinTheme,
                 focusedPinTheme: focusedPinTheme,
                 submittedPinTheme: submittedPinTheme,
                onChanged: (value) => smsCode = value,
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: Dimensions.height10/8,
              ),
              Row(
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
              SizedBox(
                width: double.infinity,
                height: 45,
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
                                'profile_picture' : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo7CzD_doftOQmpBK5_0dhzlqtnD_Fqe8T432aUzcHTQ&s'
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
