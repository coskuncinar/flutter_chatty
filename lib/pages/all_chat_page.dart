import 'package:fchatty/models/parent_message.model.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/pages/chat_page.dart';
import 'package:fchatty/viewmodel/cubit/chat_view_cubit.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({Key? key}) : super(key: key);

  @override
  State<AllChatsPage> createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();
    // RewardedVideoAd.instance.load(
    //     adUnitId: AdmobIslemleri.odulluReklamTest,
    //     targetingInfo: AdmobIslemleri.targetingInfo);

    // RewardedVideoAd.instance.listener =
    //     (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
    //   if (event == RewardedVideoAdEvent.rewarded) {
    //     print(" *************** ODULLU REKLAM ***** ODUL VER");
    //     odulluReklamLoad();
    //   } else if (event == RewardedVideoAdEvent.loaded) {
    //     print(
    //         " *************** ODULLU REKLAM ***** REKLAM yuklendı ve gosterilecek");
    //     RewardedVideoAd.instance.show();
    //   } else if (event == RewardedVideoAdEvent.closed) {
    //     print(" *************** ODULLU REKLAM ***** REKLAM KAPATILDI");
    //   } else if (event == RewardedVideoAdEvent.failedToLoad) {
    //     print(" *************** ODULLU REKLAM ***** REKLAM BULUNAMADI");
    //     odulluReklamLoad();
    //   } else if (event == RewardedVideoAdEvent.completed) {
    //     print(" *************** ODULLU REKLAM ***** COMPLETED");
    //   }
    // };
  }

  void odulluReklamLoad() {
    // RewardedVideoAd.instance.load(
    //     adUnitId: AdmobIslemleri.odulluReklamTest,
    //     targetingInfo: AdmobIslemleri.targetingInfo);
  }

  @override
  Widget build(BuildContext context) {
    final userModel = context.read<UserViewCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: FutureBuilder<List<ParentMessage>>(
        future: userModel.getAllConversations(userModel.user!.userId),
        builder: (context, rChatList) {
          if (!rChatList.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allChats = rChatList.data;

            if (allChats != null && allChats.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshList,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var currentChat = allChats[index];

                    return GestureDetector(
                      onTap: () {
                        var cu = ClientUser.userIdveUrl(
                          userId: currentChat.chatUserId,
                          email: currentChat.chatUserEmail!,
                          userName: currentChat.chatUserName,
                          profilURL: currentChat.chatUserProfileURL,
                        );

                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => ChatViewCubit(
                                currentUser: userModel.user!,
                                chatUser: cu,
                              ),
                              child: const ChatPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(currentChat.chatUserName!),
                        subtitle: Text(currentChat.lastMessage),
                        trailing: Text(currentChat.diffDate!),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.withAlpha(40),
                          backgroundImage:
                              NetworkImage(currentChat.chatUserProfileURL!),
                        ),
                      ),
                    );
                  },
                  itemCount: allChats.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshList,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 100,
                          ),
                          const Text(
                            "Empty",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _refreshList() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
}
