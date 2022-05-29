import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fchatty/locator.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:fchatty/repository/user_repository.dart';

class ChatViewCubit extends Cubit<ChatViewCubitState> {
  final ClientUser currentUser;
  final ClientUser chatUser;
  static const pagesCount = 10;
  ChatViewCubit({required this.currentUser, required this.chatUser}) : super(ChatViewCubitStateInitial()) {
    getMessageWithPagination(false);
  }
  @override
  close() async {
    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }
    super.close();
  }

  bool _hasMore = true;
  bool get hasMoreLoading => _hasMore;

  final List<Message> _allMessages = [];
  List<Message>? get messageList => _allMessages;

  final UserRepository _userRepository = locator<UserRepository>();

  Message? _getLastMessage;
  Message? _getFirstMessage;
  bool _newMessageListener = false;

  StreamSubscription? _streamSubscription;

  Future<bool> saveMessage(Message saveMessage, ClientUser currentUser) async {
    return await _userRepository.saveMessage(saveMessage, currentUser);
  }

  void getMessageWithPagination(bool comingNewMessages) async {
    if (_allMessages.isNotEmpty) {
      _getLastMessage = _allMessages.last;
    }

    if (!comingNewMessages) {
      emit(ChatViewCubitStateLoading());
    }
    var getMessages = await _userRepository.getMessageWithPagination(
        currentUser.userId, chatUser.userId, _getLastMessage, pagesCount);
    if (getMessages.length < pagesCount) {
      _hasMore = false;
    }

    _allMessages.addAll(getMessages);
    if (_allMessages.isNotEmpty) {
      _getFirstMessage = _allMessages.first;
    }
    emit(ChatViewCubitStateLoaded());

    if (_newMessageListener == false) {
      _newMessageListener = true;
      assignNewMessageListener();
    }
  }

  Future<void> getMoreMessage() async {
    if (_hasMore) {
      getMessageWithPagination(true);
    }
    await Future.delayed(const Duration(seconds: 2));
  }

  void assignNewMessageListener() {
    _streamSubscription = _userRepository.getMessages(currentUser.userId, chatUser.userId).listen((momentData) {
      if (momentData.isNotEmpty && momentData[0].createdDate != null) {
        emit(ChatViewCubitStateLoading());
        if (_getFirstMessage == null) {
          _allMessages.insert(0, momentData[0]);
        } else if (momentData[0].createdDate != null &&
            _getFirstMessage!.createdDate!.millisecondsSinceEpoch !=
                momentData[0].createdDate!.millisecondsSinceEpoch) {
          _allMessages.insert(0, momentData[0]);
        }
        emit(ChatViewCubitStateLoaded());
      }
    });
  }
}

abstract class ChatViewCubitState extends Equatable {
  const ChatViewCubitState();

  @override
  List<Object> get props => [];
}

class ChatViewCubitStateInitial extends ChatViewCubitState {}

class ChatViewCubitStateLoading extends ChatViewCubitState {}

class ChatViewCubitStateLoaded extends ChatViewCubitState {}
