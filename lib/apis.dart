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
        .collection("chats/${getConversationID(user.id)}/Messages/").orderBy('sent',descending: true)
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessage(chatUser chatuser, String msg,Type type) async {
    //Time in millisecond for making chat document id
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    //to print the time
    // final now = DateTime.now();
    // final formatter = DateFormat('HH:mm');
    // String formattedTime = formatter.format(now);

    //message to send
    final message = chatMessages(
        toID: chatuser.id,
        read: '',
        type: type,
        sent: time,
        fromID: meUser.uid,
        mesg: msg);

    final ref = FirebaseFirestore.instance
        .collection("chats/${getConversationID(chatuser.id)}/Messages/");

    await ref.doc(time).set(message.toJson());
  }

  //function to formate the time
  static String getFormatedTime(String time) {
    final datetime = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final String formattedTime = DateFormat('HH:mm').format(datetime);
    return formattedTime;
  }

  // to update the read status of user from receiver side
  static Future<void> updateReadMessage(chatMessages messages) async {
    FirebaseFirestore.instance
        .collection("chats/${getConversationID(messages.fromID)}/Messages/")
        .doc(messages.sent)
        .update({"read": DateTime.now().microsecondsSinceEpoch.toString()});
  }
}
