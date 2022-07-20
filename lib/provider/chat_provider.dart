import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/models/chats/chat_item.dart';
import 'package:justsharelah_v1/models/chats/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  static Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  static Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreChatKeys.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreChatKeys.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  static void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreChatKeys.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    ChatMessage chatMessages = ChatMessage(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

  // ==================CHAT STUFF========================
  static Stream<QuerySnapshot> getChat(String groupChatId) {
    return firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .snapshots();
  }

  static Future<void> makeNewChat(ChatItem chatItem) {
    String groupChatId = chatItem.groupChatId;
    String sellerId = chatItem.sellerId;
    String chattingWithId = chatItem.chattingWithId;
    String listingId = chatItem.listingId;

    return firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .doc(chatItem.groupChatId)
        .set(chatItem.toJson());
  }

  static Future<bool> handleChatRequest(ChatItem chatItem) async {
    Stream<QuerySnapshot> chatSnapshot = getChat(chatItem.groupChatId);
    if (await chatSnapshot.isEmpty) {
      makeNewChat(chatItem);
      return false;
    }
    return true;
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
