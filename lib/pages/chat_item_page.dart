import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/models/chat_item.dart';
import 'package:justsharelah_v1/models/chat_message.dart';
import 'package:justsharelah_v1/pages/review_page.dart';
import 'package:justsharelah_v1/pages/sharecredits.dart';
import 'package:justsharelah_v1/provider/chat_provider.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class ChatItemPage extends StatefulWidget {
  final ChatItem chatData;
  final String otherId;
  final String otherAvatar;
  final String otherNickname;
  final String userProfPicUrl;
  final String otherPhoneNumber;
  final String listingId;
  final String listingTitle;

  const ChatItemPage({
    Key? key,
    required this.otherNickname,
    required this.otherAvatar,
    required this.otherId,
    required this.userProfPicUrl,
    required this.otherPhoneNumber,
    required this.listingId,
    required this.listingTitle,
    required this.chatData,
  }) : super(key: key);

  @override
  State<ChatItemPage> createState() => _ChatItemPageState();
}

class _ChatItemPageState extends State<ChatItemPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';
  // chatingWithId = buyerId
  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';
  bool listingForRent = false;
  bool hasReviewed = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getListingType();
    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
    leftReview();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() async {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (widget.otherId.compareTo(currentUserId) > 0) {
      groupChatId = '${widget.listingId} : ${widget.otherId} - $currentUserId';
    } else {
      groupChatId = '${widget.listingId} : $currentUserId - ${widget.otherId}';
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {}
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    var url = 'tel://$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = ChatProvider.uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      ChatProvider.sendChatMessage(
          content, type, groupChatId, currentUserId, widget.otherId);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreChatKeys.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreChatKeys.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // check if left reviews already
  Future<bool?> leftReview() async {
    CollectionReference reviewCollection =
        FirebaseFirestore.instance.collection("Reviews");
    Query reviewDoc = reviewCollection
        .where("listingId", isEqualTo: widget.listingId)
        .where("reviewById", isEqualTo: currentUserId)
        .where("reviewForId", isEqualTo: widget.otherId);
    await reviewDoc.get().then((value) => {
          if (value.docs.isEmpty)
            {
              setState(() {
                hasReviewed = false;
              }),
            }
          else
            {
              setState(() {
                hasReviewed = true;
              }),
            }
        });
  }

  // get listing type
  Future<bool?> getListingType() async {
    CollectionReference listings =
        FirebaseFirestore.instance.collection("listings");
    // get username for particular reviewer
    Query listingsDoc = listings.where("uid", isEqualTo: widget.listingId);

    // String userName = userDoc.print("hi");
    await listingsDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        listingForRent = res.docs[0]["forRent"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return listingForRent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.listingTitle),
        actions: [
          IconButton(
            onPressed: () {
              _callPhoneNumber(widget.otherPhoneNumber);
            },
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // make an offer button if user is a buyer
              const SizedBox(
                height: 15,
              ),
              // only can make an offer if it is your listing
              // i.e. chatData.sellerId != currentUser
              // make offer button pressed -> makeOffer set to truen
              if (widget.chatData.sellerId != currentUserId &&
                  widget.chatData.madeOffer == false)
                buildButtonField("Make an Offer", Colors.green, 20, () {
                  FireStoreMethods().makeChatOffer(widget.chatData.groupChatId);
                })
              else
                Container(),
              const SizedBox(
                height: 10,
              ),
              widget.chatData.sellerId != currentUserId &&
                      widget.chatData.madeOffer == true
                  ? const Text("Offer has been made !", style: kBodyTextSmall)
                  : Container(),

              const SizedBox(
                height: 10,
              ),
              // IF BUYER, if accepted offer then say accept then can make reviews
              widget.chatData.sellerId != currentUserId &&
                      widget.chatData.acceptedOffer == true
                  ? const Text("Seller has accepted your offer !",
                      style: kBodyTextSmall)
                  : Container(),

              // if i am the seller and buyer has made an offer
              // button to accept offer
              //  upon offer accpetance -> successful transaction

              // if user is seller + buyer has made offer ->
              // widget to say "buyer made an offer"

              hasReviewed == true
                  ? Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Review has been made! Thanks for Reviewing! ",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              (widget.chatData.madeOffer &&
                      widget.chatData.sellerId == currentUserId &&
                      widget.chatData.acceptedOffer == false)
                  ? Column(
                      children: [
                        infoText("Buyer has made an offer !"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Do you want to accept the Offer ? ",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildButtonField("YES !", Colors.blue, 15, () {
                          FireStoreMethods()
                              .acceptOffer(widget.chatData.groupChatId);
                        })
                      ],
                    )
                  : Container(),
              // already accepted and is seller
              widget.chatData.acceptedOffer &&
                      widget.chatData.sellerId == currentUserId
                  ? Text("You have accepted the offer already !")
                  : Container(),
              // make review when accepted offer
              widget.chatData.acceptedOffer && hasReviewed == false
                  ? buildButtonField(
                      "Leave a Review",
                      Colors.cyan,
                      20,
                      () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MakeReviewPage(
                                reviewForId: widget.otherId,
                                listingId: widget.listingId,
                              ),
                            ));
                      },
                    )
                  : Container(),
              // if acceptedOffer and forRent == false (show sharecreds screen)
              widget.chatData.acceptedOffer && listingForRent == false
                  ? TextButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShareCreditsScreen(
                                    isBuyer: widget.chatData.sellerId !=
                                        currentUserId,
                                    listingId: widget.listingId,
                                  ),
                                ))
                          },
                      child: Text("Click Here to View Updated Share Credits "))
                  : Container(),

              const SizedBox(
                height: 20,
              ),
              buildListMessage(),
              buildMessageInput(),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container infoText(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(30)),
      alignment: Alignment.center,
      height: 40,
      width: 250,
      child: Text(text, style: kBodyTextSmall),
    );
  }

  Widget messageBubble(
      {required String chatContent,
      required EdgeInsetsGeometry? margin,
      Color? color,
      Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: margin,
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        chatContent,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }

  Widget chatImage({required String imageSrc, required Function onTap}) {
    return OutlinedButton(
      onPressed: onTap(),
      child: Image.network(
        imageSrc,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder:
            (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null &&
                        loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) => errorContainer(),
      ),
    );
  }

  ElevatedButton buildButtonField(
      String text, Color color, double length, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: length),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, letterSpacing: 2.5, color: Colors.black),
      ),
    );
  }

  Widget errorContainer() {
    return Container(
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        'assets/images/logo.png',
        height: 200,
        width: 200,
      ),
    );
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera_alt,
                size: 28,
              ),
            ),
          ),
          Flexible(
              child: TextField(
            focusNode: focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            decoration:
                kTextFormFieldDecoration.copyWith(hintText: 'type here...'),
            onSubmitted: (value) {
              onSendMessage(textEditingController.text, MessageType.text);
            },
          )),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessage chatMessages = ChatMessage.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(right: 10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          widget.userProfPicUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
            isMessageSent(index)
                ? Container(
                    margin: const EdgeInsets.only(right: 50, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)
                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          widget.otherAvatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        chatContent: chatMessages.content,
                        margin: const EdgeInsets.only(left: 10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatMessages.timestamp),
                        ),
                      ),
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: ChatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]));
                  } else {
                    return Center(
                      child: Text(
                          'Talk to ${widget.otherNickname} about the transaction!'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
