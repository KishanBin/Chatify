import 'package:flutter/material.dart';

class Heading1 extends StatelessWidget {
  final String Heading;
  final String SubHeading;
  Heading1({super.key, required this.Heading, required this.SubHeading});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Heading,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Text(
            SubHeading,
            style: TextStyle(color: Colors.white60, fontSize: 20),
          )
        ],
      ),
    );
  }
}

class formField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator validate;
  final bool obsecureText;

  formField(
      {required this.hintText,
      required this.controller,
      required this.validate,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white60,
      validator: validate,
      controller: controller,
      style: TextStyle(color: Colors.white60),
      obscureText: obsecureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 30),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white60),
        focusColor: Colors.white60,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white60, width: 2)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white60, width: 2)),
      ),
    );
  }
}

// ignore: must_be_immutable
class textButton extends StatelessWidget {
  late double _deviceHeight;
  late double _deviceWidth;
  //variables
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;

  textButton(
      {super.key,
      required this.buttonText,
      required this.textColor,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight * 0.08,
      width: _deviceWidth,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(2)),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
