import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddChatScreen extends StatefulWidget {
  CollectionReference chatCollection;
  AddChatScreen(this.chatCollection);
  @override
  State<StatefulWidget> createState() => _AddChatState(chatCollection);
}

class _AddChatState extends State<AddChatScreen> {
  CollectionReference chatCollection;
  _AddChatState(this.chatCollection);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatCollection.snapshots(),
        builder: (context, snapshot) {
          var chats = snapshot.data;
          return Scaffold(
              appBar: AppBar(title: Text("Start Chat")),
              body: Container(
                padding: EdgeInsets.all(10.0),
                child: _buildUserList(chats.documents),
              ));
        });
  }

  Widget _buildUserList(List<DocumentSnapshot> convos) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text("No Data"));
        }
        var users = snapshot.data.documents;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, i) {
            var user = users[i];
            return ListTile(
              title: Text(user.data['username']),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  var chattedWith = convos.firstWhere((convo) {
                    return convo.data["username"] == user.data["username"];
                  }, orElse: () {
                    return null;
                  });
                  String chattedWithId = (chattedWith != null)
                      ? chattedWith.data["convoId"]
                      : null;
                  return ChatScreen(user.data['username'], chattedWithId);
                }));
              },
            );
          },
        );
      },
    );
  }
}
