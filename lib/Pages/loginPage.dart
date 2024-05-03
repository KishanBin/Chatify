import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
            height: 20,
          ),
          InkWell(onTap: () {}, child: textButton('LOGIN')),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            splashColor: Colors.blue,
            child: Text(
              'REGISTER',
              style: TextStyle(color: Colors.white60),
            ),
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
    return Container(
      child: Column(
        children: <Widget>[
          formField('Email Address'),
          SizedBox(
            height: 25,
          ),
          formField('Password')
        ],
      ),
    );
  }

  Widget formField(text) {
    return SizedBox(
      child: TextFormField(
        // controller: controller,

        cursorColor: Colors.white60,
        obscureText: true,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(color: Colors.white60),
          focusColor: Colors.white60,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2)),
        ),
      ),
    );
  }

  Widget textButton(buttonText) {
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
