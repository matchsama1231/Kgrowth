class Message {
  const Message(
      this.message,
      this.imageUrl,
      this.sendTime, {
        required this.fromChatGpt,
      });
  final String message;
  final String imageUrl;
  final bool fromChatGpt;
  final DateTime sendTime;

  Message.fromUser(String message, DateTime now)
      : this(message, '', now, fromChatGpt: false);
  Message.fromChatGPT(String message, DateTime now)
      : this(message, '', now, fromChatGpt: true);
  Message.image(String imageUrl, DateTime now)
      : this('', imageUrl, now, fromChatGpt: true);

  Message.waitResponse(DateTime now)
      : this('', '', DateTime.now(), fromChatGpt: true);
}
