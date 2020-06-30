import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String username;
  DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : username = map["username"],
        id = (reference != null) ? reference.documentID : null;
  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
