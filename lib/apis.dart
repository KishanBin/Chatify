
import 'package:chatify/Models/chatMessage.dart';
import 'package:chatify/Models/chatUser.dart';
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
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('id', isNotEqualTo: meUser.uid)
        .snapshots();
  }

  //useful for getting conversation ID
  static String getConversationID(String id) {
    return meUser.uid.hashCode <= id.hashCode
        ? '${meUser.uid}_$id'
        : '${id}_${meUser.uid}';
  }

  //for getting all messages of a specific conversation form firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      chatUser user) {
    return FirebaseFirestore.instance
        .collection("chats/${getConversationID(user.id)}/Messages/")
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessage(chatUser chatuser, String msg) async {
    //Time in millisecond for making chat document id
    final timeInMs = DateTime.now().microsecondsSinceEpoch.toString();

    //to print the time
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm');
    String formattedTime = formatter.format(now);

    //message to send
    final message = chatMessages(
        toID: chatuser.id,
        read: '',
        type: '',
        sent: formattedTime,
        fromID: meUser.uid,
        mesg: msg);

    final ref = FirebaseFirestore.instance
        .collection("chats/${getConversationID(chatuser.id)}/Messages/");

    await ref.doc(timeInMs).set(message.toJson());
  }
}
