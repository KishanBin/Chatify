import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Models/chatMessage.dart';
import 'package:chatify/Models/chatUser.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class chatScreen extends StatefulWidget {
  chatUser user;
  chatScreen({super.key, required this.user});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  final _textController = TextEditingController();
  List<chatMessages> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: appBar(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            height: 1,
            color: Colors.grey.shade700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final data = snapshot.data?.docs;

                    _list = data
                            ?.map((e) => chatMessages
                                .fromJson(e.data() as Map<String, dynamic>))
                            .toList() ??
                        [];

                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: _list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return chatMessageCard(messages: _list[index]);
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
                }),
          ),
          _inputTextField(),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
          // color: Colors.pink,
          ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.arrow_left),
              color: Colors.black,
            ),
            CircleAvatar(
              child: widget.user.Image != ""
                  ? CachedNetworkImage(
                      imageUrl: widget.user.Image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                    )
                  : Image.asset('Assets/Image/defaultAvatar.png'),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.user.Name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  widget.user.LastSeen,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _inputTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Card(
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.emoji_emotions)),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Message...'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                log('function called');
                setState(() {});
                _textController.text = '';
              } else {
                log('Field is Empty');
              }
            },
            padding: EdgeInsets.only(left: 10, right: 4, top: 10, bottom: 10),
            minWidth: 0,
            shape: CircleBorder(),
            color: Colors.black,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
