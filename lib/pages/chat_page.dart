import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/firebase/auth_methods.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/pages/chat_item_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:justsharelah_v1/pages/review_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/debouncer.dart';
import 'package:justsharelah_v1/utils/keyboard_utils.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late String? currentUserId;

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  // ======================= Widgets =====================
  Widget buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.person_search,
            size: 36,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: searchTextEditingController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    buttonClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    buttonClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                },
                decoration: kTextFormFieldDecoration.copyWith(
                    hintText: "Search for user")),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchTextEditingController.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      UserData userData = UserDataService.fromDocument(documentSnapshot);
      if (userData.uid == currentUserId) {
        return const SizedBox.shrink();  
      } else {
        return TextButton(
          onPressed: () async {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            String userProfPicURL =
              await AuthMethods.getUserDetails().then((userData) => userData.imageUrl!);
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => ChatItemPage(
                        otherId: userData.uid!,
                        otherAvatar: userData.imageUrl!,
                        otherNickname: userData.userName!,
                        userProfPicUrl: userProfPicURL,
                        otherPhoneNumber: userData.phoneNumber!,
                      )));
          },
          child: ListTile(
            leading: userData.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      userData.imageUrl!,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
            title: Text(
              userData.userName!,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  // =========== Flutter methods ======================

  @override
  void initState() {
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Chat"), context, '/feed'),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FireStoreMethods.getFirestoreChatData(
                  FirestoreGeneralKeys.pathUserCollection, _limit, _textSearch),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data?.docs[index]),
                      controller: scrollController,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    );
                  } else {
                    return const Center(
                      child: Text('No user found...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
