import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Models/chatMessage.dart';
import 'package:chatify/Models/chatUser.dart';
import 'package:chatify/Pages/Home.dart';
import 'package:chatify/Pages/chatScreen.dart';
import 'package:chatify/apis.dart';
import 'package:flutter/cupertino.dart';
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
  final Function(String?) OnSaved;
  // final TextEditingController controller;

  formField2({
    required this.InitialValue,
    required this.validate,
    required this.Lable,
    required this.OnSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: InitialValue,
        validator: validate,
        onSaved: OnSaved,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        autovalidateMode: AutovalidateMode.always,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black, fontSize: 20),
        decoration: InputDecoration(
          label: Text(
            Lable,
            style: TextStyle(fontSize: 15, color: Colors.white60),
          ),
          focusColor: Colors.white60,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black54, width: 2)),
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
        builder: (_) => Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )));
  }
}

//User for snakBar

//card view on home page
class chatCard extends StatelessWidget {
  chatCard({super.key, required this.user});

  chatUser user;
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.blue,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => chatScreen(
                        user: user,
                      )));
        },
        child: ListTile(
          leading: user.Image != ""
              ? CircleAvatar(
                  child: CachedNetworkImage(
                    imageUrl: "${user.Image}",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : Image.asset('Assets/Image/defaultAvatar.png'),
          title: Text("${user.Name}"),
          subtitle: Text("${user.About}"),
          trailing: Text("${user.LastSeen}"),
        ),
      ),
    );
  }
}

class chatMessageCard extends StatefulWidget {
  chatMessages messages;
  chatMessageCard({super.key, required this.messages});

  @override
  State<chatMessageCard> createState() => _chatMessageCardState();
}

class _chatMessageCardState extends State<chatMessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.meUser.uid == widget.messages.fromID ? greenchat() : bluechat();
  }

  Widget greenchat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Text(widget.messages.sent,
              style: TextStyle(color: Colors.black54)),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.messages.mesg,
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.done_all_rounded,
                  size: 15,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bluechat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .04,
                vertical: MediaQuery.of(context).size.height * .01),
            decoration: BoxDecoration(
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              widget.messages.mesg,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Text(widget.messages.sent,
              style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
