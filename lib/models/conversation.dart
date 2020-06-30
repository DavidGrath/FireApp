import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String id;
  String partnerName;
  String convoId;
  DocumentReference documentReference;

  Conversation.fromMap(Map<String, dynamic> map, {this.documentReference})
      : id = documentReference.documentID,
        partnerName = map['username'],
        convoId = map['convoId'];
  Conversation.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentReference: snapshot.reference);
}
