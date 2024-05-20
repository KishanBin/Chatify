import 'package:chatify/apis.dart';
import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';

class Verification extends StatefulWidget {
  final String Name;
  final String Email;
  final String Password;
  //Constructor
  Verification(
      {super.key,
      required this.Name,
      required this.Email,
      required this.Password});

  @override
  State<Verification> createState() => VerificationState();
}

class VerificationState extends State<Verification> {
  late double deviceHeight;
  late double deviceWidth;

  late String name, email, password;

  TextEditingController otpController = TextEditingController();
  late String otp;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //Creating instance of EmailOTP package
  EmailOTP myAuth = EmailOTP();

  @override
  void initState() {
    super.initState();
    name = widget.Name;
    email = widget.Email;
    password = widget.Password;
    setState(() {
      sendOtp();
    });
  }

  //code to send otp
  void sendOtp() async {
    try {
      //Configuring the otp details
      myAuth.setConfig(
          appName: "Chatify",
          appEmail: "noreply@chatify.com",
          userEmail: email,
          otpLength: 6,
          otpType: OTPType.digitsOnly);
      // V3 is temple theme of package "Email_Auth"
      myAuth.setTheme(theme: "v3");
      //Sending OTP to user
      bool otpSent = await myAuth.sendOTP();
      //message to show OTP is sent
      if (otpSent) {
        ToastContext().init(context);
        Toast.show('OTP sent',
            backgroundColor: Colors.black,
            duration: 3,
            textStyle: TextStyle(color: Colors.white),
            gravity: Toast.top);
      } else {
        print('otp sent fail');
      }
    } catch (e) {
      String? error = e.toString();
      ToastContext().init(context);
      Toast.show('$error',
          backgroundColor: Colors.black,
          duration: 3,
          textStyle: TextStyle(color: Colors.white),
          gravity: Toast.top);
    }
  }

  //CODE OF OTP VERIFICATION
  void verifyOTP() async {
    try {
      //here storing the otp controller data into local variable "inputOTP"
      var inputOTP = otp;
      //Verifying the OTP
      bool result = await myAuth.verifyOTP(otp: inputOTP);
      if (result) {
        //Creating the user with email and password
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        //Creating the new user in firestore
        Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
        await APIs.createUser(name, email).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
        print("Data Inserted to FireStore");
        //Once the verification and Other Process done then redirect to LoginPage.
      } else {
        print('User not created');
      }
    } catch (e) {
      String? error = e.toString();
      ToastContext().init(context);
      Toast.show('$error',
          backgroundColor: Colors.black,
          duration: 3,
          textStyle: TextStyle(color: Colors.white),
          gravity: Toast.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          //color: Colors.amber,
          height: deviceHeight * 0.8,
          width: deviceWidth,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: _verificationUi(),
        ),
      ),
    );
  }

  Widget _verificationUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.black,
          backgroundImage: AssetImage("Assets/Image/EmailVerify.png"),
        ),
        SizedBox(
          height: 20,
        ),
        Heading1(
          Heading: 'Email Verificaton ',
          SubHeading: "Enter the 6-digit OTP",
        ),
        Form(
          key: _formKey,
          child: formField1(
            hintText: "OTP",
            controller: otpController,
            validate: (value) {
              if (value == null || value.isEmpty) {
                return "Please Enter OTP";
              }

              return null;
            },
            obsecureText: false,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                otp = otpController.text;
                verifyOTP();
              });
            }
          },
          child: textButton(
              buttonText: 'Verify',
              textColor: Colors.white,
              backgroundColor: Colors.blue),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () {
              setState(() {
                sendOtp();
              });
            },
            child: Text(
              "Resend OTP",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
