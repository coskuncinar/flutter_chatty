import 'package:flutter/cupertino.dart';

import 'package:fchatty/constants/tab_item.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation(
      {Key? key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.pageCreater,
      required this.navigatorKeys})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageCreater;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  void initState() {
    super.initState();
    // AdmobIslemleri.admobInitialize();
    // if (AdmobIslemleri.myBannerAd == null) {
    //   print("my banner null atanacak");
    // }

    //myBannerAd.load();
  }

  @override
  void dispose() {
    // if (AdmobIslemleri.myBannerAd != null) {
    //   AdmobIslemleri.myBannerAd.dispose();
    //   AdmobIslemleri.myBannerAd = null;
    //   print("my banner null oldu");
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItem.users),
          _createNavItem(TabItem.chats),
          _createNavItem(TabItem.profile),
        ],
        onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];
        //final showItemNN = widget.pageCreater[showItem];
        return CupertinoTabView(
            navigatorKey: widget.navigatorKeys[showItem],
            builder: (context) {
              return widget.pageCreater[showItem]!;
            });
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItem tabItem) {
    TabItemData? newTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(newTab!.icon),
      label: newTab.title,
      backgroundColor: newTab.color,
    );
  }
}
