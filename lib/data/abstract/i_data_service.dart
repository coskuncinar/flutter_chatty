import 'dart:io';

import 'package:fchatty/models/parent_message.model.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';

abstract class IDataService {
  Future<bool> saveUser(ClientUser user);
  Future<ClientUser> readUser(String userId);
  Future<bool> updateUserName(String userId, String newUserName);
  Future<bool> updateProfilFoto(String userID, String profilePhotoURL);
  Future<List<ClientUser>> getUserwithPagination(ClientUser? lastUser, int _pagesCount);
  Future<List<ParentMessage>> getAllConversations(String userId);
  Stream<List<Message>> getMessages(String currentUserId, String chatUserId);
  Future<bool> saveMessage(Message saveMessage);
  Future<DateTime> showTime(String userId);
  Future<String> uploadFile(String userId, String fileType, File _file);
  Future<String?> getToken(String chatUserId);
  Future<List<Message>> getMessagewithPagination(
      String currentUserID, String chatUserId, Message? lastMessage, int _pagesCount);
}
