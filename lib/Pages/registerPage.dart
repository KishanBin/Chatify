import 'package:chatify/Pages/Home.dart';
import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "", email = "", password = "";

  register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      String? error = e.message;
      ToastContext().init(context);
      Toast.show('{$error}',
          gravity: Toast.top,
          duration: 3,
          backgroundColor: Colors.black,
          textStyle: TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
            // color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 25),
            width: _deviceWidth,
            child: _registerUi()),
      ),
    );
  }

  Widget _registerUi() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Heading1(
            Heading: 'Register',
            SubHeading: 'To Connect with world !',
          ),
          SizedBox(
            height: 15,
          ),
          _inputRegister(),
          SizedBox(
            height: 30,
          ),
          InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    name = nameController.text;
                    email = emailController.text;
                    password = passwordController.text;
                  });
                  register();
                }
              },
              child: textButton(
                buttonText: 'Register',
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              )),
          SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'Already have an account ? ',
              style: TextStyle(color: Colors.white60),
            ),
            WidgetSpan(
                child: InkWell(
              child: Text(' Login',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage())),
            ))
          ])),
        ],
      ),
    );
  }

  Widget _inputRegister() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formField(
                hintText: 'Name',
                controller: nameController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm Password";
                  }
                  return null;
                },
                obsecureText: false),
            formField(
                hintText: "Email Address",
                controller: emailController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm Password";
                  }
                  return null;
                },
                obsecureText: false),
            formField(
                hintText: "Password",
                controller: passwordController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm Password";
                  }
                  return null;
                },
                obsecureText: false),
          ],
        ));
  }

  // Widget _textButton(String buttonText, Color backgroundColor) {
  //   return Container(
  //     height: _deviceHeight * 0.08,
  //     width: _deviceWidth,
  //     decoration: BoxDecoration(
  //         color: backgroundColor, borderRadius: BorderRadius.circular(2)),
  //     child: Center(
  //       child: Text(
  //         buttonText,
  //         style: TextStyle(color: Colors.white, fontSize: 20),
  //       ),
  //     ),
  //   );
  // }
}
