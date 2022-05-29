import 'package:fchatty/constants/tab_item.dart';
import 'package:fchatty/custom_widget/custom_bottom_navigation.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/service/notification_receive_service.dart';
import 'package:fchatty/pages/all_chat_page.dart';
import 'package:fchatty/pages/users_page.dart';
import 'package:fchatty/pages/profile_page.dart';
import 'package:fchatty/viewmodel/cubit/all_user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final ClientUser? user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TabItem _currentTab = TabItem.users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.chats: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: BlocProvider(
        create: (context) => AllUserViewCubit(),
        child: const UsersPage(),
      ),
      TabItem.chats: const AllChatsPage(),
      TabItem.profile: const ProfilePage(),
    };
  }

  @override
  void initState() {
    super.initState();
    NotificationReceiveService().initFCM(context);
    //AdmobService().loadStaticBannerAd().load();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CustomBottomNavigation(
        pageCreater: allPages(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          // if (AdmobIslemleri.myBannerAd != null &&
          //     AdmobIslemleri.myBannerAd.id != null) {
          //   print(
          //       " #################### banner null değil dispose edilecek ######################");
          //   try {
          //     AdmobIslemleri.myBannerAd.dispose();
          //     AdmobIslemleri.myBannerAd = null;
          //   } catch (e) {
          //     print("hata:" + e.toString());
          //   }
          // }

          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]!.currentState!.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
