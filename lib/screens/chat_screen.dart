import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kgrowth/components/drawer.dart';
import 'package:kgrowth/components/text_field.dart';
import 'package:kgrowth/model/chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final openAI = OpenAI.instance.build(
    token: dotenv.env['APIKEY']!,
    isLog: true,
  );

  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = false;
  final _messages = <Message>[];

  static Color colorBackground = Colors.grey;
  static Color colorMyMessage = Colors.blueGrey.shade200;
  static Color colorOthersMessage = Colors.grey.shade200;
  static Color colorTime = Colors.grey.shade900;
  static Color colorAvatar = Colors.grey.shade400;


  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kgrowth'),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ColoredBox(
                  color: colorBackground,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final showLoadingIcon =
                            _isLoading && index == _messages.length - 1;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: message.fromChatGpt
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.fromChatGpt)
                                SizedBox(
                                    width: deviceWidth * 0.1,
                                    child: CircleAvatar(
                                        backgroundColor: colorAvatar,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                              'assets/logo.png'),
                                        ))),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (!message.fromChatGpt)
                                    Text(
                                      _formatDateTime(message.sendTime),
                                      style: TextStyle(color: colorTime),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: deviceWidth * 0.7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: message.fromChatGpt
                                            ? colorOthersMessage
                                            : colorMyMessage,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: showLoadingIcon
                                            ? const CircularProgressIndicator()
                                            : message.imageUrl.isNotEmpty
                                            ? Image.network(
                                          message.imageUrl,
                                          frameBuilder: (BuildContext
                                          context,
                                              Widget child,
                                              int? frame,
                                              bool
                                              wasSynchronouselyLoaded) {
                                            if (!wasSynchronouselyLoaded) {
                                              _scrollDown();
                                            }
                                            return child;
                                          },
                                          loadingBuilder:
                                              (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                              loadingProgress) {
                                            if (loadingProgress != null) {
                                              return const CircularProgressIndicator();
                                            }
                                            return child;
                                          },
                                        )
                                            : Text(
                                          message.message,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (message.fromChatGpt)
                                    Text(
                                      _formatDateTime(message.sendTime),
                                      style: TextStyle(color: colorTime),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                )),
            Container(
              height: 100,
              color: Colors.grey[200],
              child: Row(
                children:[
              Expanded(
                child: MyTextField(controller: _textEditingController,
                            hintText: 'メッセージ',
                            obscureText: false),
              ),
                  IconButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        _onTapSend(_textEditingController.text);
                      },
                      icon: Icon(
                        Icons.send,
                        color: _isLoading ? Colors.grey : Colors.black,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _onTapSend(String userMessage) {
    setState(() {
      _isLoading = true;
      _messages.addAll([
        Message.fromUser(userMessage, DateTime.now()),
        Message.waitResponse(DateTime.now()),
      ]);
      _scrollDown();
    });

    _sendMessage(userMessage).then((chatGptMessage) {
      setState(() {
        _messages.last =
            Message.fromChatGPT(chatGptMessage.trim(), DateTime.now());
        _isLoading = false;
      });
      _scrollDown();
    });
  }

  Future<String> _sendMessage(String message) async {
    final request = CompleteText(
        prompt: message, model: Model.textDavinci3, maxTokens: 200);

    final response = await openAI.onCompletion(request: request);
    return response!.choices.first.text;
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }
}