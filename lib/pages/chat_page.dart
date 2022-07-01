import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/chat_item_page.dart';
import 'package:justsharelah_v1/pages/review_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:justsharelah_v1/models/Chats/ChatWidget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatWidget> list = ChatWidget.list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Chat"), context, '/feed'),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Form(
                child: TextFormField(
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: "Search for Chats...",
                  prefixIcon: Icon(Icons.search_rounded)),
            )),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatItemPage(),
                        ),
                      );
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJxA5cTf-5dh5Eusm0puHbvAhOrCRPtckzjA&usqp=CAU'),
                        ),
                      ),
                    ),
                    title: Text(
                      list[index].contact!.name.toString(),
                      style: kBodyText,
                    ),
                    subtitle: list[index].isTyping!
                        ? Row(
                            children: [
                              SpinKitThreeBounce(
                                color: Colors.blueGrey,
                                size: 20.0,
                              ),
                            ],
                          )
                        : Row(children: [
                            Text(
                              list[index].lastMessage!,
                              style: kBodyTextSmall,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              list[index].lastMessageTime! + " hours ago",
                              style: kBodyTextSmall,
                            )
                          ]),
                  );
                }),
          ),
        ],
      ),

      //     ElevatedButton(
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => MakeReviewPage(),
      //             ));
      //       },
      //       child: Text('Reviews Page'),
      //       style: ElevatedButton.styleFrom(
      //           primary: Colors.black,
      //           elevation: 2,
      //           shadowColor: Colors.black,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(40))),
      //     ),
      //   ],
      //   // ignore: prefer_const_constructors
      // ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
