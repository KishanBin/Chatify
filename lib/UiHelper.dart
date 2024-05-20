import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Custom widgets to create Heading
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

// USE TO CREATE TextFormField of Registration and Login
class formField1 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator validate;
  final bool obsecureText;

  formField1(
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

// TextFormField for ProfilePage

class formField2 extends StatelessWidget {
  final String InitialValue;
  final FormFieldValidator validate;
  final String Lable;

  formField2(
      {required this.InitialValue,
      required this.validate,
      required this.Lable});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: InitialValue,
        validator: validate,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          label: Text(
            Lable,
            style: TextStyle(fontSize: 15, color: Colors.white60),
          ),
          focusColor: Colors.white60,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2)),
        ));
  }
}

// USE TO CREATE CUSTOM BUTTON
// ignore: must_be_immutable
class textButton extends StatelessWidget {
  late double _deviceHeight;
  late double _deviceWidth;
  //variables
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;

  textButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.backgroundColor,
  });

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

//USE TO SHOW ProgressBar !
class dialog {
  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }
}

//card view on home page
// ignore: must_be_immutable
class chatCard extends StatelessWidget {
  chatCard({super.key, required this.Snapshot});

  AsyncSnapshot Snapshot;
  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListView.builder(
        itemCount: Snapshot.data!.docs.length,
        itemBuilder: (context, index) => ListTile(
          leading: Snapshot.data.docs[index]['Image'] != ""
              ? CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: "${Snapshot.data!.docs[index]['Image']}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : Image.asset('Assets/Image/defaultAvatar.png'),
          title: Text("${Snapshot.data!.docs[index]['Name']}"),
          subtitle: Text("${Snapshot.data!.docs[index]['About']}"),
          trailing: Text("Last_seen"),
        ),
      ),
    );
  }
}
