import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled6/widgets/big_text.dart';
import 'package:untitled6/widgets/small_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  final storageRef = FirebaseStorage.instance.ref();
  final userInformation = GetStorage();
  String _imagepath = '';
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Future getImage() async {
    try {
      var pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
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
  }
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
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
        title: BigText(text: 'Register/New password'),
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
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Opacity(
                      opacity: 0.3,
                      child: ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                          height: Dimensions.bottomHeightBar120*2 + Dimensions.height45 + 10,
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
                  if (_imagepath == '')
                    Center(
                      child: const CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo7CzD_doftOQmpBK5_0dhzlqtnD_Fqe8T432aUzcHTQ&s')
                      ),
                    ),
                  if (_imagepath != '')
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(File(_imagepath)),
                      ),
                    ),
                  Positioned(child: ElevatedButton(
                    onPressed: isLoading ? null : getImage,
                    child: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                    ),
                  ),top: 150,left: 100,)
                ],
              ),
              SizedBox(
                height: Dimensions.bottomHeightBar120/2,
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
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    MyPhone.username = value;
                  },
                  enabled: isLoading ? false : true,
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
                  keyboardType: TextInputType.phone,
                  onChanged: (value){
                    phone = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    enabled: isLoading ? false : true,
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
                  onChanged: (value) {
                    MyPhone.password = value;
                  },
                  enabled: isLoading ? false : true,
                  keyboardType: TextInputType.text,
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
              SizedBox(
                height: Dimensions.height45*2,
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.width30,right: Dimensions.width30),
                child: SizedBox(
                  width: double.infinity,
                  height: Dimensions.height45*2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      key: const Key("Send the code"),
                      onPressed: isLoading ? null : () async {

                        var currentPhoneNumber = validation(phone,MyPhone.password,MyPhone.username);
                        if (currentPhoneNumber != ''){
                          try {

                            setState(() {
                              isLoading = !isLoading;
                            });

                            if (_imagepath != null && _imagepath != '') {
                                  String filePath = _imagepath;

                                  File file = File(filePath);
                                  final mountainsRef = storageRef
                                      .child("profile/${currentPhoneNumber}");

                                  UploadTask task1 = mountainsRef.putFile(file);

                                  var imgUrl1 = await (await task1).ref.getDownloadURL();

                                  print(
                                      'mountainsRef.getDownloadURL() : ${imgUrl1}');
                                  userInformation.write('profileUrl',
                                      imgUrl1);
                                  userInformation.save();
                                }else{
                              userInformation.write('profileUrl',
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo7CzD_doftOQmpBK5_0dhzlqtnD_Fqe8T432aUzcHTQ&s');
                            }

                                await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: currentPhoneNumber,
                              verificationCompleted: (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent: (String verificationId, int? resendToken) {
                                MyPhone.verify = verificationId;
                                MyPhone.phone_number = currentPhoneNumber;

                                isLoading = false;
                                Navigator.pushNamed(context, 'verify');
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {},

                            );

                          } catch (error) {
                            Navigator.pop(context);
                            setState(() {
                              isLoading = !isLoading;
                            });
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
                      child: !isLoading ? BigText(text: "Send the code", color: Colors.white,)
                        : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BigText(text: "Please wait", color: Colors.white,),
                            SizedBox(width: Dimensions.width20,),
                            const CircularProgressIndicator(color: Colors.white,),
                          ],
                        ),
                  ),
                ),
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
