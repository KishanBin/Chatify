import 'package:chatify/UiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  var _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(25),
        alignment: Alignment.center,
        //  decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Heading1(
                Heading: "Enter your Email",
                SubHeading:
                    "Link will send on your email to reset your Password"),
            SizedBox(
              height: 20,
            ),
            formField1(
                hintText: 'Enter your Ematl',
                controller: _email,
                validate: (value) {},
                obsecureText: false),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                resetPassword(_email.text);
                ToastContext().init(context);
                Toast.show('Link sent',
                    backgroundColor: Colors.black,
                    duration: 3,
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    gravity: Toast.top);
              },
              child: textButton(
                  buttonText: "Send",
                  textColor: Colors.white,
                  backgroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show a success message or handle the reset email
    } catch (e) {
      // Handle any errors (e.g., invalid email, user not found)
      print('Error sending reset email: $e');
    }
  }
}
