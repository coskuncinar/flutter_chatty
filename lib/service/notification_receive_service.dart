import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/pages/chat_page.dart';
import 'package:fchatty/viewmodel/cubit/chat_view_cubit.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationReceiveService.showNotification(message);
}

class NotificationReceiveService {
  static final NotificationReceiveService _singleton =
      NotificationReceiveService._internal();

  factory NotificationReceiveService() => _singleton;

  NotificationReceiveService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  BuildContext? myContext;

  initFCM(BuildContext context) async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    myContext = context;
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('app_icon');
    final iOSInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.onTokenRefresh.listen((newToken) async {
      var _currentUser = FirebaseAuth.instance.currentUser;
      await saveToken(_currentUser!.uid, newToken);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage? event) {
      showNotification(event);
    });
  }

  Future<void> saveToken(String userId, String token) async {
    await FirebaseFirestore.instance.collection("tokens").doc(userId).set({
      'token': token,
    });
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  static void showNotification(RemoteMessage? message) async {
    if (message == null) {
      return;
    }

    // message.data.forEach((key, value) {
    //   debugPrint("RemoteMessage Key:" + key.toString());
    //   debugPrint("RemoteMessage Value:" + value.toString());
    // });
    //debugPrint("message.data: " + message.data.toString());

    String url = message.data["sendUserProfileURL"];
    var userURLPath = await _downloadAndSaveImage(url, 'largeIcon');

    var person = Person(
      name: message.data["title"],
      key: '1',
      icon: BitmapFilePathAndroidIcon(userURLPath),
    );

    var _styleInformation = MessagingStyleInformation(
      person,
      messages: [
        Message(message.data["message"], DateTime.now(), person),
      ],
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '111', 'User Messege', //'your channel description',
      //style: AndroidNotificationStyle.Messaging,
      styleInformation: _styleInformation,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
      threadIdentifier: 'thread_id',
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data["title"],
      message.data["message"],
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  Future onSelectNotification(String? payload) async {
    final _userViewCubit = myContext!.read<UserViewCubit>();

    if (payload != null) {
      //debugPrint('notification payload: ' + payload);
      Map<String, dynamic> newNotify = await jsonDecode(payload);
      debugPrint("_userViewCubit:" + _userViewCubit.user!.toString());

      var cu = ClientUser.userIdveUrl(
        userId: newNotify["sendUserId"],
        email: newNotify["sendUserEmail"]!,
        userName: newNotify["sendUserUserName"],
        profilURL: newNotify["sendUserProfileURL"],
      );
      Navigator.of(myContext!, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChatViewCubit(
              currentUser: _userViewCubit.user!,
              chatUser: cu,
            ),
            child: const ChatPage(),
          ),
        ),
      );
    }
  }

  //onDidReceiveLocalNotification(int id, String title, String body, String payload)   {}
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
