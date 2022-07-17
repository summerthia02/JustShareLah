import 'contact_model.dart';

class ChatWidget {
  final bool? isTyping;
  final String? lastMessage;
  final String? lastMessageTime;
  final ContactModel? contact;

  ChatWidget(
      {this.isTyping, this.lastMessage, this.lastMessageTime, this.contact});

  static List<ChatWidget> list = [
    ChatWidget(
      isTyping: false,
      lastMessage: "hello!",
      lastMessageTime: "2d",
      contact: ContactModel(name: "Martin Valencia"),
    ),
    ChatWidget(
      isTyping: false,
      lastMessage: "Sure, no problem Jhon!",
      lastMessageTime: "2d",
      contact: ContactModel(name: "Maria Illescas"),
    ),
    ChatWidget(
      isTyping: false,
      lastMessage: "thank you Jhon!",
      lastMessageTime: "2d",
      contact: ContactModel(name: "Kate Stranger"),
    ),
  ];
}
