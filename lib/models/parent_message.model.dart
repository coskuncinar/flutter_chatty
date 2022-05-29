import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ParentMessage {
  final String chatOwnerId;
  final String chatUserId;
  final bool isSeen;
  final Timestamp date;
  final String lastMessage;
  Timestamp? seenDate;
  String? chatUserName;
  String? chatUserEmail;
  String? chatUserProfileURL;
  DateTime? lastSeenDate;
  String? diffDate;
  ParentMessage({
    required this.chatOwnerId,
    required this.chatUserId,
    required this.isSeen,
    required this.date,
    required this.lastMessage,
    this.seenDate,
  });

  @override
  String toString() {
    return 'ParentMessage(chatOwnerId: $chatOwnerId, chatUserId: $chatUserId, isSeen: $isSeen, date: $date, lastMessage: $lastMessage, seenDate: $seenDate)';
  }

  Map<String, dynamic> toMap() {
    return {
      'chatOwnerId': chatOwnerId,
      'chatUserId': chatUserId,
      'isSeen': isSeen,
      'date': date,
      'lastMessage': lastMessage
    };
  }

  factory ParentMessage.fromMap(Map<String, dynamic> map) {
    return ParentMessage(
        chatOwnerId: map['chatOwnerId'] ?? '',
        chatUserId: map['chatUserId'] ?? '',
        isSeen: map['isSeen'] ?? false,
        date: map['date'],
        lastMessage: map['lastMessage'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory ParentMessage.fromJson(String source) => ParentMessage.fromMap(json.decode(source));
}
