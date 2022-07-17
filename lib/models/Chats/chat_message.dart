import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';

class ChatMessage {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  ChatMessage(
      {required this.idFrom,
      required this.idTo,
      required this.timestamp,
      required this.content,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      FirestoreChatKeys.idFrom: idFrom,
      FirestoreChatKeys.idTo: idTo,
      FirestoreChatKeys.timestamp: timestamp,
      FirestoreChatKeys.content: content,
      FirestoreChatKeys.type: type,
    };
  }

  factory ChatMessage.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreChatKeys.idFrom);
    String idTo = documentSnapshot.get(FirestoreChatKeys.idTo);
    String timestamp = documentSnapshot.get(FirestoreChatKeys.timestamp);
    String content = documentSnapshot.get(FirestoreChatKeys.content);
    int type = documentSnapshot.get(FirestoreChatKeys.type);

    return ChatMessage(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        type: type);
  }
}
