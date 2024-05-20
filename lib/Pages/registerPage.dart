import 'package:chatify/Pages/VerificationPage.dart';
import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double deviceHeight;
  late double deviceWidth;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "", email = "", password = "";

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
            // color: Colors.red,
            margin: EdgeInsets.symmetric(horizontal: 25),
            width: deviceWidth,
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
                   
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Verification(
                          Name: name,
                          Email: email,
                          Password: password,
                        ),
                      ));
                }
              },
              child: textButton(
                buttonText: 'Register',
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              )),
          const SizedBox(
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
            formField1(
                hintText: 'Name',
                controller: nameController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Name";
                  }
                  return null;
                },
                obsecureText: false),
            formField1(
                hintText: "Email Address",
                controller: emailController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Email";
                  }
                  return null;
                },
                obsecureText: false),
            formField1(
                hintText: "Password",
                controller: passwordController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter password";
                  }
                  return null;
                },
                obsecureText: false),
          ],
        ));
  }
}
