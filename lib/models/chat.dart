import 'package:cloud_firestore/cloud_firestore.dart';

const int TYPE_TEXT = 0;
const int TYPE_IMAGE = 1;

class Chat {
  String id;
  final String content;
  final String sender;
  DateTime timestamp;
  int type = TYPE_TEXT;
  DocumentReference reference;

  Chat(this.content, this.sender, [this.timestamp, this.type = TYPE_TEXT]);
  Map<String, dynamic> toServerMap() {
    var map = Map<String, dynamic>();
    map['content'] = content;
    map['sender'] = sender;
    map['type'] = type;
    map['timestamp'] = FieldValue.serverTimestamp();
    return map;
  }

  Chat.fromMap(Map<String, dynamic> map, {this.reference})
      : content = map["content"],
        sender = map["sender"],
        id = (reference != null) ? reference.documentID : null,
        type = (map["type"] != null) ? map["type"] : TYPE_TEXT,
        timestamp = (map["timestamp"] != null)
            ? (map["timestamp"] as Timestamp).toDate()
            : 0;
  Chat.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
