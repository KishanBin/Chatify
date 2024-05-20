import 'package:chatify/Models/chatUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class APIs {
  //shortcut for FirebaseAuth.instance
  static FirebaseAuth auth = FirebaseAuth.instance;

  //returning the current user
  static User get user => auth.currentUser!;

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
        id: user.uid,
        About: 'Hey, I am using chatify',
        PushToken: '');

    return FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(data.toJson());
  }

  //for getting all user from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetAllUser() {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}
