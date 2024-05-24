import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Models/chatUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class chatScreen extends StatefulWidget {
  chatUser user;
  chatScreen({super.key, required this.user});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
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
      body: _inputTextField(),
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
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Message'),
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
            onPressed: () {},
            padding: EdgeInsets.only(left: 10, right: 4, top: 10, bottom: 10),
            minWidth: 0,
            shape: CircleBorder(),
            color: Colors.green,
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
