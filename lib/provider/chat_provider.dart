import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
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
  static Future<Map<String, dynamic>?> getChat(String groupChatId) async {
    Map<String, dynamic>? chatData;
    await firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .where(FirestoreChatKeys.groupChatId, isEqualTo: groupChatId)
        .get()
        .then(
      (res) {
        print("chatData query successful");
        if (res.docs.isEmpty) {
          chatData = null;
          return;
        }
        chatData = res.docs.first.data();
      },
      onError: (e) {
        print("Error completing: $e");
        chatData = null;
      },
    );
    print(chatData);
    return chatData;
  }

  static Future<void> makeNewChat(ChatItem chatItem) async {
    String groupChatId = chatItem.groupChatId;
    String sellerId = chatItem.sellerId;
    String chattingWithId = chatItem.chattingWithId;
    String listingId = chatItem.listingId;

    // add groupChatID to users chat field
    Map<String, dynamic> sellerData =
        await UserDataService.getUserDataFromId(sellerId);
    Map<String, dynamic> chattingWithData =
        await UserDataService.getUserDataFromId(chattingWithId);
    if (!sellerData["chats"].contains(groupChatId)) {
      sellerData["chats"].add(groupChatId);
      updateFirestoreData(
          FirestoreGeneralKeys.pathUserCollection, sellerId, sellerData);
    }
    if (!chattingWithData["chats"].contains(groupChatId)) {
      chattingWithData["chats"].add(groupChatId);
      updateFirestoreData(FirestoreGeneralKeys.pathUserCollection,
          chattingWithId, chattingWithData);
    }

    return firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .doc(chatItem.groupChatId)
        .set(chatItem.toJson());
  }

  static Future<bool> handleChatRequest(ChatItem chatItem) async {
    print("HANDLING CHAT REQUEST");
    Map<String, dynamic>? chatData = await getChat(chatItem.groupChatId);
    if (chatData == null) {
      makeNewChat(chatItem);
      return false;
    }
    print("chat exists");
    return true;
  }

  static Stream<QuerySnapshot> getAllChatData(int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(FirestoreChatKeys.pathChatCollection)
          .limit(limit)
          //TODO: Implement search function
          // .where(FirestoreUserKeys.username, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(FirestoreChatKeys.pathChatCollection)
          .limit(limit)
          .snapshots();
    }
  }

  static Stream<QuerySnapshot> getUserSellerChatData(String uid) {
    return firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .where(FirestoreChatKeys.sellerId, isEqualTo: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserChattingWithChatData(String uid) {
    return firebaseFirestore
        .collection(FirestoreChatKeys.pathChatCollection)
        .where(FirestoreChatKeys.chattingWithId, isEqualTo: uid)
        .snapshots();
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
