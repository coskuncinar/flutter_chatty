import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String from;
  final String to;
  final bool isFromMe;
  final String message;
  final String messageOwnerId;
  Timestamp? createdDate;
  Message(
      {required this.from,
      required this.to,
      required this.isFromMe,
      required this.message,
      required this.messageOwnerId,
      this.createdDate});

  @override
  String toString() {
    return 'Message(from: $from, to: $to, isFromMe: $isFromMe, message: $message, messageOwnerId: $messageOwnerId,   createdDate: $createdDate)';
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'isFromMe': isFromMe,
      'message': message,
      'messageOwnerId': messageOwnerId,
      'createdDate': createdDate ?? FieldValue.serverTimestamp(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      isFromMe: map['isFromMe'] ?? false,
      message: map['message'] ?? '',
      messageOwnerId: map['messageOwnerId'] ?? '',
      createdDate: map['createdDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));
}
