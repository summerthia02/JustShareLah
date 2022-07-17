import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justsharelah_v1/firebase/firestore_constants.dart';

class ChatMessages {
 String idFrom;
 String idTo;
 String timestamp;
 String content;
 int type;

 ChatMessages(
     {required this.idFrom,
     required this.idTo,
     required this.timestamp,
     required this.content,
     required this.type});

 Map<String, dynamic> toJson() {
   return {
     FirestoreChatConstants.idFrom: idFrom,
     FirestoreChatConstants.idTo: idTo,
     FirestoreChatConstants.timestamp: timestamp,
     FirestoreChatConstants.content: content,
     FirestoreChatConstants.type: type,
   };
 }

 factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
   String idFrom = documentSnapshot.get(FirestoreChatConstants.idFrom);
   String idTo = documentSnapshot.get(FirestoreChatConstants.idTo);
   String timestamp = documentSnapshot.get(FirestoreChatConstants.timestamp);
   String content = documentSnapshot.get(FirestoreChatConstants.content);
   int type = documentSnapshot.get(FirestoreChatConstants.type);

   return ChatMessages(
       idFrom: idFrom,
       idTo: idTo,
       timestamp: timestamp,
       content: content,
       type: type);
 }
}