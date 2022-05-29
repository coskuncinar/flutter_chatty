import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatty/constants/utils.dart';

class ClientUser {
  final String userId;
  final String email;
  String? userName;
  String? profilURL;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  int? level;

  ClientUser({
    required this.userId,
    required this.email,
  });

  ClientUser.full({
    required this.userId,
    required this.email,
    this.userName,
    this.profilURL,
    this.createdAt,
    this.updatedAt,
    this.level,
  });

  ClientUser copyWith({
    String? userId,
    String? email,
    String? userName,
    String? profilURL,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    int? level,
  }) {
    return ClientUser.full(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      profilURL: profilURL ?? this.profilURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + Utils.randomNumber(min: 100, max: 999).toString(),
      'profilURL': profilURL ?? "https://coskuncinar.com/defaultprofile.png",
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  factory ClientUser.fromMap(Map<String, dynamic> map) {
    return ClientUser.full(
      userId: map['userId'] ?? '',
      email: map['email'] ?? '',
      userName: map['userName'] ?? '',
      profilURL: map['profilURL'],
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp,
      level: map['level']?.toInt(),
    );
  }

  ClientUser.userIdveUrl({required this.userId, required this.email, required this.profilURL, this.userName});

  String toJson() => json.encode(toMap());

  factory ClientUser.fromJson(String source) => ClientUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClientUser(userId: $userId, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClientUser &&
        other.userId == userId &&
        other.email == email &&
        other.userName == userName &&
        other.profilURL == profilURL &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.level == level;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        profilURL.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        level.hashCode;
  }
}
