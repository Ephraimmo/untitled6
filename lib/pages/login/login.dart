import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled6/utils/colors.dart';
import 'package:untitled6/utils/dimensions.dart';
import '../../controllers/user_controller.dart';

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
  CollectionReference users = FirebaseFirestore.instance.collection('AppUsers');
  final FirebaseAuth  auth  = FirebaseAuth.instance;
  UserController userController = Get.put(UserController());
  var phone = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Welcome Back",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                height: 30,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Keep me login?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Checkbox(// The named parameter 'title' isn't defined.
                    value: false,
                    onChanged: (newValue) { },
                  ),
                ],
              ),
              const SizedBox(
                height: 0,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    key: const Key("Login"),
                    onPressed: () async {

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
                          showDialog(
                              context: context,
                              builder: (_) => Center(child: CircularProgressIndicator(
                                color: AppColors.mainColor,
                                backgroundColor: AppColors.iconColor2,
                                strokeWidth: Dimensions.width10,
                                semanticsLabel: 'Loading...',
                              ),)
                          );
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

                                user_found = true;
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'home', (route) => false);
                                return;
                              }

                              if (countUsers == numberOfUsers && user_found == false)
                              {
                                Navigator.pop(context);
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
                    child: const Text("Login",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    key: const Key("Signup"),
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
                      Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
                    },
                    child: const Text("Signup",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Forgot password?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, 'phone', (route) => false);
                  }, child: Text("Reset password",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                ],
              )
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
