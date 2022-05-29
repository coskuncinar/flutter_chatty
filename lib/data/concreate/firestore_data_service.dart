import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatty/data/abstract/i_data_service.dart';
import 'package:fchatty/models/parent_message.model.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreDataService implements IDataService {
  final FirebaseFirestore firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(ClientUser user) async {
    DocumentSnapshot okunanUser =
        await firebaseDB.doc("clientUsers/${user.userId}").get();

    //debugPrint("user.toMap()${user.toMap()}");
    if (okunanUser.data() == null) {
      await firebaseDB
          .collection("clientUsers")
          .doc(user.userId)
          .set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<ClientUser> readUser(String userID) async {
    DocumentSnapshot okunanUser =
        await firebaseDB.collection("clientUsers").doc(userID).get();
    //debugPrint("okunanUser.data${okunanUser.data()}");
    Map<String, dynamic> okunanUserBilgileriMap =
        okunanUser.data() as Map<String, dynamic>;

    ClientUser? okunanUserNesnesi = ClientUser.fromMap(okunanUserBilgileriMap);
    //debugPrint("Okunan user nesnesi :" + okunanUserNesnesi.toString());
    return okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await firebaseDB
        .collection("clientUsers")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await firebaseDB
          .collection("clientUsers")
          .doc(userID)
          .update({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await firebaseDB
        .collection("clientUsers")
        .doc(userID)
        .update({'profilURL': profilFotoURL});
    return true;
  }

  @override
  Future<List<ParentMessage>> getAllConversations(String userId) async {
    debugPrint(
        " *** if you take error  you have to create index at Cloud Firestore - getAllConversations *** ");

    QuerySnapshot querySnapshot = await firebaseDB
        .collection("chats")
        .where("chatOwnerId", isEqualTo: userId)
        .orderBy("date", descending: true)
        .get();

    List<ParentMessage> allChats = [];

    for (DocumentSnapshot item in querySnapshot.docs) {
      var k = item.data() as Map<String, dynamic>;
      ParentMessage singleChat = ParentMessage.fromMap(k);
      allChats.add(singleChat);
    }

    return allChats;
  }

  @override
  Future<DateTime> showTime(String userId) async {
    await firebaseDB.collection("server").doc(userId).set({
      "time": FieldValue.serverTimestamp(),
    });

    var okunanMap = await firebaseDB.collection("server").doc(userId).get();
    Map<String, dynamic> okunanUserBilgileriMap =
        okunanMap.data() as Map<String, dynamic>;
    Timestamp readTime = okunanUserBilgileriMap["time"];
    return readTime.toDate();
  }

  @override
  Future<List<ClientUser>> getUserwithPagination(
      ClientUser? lastUser, int pagesCount) async {
    QuerySnapshot querySnapshot;
    List<ClientUser> allUsers = [];

    if (lastUser == null) {
      querySnapshot = await firebaseDB
          .collection("clientUsers")
          .orderBy("userName")
          .limit(pagesCount)
          .get();
    } else {
      querySnapshot = await firebaseDB
          .collection("clientUsers")
          .orderBy("userName")
          .startAfter([lastUser.userName])
          .limit(pagesCount)
          .get();

      await Future.delayed(const Duration(seconds: 1));
    }

    for (DocumentSnapshot item in querySnapshot.docs) {
      var k = item.data() as Map<String, dynamic>;
      ClientUser tekUser = ClientUser.fromMap(k);
      allUsers.add(tekUser);
    }

    return allUsers;
  }

  @override
  Future<String> uploadFile(String userId, String fileType, File _file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final ref =
        storage.ref().child(userId).child(fileType).child("profil_foto.png");
    var uploadTask = ref.putFile(_file);
    var snapshot = await uploadTask.whenComplete(() {});
    var url = await snapshot.ref.getDownloadURL();
    return url;
  }

  @override
  Stream<List<Message>> getMessages(String currentUserID, String chatUserId) {
    debugPrint(
        " *** if you take error  you have to create index at Cloud Firestore - getMessages *** ");
    var snapShot = firebaseDB
        .collection("chats")
        .doc("$currentUserID--$chatUserId")
        .collection("messages")
        .where("messageOwnerId", isEqualTo: currentUserID)
        .orderBy("createdDate", descending: true)
        .limit(1)
        .snapshots();

    return snapShot.map((rMessageList) => rMessageList.docs
        .map((rMessage) => Message.fromMap(rMessage.data()))
        .toList());
  }

  @override
  Future<bool> saveMessage(Message saveMessage) async {
    var messageId = firebaseDB.collection("chats").doc().id;
    var ownerDocumentID = "${saveMessage.from}--${saveMessage.to}";
    var chatDocumentID = "${saveMessage.to}--${saveMessage.from}";

    var saveMessageMap = saveMessage.toMap();

    await firebaseDB
        .collection("chats")
        .doc(ownerDocumentID)
        .collection("messages")
        .doc(messageId)
        .set(saveMessageMap);

    await firebaseDB.collection("chats").doc(ownerDocumentID).set({
      "chatOwnerId": saveMessage.from,
      "chatUserId": saveMessage.to,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "date": FieldValue.serverTimestamp(),
    });

    saveMessageMap.update("isFromMe", (val) => false);
    saveMessageMap.update("messageOwnerId", (val) => saveMessage.to);

    await firebaseDB
        .collection("chats")
        .doc(chatDocumentID)
        .collection("messages")
        .doc(messageId)
        .set(saveMessageMap);
    await firebaseDB.collection("chats").doc(chatDocumentID).set({
      "chatOwnerId": saveMessage.to,
      "chatUserId": saveMessage.from,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "date": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<String?> getToken(String kime) async {
    DocumentSnapshot token = await firebaseDB.doc("tokens/$kime").get();
    if (token.data() != null) {
      Map<String, dynamic> readToken = token.data() as Map<String, dynamic>;
      return readToken["token"];
    } else {
      return null;
    }
  }

  @override
  Future<List<Message>> getMessagewithPagination(String currentUserID,
      String chatUserId, Message? lastMessage, int _pagesCount) async {
    QuerySnapshot querySnapshot;
    List<Message> allMessages = [];
    debugPrint(
        " *** if you take error  you have to create index at Cloud Firestore - getMessagewithPagination *** ");
    if (lastMessage == null) {
      querySnapshot = await firebaseDB
          .collection("chats")
          .doc("$currentUserID--$chatUserId")
          .collection("messages")
          .where("messageOwnerId", isEqualTo: currentUserID)
          .orderBy("createdDate", descending: true)
          .limit(_pagesCount)
          .get();
    } else {
      querySnapshot = await firebaseDB
          .collection("chats")
          .doc("$currentUserID--$chatUserId")
          .collection("messages")
          .where("messageOwnerId", isEqualTo: currentUserID)
          .orderBy("createdDate", descending: true)
          .startAfter([lastMessage.createdDate])
          .limit(_pagesCount)
          .get();

      await Future.delayed(const Duration(seconds: 1));
    }
    for (DocumentSnapshot item in querySnapshot.docs) {
      Map<String, dynamic> snap = item.data() as Map<String, dynamic>;

      Message singleMessage = Message.fromMap(snap);
      allMessages.add(singleMessage);
    }

    return allMessages;
  }
}
