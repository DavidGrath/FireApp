import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool profileLock = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            margin: EdgeInsets.all(4.0),
            height: 40.0,
            child: TextField(
                style: TextStyle(
                    // fontSize: 20.0,
                    // height: 1.0,
                    ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search Setting",
                    filled: true,
                    fillColor: Colors.grey[600],
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0)))),
          ),
        ),
      ),
      body: Container(child: _buildMainPage()),
    );
  }

  Widget _buildMainPage() {
    return ListView(children: <Widget>[
      Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[700]),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.dashboard),
                ),
                title: Text("Dark Mode"),
                trailing: Switch(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text("Profile Lock"),
                trailing: Switch(
                  value: profileLock,
                  onChanged: (value) {
                    setState(() {
                      profileLock = value;
                    });
                  },
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.chat_bubble),
                ),
                title: Text("Chat Customization"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.notifications_active),
                ),
                title: Text("Notifications"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.pages),
                ),
                title: Text("Privacy"),
                trailing: Icon(Icons.keyboard_arrow_right),
              ), //Divider
            ],
          )),
      Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey[700]),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.lock),
                ),
                title: Text("Logout"),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                  backgroundColor: Colors.red,
                ),
                title: Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ))
    ]);
  }
}
