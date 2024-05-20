import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Pages/ProfilePage.dart';
import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
  }

  Logout() async {
    //assigning the value loginKey to known
    var pref = await SharedPreferences.getInstance();
    pref.setString(LoginPageState.loginKey, "unknown");
    //Navigating the user to the LoginPage
    await FirebaseAuth.instance.signOut().then((value) =>
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> ProfilePage()));
                },
                child: CircleAvatar(
                  child:Image.asset(
                      'Assets/Image/defaultAvatar.png'),
                ),
              ),
              Text('Chatify'),
              IconButton(
                onPressed: Logout,
                icon: Icon(Icons.logout_rounded),
              ),
            ],
          ),
        ),
        body: StreamBuilder<Object>(
            stream: APIs.GetAllUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return chatCard(Snapshot: snapshot);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.hasError.toString()),
                  );
                } else {
                  return Center(
                    child: Text('No Data Found!'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
