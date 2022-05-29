import 'package:flutter/material.dart';

enum TabItem { users, chats, profile }

class TabItemData {
  final String title;
  final IconData icon;
  final MaterialColor color;

  TabItemData({required this.title, required this.icon, required this.color});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData(title: "Users", icon: Icons.supervised_user_circle, color: Colors.blueGrey),
    TabItem.chats: TabItemData(title: "Chats", icon: Icons.chat, color: Colors.deepOrange),
    TabItem.profile: TabItemData(title: "Profile", icon: Icons.person, color: Colors.grey),
  };
}
