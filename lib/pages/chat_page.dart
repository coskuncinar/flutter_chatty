import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:fchatty/viewmodel/cubit/chat_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  //InterstitialAd myInterstitialAd;

  @override
  void initState() {
    super.initState();
    // if (AdmobIslemleri.myBannerAd != null) {
    //   print("my banner null oldu chat sayfasında");
    //   AdmobIslemleri.myBannerAd.dispose();
    // }
    _scrollController.addListener(_scrollListener);

    // if (AdmobIslemleri.kacKereGosterildi <= 2) {
    //   myInterstitialAd = AdmobIslemleri.buildInterstitialAd();
    //   myInterstitialAd
    //     ..load()
    //     ..show();
    //   AdmobIslemleri.kacKereGosterildi++;
    // }
  }

  @override
  void dispose() {
    //if (myInterstitialAd != null) myInterstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final _chatModel = Provider.of<ChatViewModel>(context);
    final _chatModel = context.read<ChatViewCubit>();

    return Scaffold(
      appBar: //AppBar(
          PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(40),
                  backgroundImage: NetworkImage(_chatModel.chatUser.profilURL!),
                ),
              ],
            ),
          ),
          title: Text(_chatModel.chatUser.userName!),
        ),
      ),
      body: BlocBuilder<ChatViewCubit, ChatViewCubitState>(
        builder: (context, state) {
          if (state is ChatViewCubitStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ChatViewCubitStateLoaded) {
            return Center(
              child: Column(
                children: <Widget>[
                  _buildMessageList(),
                  _buildGetNewMessage(),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocConsumer<ChatViewCubit, ChatViewCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        final chatModel = context.read<ChatViewCubit>();
        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              //debugPrint("chatModel.messageList!.length" + chatModel.messageList!.length.toString());

              if (chatModel.hasMoreLoading && chatModel.messageList!.length == index) {
                return _loadingIndicator();
              } else {
                return _createChatBallon(chatModel.messageList![index]);
              }
            },
            itemCount: chatModel.hasMoreLoading ? chatModel.messageList!.length + 1 : chatModel.messageList!.length,
          ),
        );
      },
    );
  }

  Widget _buildGetNewMessage() {
    //final _chatModel = Provider.of<ChatViewCubit>(context);
    final _chatModel = context.read<ChatViewCubit>();
    return Container(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: Colors.blueGrey,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Message",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.navigate_next,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_messageController.text.trim().isNotEmpty) {
                  var _savingMessage = Message(
                    from: _chatModel.currentUser.userId,
                    to: _chatModel.chatUser.userId,
                    isFromMe: true,
                    messageOwnerId: _chatModel.currentUser.userId,
                    message: _messageController.text,
                  );

                  var result = await _chatModel.saveMessage(_savingMessage, _chatModel.currentUser);
                  //debugPrint("result:" + result.toString());
                  if (result) {
                    _messageController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createChatBallon(Message currentMessage) {
    Color _comingMessageColor = Colors.blue;
    Color _goingMessageColor = Theme.of(context).primaryColor;
    //final _chatModel = Provider.of<ChatViewCubit>(context);
    //final _chatModel = context.read<ChatViewCubit>();
    var _timeNewValue = "";

    try {
      _timeNewValue = _showTime(currentMessage.createdDate ?? Timestamp(1, 1));
    } catch (e) {
      // debugPrint("error var:" + e.toString());
    }

    var isMessageMine = currentMessage.isFromMe;
    if (isMessageMine) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _goingMessageColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      currentMessage.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_timeNewValue),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // CircleAvatar(
                //   backgroundColor: Colors.grey.withAlpha(40),
                //   backgroundImage: NetworkImage(_chatModel.chatUser.profilURL!),
                // ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _comingMessageColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(currentMessage.message),
                  ),
                ),
                Text(_timeNewValue),
              ],
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _showTime(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatedTime = _formatter.format(date.toDate());
    return _formatedTime;
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _getOldMessages();
    }
  }

  void _getOldMessages() async {
    final _chatModel = context.read<ChatViewCubit>();
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.getMoreMessage();
      _isLoading = false;
    }
  }

  _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
