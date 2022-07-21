import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';

class ChatData {
  String groupChatId;
  String sellerId;
  String chattingWithId;
  String listingId;

  ChatData(
      {required this.groupChatId,
      required this.sellerId,
      required this.chattingWithId,
      required this.listingId});

  Map<String, dynamic> toJson() {
    return {
      FirestoreChatKeys.groupChatId: groupChatId,
      FirestoreChatKeys.sellerId: sellerId,
      FirestoreChatKeys.chattingWithId: chattingWithId,
      FirestoreChatKeys.listingId: listingId
    };
  }

  factory ChatData.fromDocument(DocumentSnapshot documentSnapshot) {
    String groupChatId = documentSnapshot.id;
    String sellerId = documentSnapshot.get(FirestoreChatKeys.sellerId);
    String chattingWithId =
        documentSnapshot.get(FirestoreChatKeys.chattingWithId);
    String listingId = documentSnapshot.get(FirestoreChatKeys.listingId);

    return ChatData(
        groupChatId: groupChatId,
        sellerId: sellerId,
        chattingWithId: chattingWithId,
        listingId: listingId);
  }
}
