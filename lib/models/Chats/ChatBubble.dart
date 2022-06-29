class ChatBubble {
  final String? senderId;
  final String? message;

  ChatBubble({this.senderId, this.message});

  static List<ChatBubble> list = [
    ChatBubble(
      senderId: "1",
      message: "Hi Marti! do you have already reports?",
    ),
    ChatBubble(
      senderId: "1",
      message: "Sure we can talk tomorrow",
    ),
    ChatBubble(
      senderId: "1",
      message: "Hi Marti",
    ),
    ChatBubble(
      senderId: "2",
      message: "I'd like to discuss about reports for kate",
    ),
    ChatBubble(
      senderId: "2",
      message: "Are you available tomorrow at 3PM?",
    ),
    ChatBubble(
      senderId: "2",
      message: "Hi jonathan",
    ),
  ];
}
