import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController();
  TextEditingController about = TextEditingController();

  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();

  File? pickedImage;
//  String profileImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.black,
        body: FutureBuilder<DocumentSnapshot>(
            future: APIs.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                var profileImageUrl = data['Image'];

                return Center(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 400,
                                          width: 400,
                                          child: AlertDialog(
                                            title: Text('Profile'),
                                            content: CachedNetworkImage(
                                              imageUrl: "${data["Image"]}",
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: const Text(
                                                          "No profile")),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Ok'),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: SizedBox(
                                  height: 150,
                                  child: CircleAvatar(
                                    radius: 70,
                                    child: profileImageUrl != ""
                                        ? CachedNetworkImage(
                                            imageUrl: profileImageUrl!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover)),
                                            ),
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Image.asset(
                                            'Assets/Image/defaultAvatar.png'),
                                    //
                                  ),
                                )),
                            Positioned(
                              top: 100,
                              left: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50)),
                                child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Select'),
                                            content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    pikingImage(
                                                        ImageSource.gallery)!;
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.photo_album,
                                                    size: 50,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      pikingImage(
                                                          ImageSource.camera)!;
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.camera_alt_rounded,
                                                      color: Colors.black,
                                                      size: 50,
                                                    ))
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.mode_edit_outlined,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data['Email'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: profileFormKey,
                            child: Column(
                              children: [
                                formField2(
                                  Lable: 'Name',
                                  InitialValue: '${data['Name']}',
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your Name';
                                    }
                                    return null;
                                  },
                                  OnSaved: (value) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(APIs.meUser.uid)
                                          .update({"Name": value}).then(
                                              (value) => print(
                                                  "Name Updated Successfully"));
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                formField2(
                                  Lable: 'About',
                                  InitialValue: '${data['About']}',
                                  validate: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Write a Quate';
                                    }
                                    return null;
                                  },
                                  OnSaved: (value) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(APIs.meUser.uid)
                                          .update({
                                        "About": value
                                      }).then((value) => print(
                                              "About updated Successfully"));
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.black)),
                                    onPressed: () {
                                      if (profileFormKey.currentState!
                                          .validate()) {
                                        profileFormKey.currentState!.save();
                                      }
                                      var snackbar = SnackBar(
                                        content: Text(
                                          "Profile Updated Successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.black,
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(bottom: 20),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackbar);
                                    },
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              }
            }));
  }

  pikingImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 80);
      if (image == null) {
        return;
      } else {
        final tempImage = File(image.path);

        setState(() {
          pickedImage = tempImage;
          uploadImage();
        });
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  uploadImage() async {
    if (pickedImage != null) {
      //creating the reference to the location where you want to upload the image
      Reference reference = FirebaseStorage.instance.ref().child('Images/');
      //start the upload task
      UploadTask uploadTask = reference.putFile(pickedImage!);

      try {
        // wait to complete the task
        await uploadTask;

        //Get the download url
        String url = await reference.getDownloadURL();

        FirebaseFirestore.instance
            .collection('Users')
            .doc(APIs.meUser.uid)
            .update({"Image": url}).then((value) {
          print("Image updated in Firebase Storage");
          setState(() {});
        });
      } catch (e) {
        print(Text(
          e.toString(),
          style: TextStyle(color: Colors.yellow),
        ));
      }
    } else {
      print('No image selected');
    }
  }
}
