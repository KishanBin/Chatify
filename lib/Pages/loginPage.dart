import 'package:chatify/Pages/Home.dart';
import 'package:chatify/UiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  String email = "", password = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordContorller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } on FirebaseAuthException catch (e) {
      String? error = e.message;
      // ignore: use_build_context_synchronously
      ToastContext().init(context);
      Toast.show("$error", gravity: Toast.top, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: _deviceHeight * 0.70,
          width: _deviceWidth,
          //color: Colors.amber,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: _loginPageUi(),
        ),
      ),
    );
  }

  Widget _loginPageUi() {
    return Container(
      height: _deviceHeight,
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _heading(),
          SizedBox(
            height: 15,
          ),
          _inputForm(),
          SizedBox(
            height: 30,
          ),
          InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = _emailController.text;
                    password = _passWordContorller.text;
                  });
                }
                userLogin();
              },
              child: textButton('LOGIN', Colors.blue, Colors.white)),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: textButton("REGISTER", Colors.black, Colors.white60),
          )
        ],
      ),
    );
  }

  Widget _heading() {
    return Container(
      //color: Colors.green,
      height: _deviceHeight * 0.12,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back !',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Text(
            'Please login to your account. ',
            style: TextStyle(color: Colors.white60, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Form(
      key: _formKey,
      onChanged: () {},
      child: Column(
        children: <Widget>[
          formField(
              hintText: 'Email Address',
              obsecureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter the Email';
                }
                return null;
              },
              controller: _emailController),
          SizedBox(
            height: 25,
          ),
          formField(
            hintText: 'Password',
            obsecureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter the Password';
              }
              return null;
            },
            controller: _passWordContorller,
          )
        ],
      ),
    );
  }
}
