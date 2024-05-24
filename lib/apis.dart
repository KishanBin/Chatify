import 'package:chatify/Models/chatUser.dart';
import 'package:chatify/Pages/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class APIs {
  //shortcut for FirebaseAuth.instance
  static FirebaseAuth auth = FirebaseAuth.instance;

  //returning the current user
  static User get meUser => auth.currentUser!;

  //For creating new user
  static Future<void> createUser(String name, String email) async {
    final DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);

    final data = chatUser(
        LastSeen: '',
        CreatedAt: date,
        Name: name,
        IsOnline: false,
        Email: email,
        Image: '',
        id: meUser.uid,
        About: 'Hey, I am using chatify',
        PushToken: '');

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(meUser.uid)
        .set(data.toJson());
  }

  static Future<DocumentSnapshot<Object?>>? getProfile() {
    CollectionReference collecRef =
        FirebaseFirestore.instance.collection('Users');
    return collecRef.doc(APIs.meUser.uid).get();
  }

  //for getting all user from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetAllUser() {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('id', isNotEqualTo: meUser.uid)
        .snapshots();
  }
}
