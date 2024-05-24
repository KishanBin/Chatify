import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Models/chatUser.dart';
import 'package:chatify/Pages/ProfilePage.dart';
import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static bool isSearching = false;
  var filterUser;
  List<chatUser> list = [];
  @override
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<DocumentSnapshot>(
                  future: APIs.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String profileIcon = data["Image"];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                        child: CircleAvatar(
                          child: profileIcon != ""
                              ? CachedNetworkImage(
                                  imageUrl: profileIcon,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                )
                              : Image.asset('Assets/Image/defaultAvatar.png'),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    }
                  }),
            ),
            centerTitle: true,
            title: isSearching
                ? TextField(
                    decoration: InputDecoration(
                        hintText: " Email....", border: InputBorder.none),
                    autofocus: true,
                    //login to search the user
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        filterUser = FirebaseFirestore.instance
                            .collection("Users")
                            .where("Email", isEqualTo: val)
                            .snapshots();
                      }
                      setState(() {
                        filterUser;
                      });
                    },
                  )
                : Text('Chatify'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      log("Button " + isSearching.toString());
                    });
                  },
                  icon: Icon(isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              SizedBox(
                width: 5,
              ),
              IconButton(
                onPressed: Logout,
                icon: Icon(Icons.logout_rounded),
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: isSearching ? filterUser : APIs.GetAllUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final data = snapshot.data?.docs;
                  list = data
                          ?.map((e) => chatUser
                              .fromJson(e.data() as Map<String, dynamic>))
                          .toList() ??
                      [];
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return chatCard(user: list[index]);
                      },
                    );
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
              })),
    );
  }
}
