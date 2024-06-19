import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/Models/chatMessage.dart';
import 'package:chatify/Models/chatUser.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/apis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  bool isEmoji = false;
  File? pickedImage;

  @override
  Widget build(BuildContext context) {
    var DHeight = MediaQuery.of(context).size.height;
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
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
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
                          reverse: true,
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
                      return Center();
                    }
                  }),
            ),
            _inputTextField(),
            if (isEmoji)
              SizedBox(
                height: DHeight * 0.35,
                child: EmojiPicker(
                  textEditingController: _textController,
                  config: Config(
                    height: 256,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                        columns: 8,
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                        backgroundColor: Colors.white),
                  ),
                ),
              )
          ],
        ),
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
                      onPressed: () {
                        setState(() {
                          isEmoji = !isEmoji;
                          FocusScope.of(context).unfocus();
                        });
                      },
                      icon: Icon(Icons.emoji_emotions)),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      minLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Message...'),
                      onTap: () {
                        if (isEmoji) {
                          setState(() {
                            isEmoji = false;
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      chatImagePicker(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {
                      chatImagePicker(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);

                setState(() {});
                _textController.text = '';
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

  //function to select Image and send
  chatImagePicker(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 70);
      if (image == null) {
        return null;
      } else {
        final tempImage = File(image.path);

        setState(() async {
          pickedImage = tempImage;
          await _uploadImage();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _uploadImage() async {
    if (pickedImage != null) {
      //creating the reference to the location where you want to upload the image
      Reference reference = FirebaseStorage.instance.ref().child(
          'chatsImages/${APIs.getConversationID(widget.user.id)}/${DateTime.now().millisecondsSinceEpoch}');
      //start the upload task
      UploadTask uploadTask = reference.putFile(pickedImage!);

      try {
        // wait to complete the task
        await uploadTask;

        //Get the download url
        String imageUrl = await reference.getDownloadURL();

        APIs.sendMessage(widget.user, imageUrl, Type.image);
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
