import 'dart:io';
import 'package:fchatty/data/abstract/i_auth_service.dart';
import 'package:fchatty/data/concreate/fake_auth_service.dart';
import 'package:fchatty/service/notification_send_service.dart';
import 'package:fchatty/locator.dart';
import 'package:fchatty/models/parent_message.model.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:fchatty/data/abstract/i_data_service.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';

enum AppMode { debug, release }

class UserRepository implements IAuthService {
  final _dataService = locator<IDataService>();
  AppMode appMode = AppMode.debug;
  final authService = locator<IAuthService>();

  List<ClientUser> allUsers = [];
  Map<String, String> userToken = {};

  final NotificationSendService _notificationService = locator<NotificationSendService>();

  UserRepository() {
    if (authService.runtimeType == FakeAuthService) {
      appMode = AppMode.debug;
      debugPrint("AppMode:FakeAuthService");
    } else {
      appMode = AppMode.release;
      debugPrint("AppMode:FirebaseAuthService");
    }
  }

  @override
  Future<ClientUser?> currentUser() async {
    ClientUser? user = await authService.currentUser();
    if (appMode == AppMode.debug) {
      return user;
    }
    if (user != null) {
      user = await _dataService.readUser(user.userId);
      //debugPrint(user.toString());
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() {
    return authService.signOut();
  }

  @override
  Future<ClientUser?> signInAnonymously() async {
    return await authService.signInAnonymously();
  }

  @override
  Future<ClientUser?> signInWithGoogle() async {
    ClientUser? user = await authService.signInWithGoogle();
    if (appMode == AppMode.debug) {
      return user;
    }
    if (user != null) {
      bool result = await _dataService.saveUser(user);
      if (result) {
        return await _dataService.readUser(user.userId);
      } else {
        await authService.signOut();
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<ClientUser?> signInWithFacebook() async {
    ClientUser? user = await authService.signInWithFacebook();
    if (appMode == AppMode.debug) {
      return user;
    }
    if (user != null) {
      bool result = await _dataService.saveUser(user);
      if (result) {
        return await _dataService.readUser(user.userId);
      } else {
        await authService.signOut();
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<ClientUser?> createUserWithEmailandPassword(String email, String password) async {
    ClientUser? user = await authService.createUserWithEmailandPassword(email, password);
    if (appMode == AppMode.debug) {
      return user;
    }

    if (user != null) {
      bool result = await _dataService.saveUser(user);
      if (result) {
        return await _dataService.readUser(user.userId);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<ClientUser?> signInWithEmailandPassword(String email, String password) async {
    ClientUser? user = await authService.signInWithEmailandPassword(email, password);
    if (appMode == AppMode.debug) {
      return user;
    }

    if (user != null) {
      bool result = await _dataService.saveUser(user);
      if (result) {
        return await _dataService.readUser(user.userId);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    if (appMode == AppMode.debug) {
      return false;
    }
    return await _dataService.updateUserName(userId, newUserName);
  }

  Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.debug) {
      return "download_file_link";
    }

    var profilFotoURL = await _dataService.uploadFile(userID, fileType, profilFoto);
    await _dataService.updateProfilFoto(userID, profilFotoURL);
    return profilFotoURL;
  }

  Stream<List<Message>> getMessages(String currentUserID, String chatUserId) {
    if (appMode == AppMode.debug) {
      return const Stream.empty();
    }

    return _dataService.getMessages(currentUserID, chatUserId);
  }

  Future<bool> saveMessage(Message saveMessage, ClientUser currentUser) async {
    if (appMode == AppMode.debug) {
      return true;
    }

    var dbResult = await _dataService.saveMessage(saveMessage);

    if (dbResult) {
      String? token = "";
      if (userToken.containsKey(saveMessage.to)) {
        token = userToken[saveMessage.to];
        // if (token != null) {
        //   debugPrint("Local Token: " + token);
        // } else {
        //   debugPrint("Local Token: EMPTY!!!!!!!");
        // }
      } else {
        token = await _dataService.getToken(saveMessage.to);
        if (token != null) {
          userToken[saveMessage.to] = token;
        }
        // if (token != null) {
        //   debugPrint("DB Token: " + token);
        // } else {
        //   debugPrint("DB Token: EMPTY!!!!!!!");
        // }
      }

      //var result = true;
      if (token != null) {
        //result =
        await _notificationService.sendNotification(saveMessage, currentUser, token);
      }
      //Even if NotificationService gives error , SaveMessage return true!
      //return result;
      return true;
    } else {
      return false;
    }
  }

  Future<List<ParentMessage>> getAllConversations(String userId) async {
    if (appMode == AppMode.debug) {
      return [];
    }
    DateTime times = await _dataService.showTime(userId);
    var allConversations = await _dataService.getAllConversations(userId);
    for (var singleConv in allConversations) {
      var userInUserList = findUserFromList(singleConv.chatUserId);

      if (userInUserList != null) {
        singleConv.chatUserName = userInUserList.userName;
        singleConv.chatUserProfileURL = userInUserList.profilURL;
        singleConv.chatUserEmail = userInUserList.email;
      } else {
        var getDbUser = await _dataService.readUser(singleConv.chatUserId);
        singleConv.chatUserName = getDbUser.userName;
        singleConv.chatUserProfileURL = getDbUser.profilURL;
        singleConv.chatUserEmail = getDbUser.email;
      }
      timeagoConvert(singleConv, times);
    }
    return allConversations;
  }

  ClientUser? findUserFromList(String userID) {
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].userId == userID) {
        return allUsers[i];
      }
    }
    return null;
  }

  void timeagoConvert(ParentMessage aChat, DateTime time) {
    aChat.lastSeenDate = time;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var duration = time.difference(aChat.date.toDate());
    aChat.diffDate = timeago.format(time.subtract(duration), locale: "tr");
  }

  Future<List<ClientUser>> getUserwithPagination(ClientUser? getLastUser, int _pageCount) async {
    if (appMode == AppMode.debug) {
      return [];
    }

    List<ClientUser> userList = await _dataService.getUserwithPagination(getLastUser, _pageCount);
    return userList;
  }

  Future<List<Message>> getMessageWithPagination(
      String currentUserId, String chatUserId, Message? _lastMessage, int _pagesCount) async {
    if (appMode == AppMode.debug) {
      return [];
    }

    return await _dataService.getMessagewithPagination(currentUserId, chatUserId, _lastMessage, _pagesCount);
  }
}
