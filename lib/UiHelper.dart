import 'package:flutter/material.dart';

class formField extends StatelessWidget {
  formField(
      {super.key,
      required String hintText,
      required bool obsecureText,
      required FormFieldValidator validator,
      required TextEditingController controller});

  @override
  Widget build(BuildContext context) {
    var hintText;
    var obsecureText;
    var validator;
    var controller;

    return SizedBox(
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.white60,
        onSaved: (newValue) {},
        validator: validator,
        obscureText: obsecureText,
        style: TextStyle(color: Colors.white60),
        decoration: InputDecoration(
          hintText: hintText,
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
}

// ignore: must_be_immutable
class textButton extends StatelessWidget {
  textButton(String buttonText, Color backgroundColor, Color textColor,
      {super.key});

  late double _deviceHeight;

  @override
  Widget build(BuildContext context) {
    var textColor;
    var buttonText;
    var backgroundColor;

    _deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: _deviceHeight * 0.08,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(1)),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
