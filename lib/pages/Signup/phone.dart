import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = '';
  static String username = '';
  static String password = '';
  static String phone_number = '';
  static var fileImage;
  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  String _imagepath = '';
  /*final ImagePicker imgpicker = ImagePicker();
  Future getImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagepath = pickedFile.path;
          MyPhone.fileImage = pickedFile;
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking image.");
    }
  }*/
   var phone = '';
  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+27";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
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
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Enter User Information",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "The one and only place you get the best faster service!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  if (_imagepath == '')
                    const CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo7CzD_doftOQmpBK5_0dhzlqtnD_Fqe8T432aUzcHTQ&s')
                    ),
                  if (_imagepath != '')
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: FileImage(File(_imagepath)),
                  ),
                  Positioned(child: ElevatedButton(
                    onPressed: (){}, //getImage,
                    child: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                  ),top: 150,)
                ],
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
                            MyPhone.username = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Username",
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
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
                      child: Icon(Icons.phone_android)
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
                      child: Icon(Icons.lock_outline),
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
                            MyPhone.password = value;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    key: const Key("Send the code"),
                    onPressed: () async {

                      showDialog(
                          context: context,
                          builder: (_) => Center(child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                            backgroundColor: AppColors.iconColor2,
                            strokeWidth: Dimensions.width10,
                            semanticsLabel: 'Loading...',
                          ),)
                      );

                      var currentPhoneNumber = validation(phone,MyPhone.password,MyPhone.username);
                      if (currentPhoneNumber != ''){
                        try {

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: currentPhoneNumber,
                            verificationCompleted: (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId, int? resendToken) {
                              MyPhone.verify = verificationId;
                              MyPhone.phone_number = currentPhoneNumber;
                              Navigator.pop(context);
                              Navigator.pushNamed(context, 'verify');
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {},
                          );

                        } catch (error) {
                          Navigator.pop(context);
                          Get.snackbar(
                            "Sending verfycation code",
                            "Faild to send verfycation code to your phone number, please check your network connection...",
                            colorText: Colors.white,
                            backgroundColor: Colors.redAccent,
                            icon: const Icon(Icons.home, color: Colors.white),
                          );
                        }

                      }

                    },
                    child: const Text("Send the code")),
              ),
            ],
          ),
        ),
      ),
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
