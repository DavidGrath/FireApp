import 'package:flutter/material.dart';
import '../models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/chat.dart';
import 'dart:convert';
import './add_chat_screen.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  String partnerName, convoId;
  ChatScreen(this.partnerName, this.convoId);

  @override
  State<StatefulWidget> createState() => _ChatScreenState(partnerName, convoId);
}

class _ChatScreenState extends State<ChatScreen> {
  var chatController = TextEditingController();
  var bubbleTextStyle = TextStyle(color: Colors.white);
  String partnerName, convoId;
  _ChatScreenState(this.partnerName, this.convoId);

  String username;
  FirebaseUser user;

  Future<CollectionReference> getChatReference() async {
    CollectionReference chatReference;
    user = await FirebaseAuth.instance.currentUser();
    var userSnapshot =
        await Firestore.instance.collection('user').document(user.uid).get();
    username = userSnapshot.data["username"];

    if (convoId == null) {
      //Invoke Cloud Function through HTTP Call
      var token = (await user.getIdToken()).token;
      var request = Map<String, dynamic>();
      // request['firstMessage'] = Chat(chatController.text, user.displayName);
      request['partner'] = partnerName;
      var response = await http.post(
          "https://us-central1-fireapp-8b41a.cloudfunctions.net/chat",
          body: jsonEncode(request),
          headers: {
            "Authorization": token,
            "Content-Type": "application/json"
          });
      if (response.statusCode == 200) {
        convoId =
            (jsonDecode(response.body) as Map<String, dynamic>)['convoId'];
      } else {
        debugPrint("no 200's here ${response.body}");
        Navigator.of(context).pop();
      }
      chatReference = Firestore.instance
          .collection('chats')
          .document(convoId)
          .collection(convoId)
          .reference();
    } else {
      chatReference = Firestore.instance
          .collection('chats')
          .document(convoId)
          .collection(convoId)
          .reference();
    }
    return chatReference;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            //Because for some reason using an aligned parent Container doesn't work
            Align(alignment: Alignment.centerLeft, child: Text(partnerName)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "offline",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 10.0),
              ),
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder<CollectionReference>(
          future: getChatReference(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: Text("No Data"));
            var chatReference = snapshot.data;
            var chatQuery =
                chatReference.orderBy("timestamp", descending: true);
            return StreamBuilder<QuerySnapshot>(
                stream: chatQuery.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: Text("No Data"));
                  var chats = snapshot.data.documents;
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              reverse: true,
                              itemCount: chats.length,
                              itemBuilder: (context, i) {
                                return _buildListItem(chats[i]);
                              }),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: chatController,
                                decoration: InputDecoration(
                                    hintText: "Type your message"),
                              ),
                            ),
                            Builder(builder: (context) {
                              return IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  try {
                                    await chatReference.add(Chat(
                                      chatController.text,
                                      username,
                                    ).toServerMap());
                                    chatController.text = "";
                                  } catch (e) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Error"),
                                    ));
                                  }
                                },
                              );
                            })
                          ],
                        )
                      ],
                    ),
                  );
                });
          }),
    );
  }

  Widget _buildListItem(DocumentSnapshot snapshot) {
    var chat = Chat.fromSnapshot(snapshot);
    var widget = (chat.sender == username)
        ? _buildSentView(chat)
        : _buildReceivedView(chat);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: widget,
    );
  }

  Widget _buildSentView(Chat chat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(0.0))),
          child: Text(
            chat.content,
            style: bubbleTextStyle,
          ),
        )
      ],
    );
  }

  Widget _buildReceivedView(Chat chat) {
    var storage = FirebaseStorage.instance
        .ref()
        .child("users/sHaa2F7F0dfdQArEUNvyYk0DC362/profile_picture.jpg");
    var url = storage.getDownloadURL();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FutureBuilder<dynamic>(
            future: url,
            builder: (context, snapshot) {
              return CircleAvatar(
                  child: Image.network(snapshot.data as String));
            }),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0))),
          child: Text(
            chat.content,
            style: bubbleTextStyle,
          ),
        )
      ],
    );
  }
}
