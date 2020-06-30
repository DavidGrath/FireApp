import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './chat_screen.dart';
import './add_chat_screen.dart';
import '../models/conversation.dart';
import './settings_screen.dart';

final screens = <Widget>[Container(), HomePage(), SettingsScreen()];

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            setState(() {
              _currentIndex = i;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble), title: Text("")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("")),
          ]),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var userFuture = FirebaseAuth.instance.currentUser();
    return FutureBuilder<FirebaseUser>(
        future: userFuture,
        builder: (context, snapshot) {
          var user = snapshot.data;
          final chatCollection = Firestore.instance
              .collection("user")
              .document(user.uid)
              .collection("data")
              .document("private")
              .collection("conversations");
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                title: Text("FireApp"),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: "Message",
                    ),
                    Tab(
                      text: "Group",
                    ),
                    Tab(
                      text: "Calls",
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return AddChatScreen(chatCollection);
                      }));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Container(
                  padding: EdgeInsets.all(10.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: chatCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: Text("No Data"),
                        );
                      if (snapshot.data.documents.isEmpty) {
                        return Center(
                          child: Text("No Chats"),
                        );
                      }
                      return _buildList(context, snapshot.data.documents);
                    },
                  )),
            ),
          );
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    return ListView.builder(
      itemCount: snapshots.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _storyView();
        }
        Conversation convo = Conversation.fromSnapshot(snapshots[i - 1]);
        return ListTile(
          title: Text(convo.partnerName),
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ChatScreen(convo.partnerName, convo.convoId);
            }));
          },
        );
      },
    );
  }

  Widget _storyView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          CircleAvatar(
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
