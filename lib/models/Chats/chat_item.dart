import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';

class ChatItem {
  String groupChatId;
  String sellerId;
  String chattingWithId;
  String listingId;

  ChatItem(
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

  factory ChatItem.fromDocument(DocumentSnapshot documentSnapshot) {
    String groupChatId = documentSnapshot.id;
    String sellerId = documentSnapshot.get(FirestoreChatKeys.sellerId);
    String chattingWithId =
        documentSnapshot.get(FirestoreChatKeys.chattingWithId);
    String listingId = documentSnapshot.get(FirestoreChatKeys.listingId);

    return ChatItem(
      groupChatId: groupChatId,
      sellerId: sellerId,
      chattingWithId: chattingWithId,
      listingId: listingId);
  }
}
