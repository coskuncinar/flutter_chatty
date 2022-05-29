import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fchatty/locator.dart';
import 'package:fchatty/models/parent_message.model.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/models/message.model.dart';
import 'package:fchatty/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserViewCubit extends Cubit<UserViewCubitState> {
  UserViewCubit() : super(UserViewCubitStateInitial()) {
    currentUser();
  }

  final UserRepository _userRepository = locator<UserRepository>();

  ClientUser? user;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  Future<ClientUser?> currentUser() async {
    emit(UserViewCubitStateInitial());

    try {
      user = await _userRepository.currentUser();
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint("Viewmodeldeki current user hata:$e");
      return null;
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<ClientUser?> signInAnonymously() async {
    emit(UserViewCubitStateInitial());
    await Future.delayed(const Duration(seconds: 1));
    try {
      user = await _userRepository.signInAnonymously();

      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      //debugPrint("Viewmodeldeki current user hata:$e");
      return null;
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<bool> signOut() async {
    try {
      emit(UserViewCubitStateInitial());
      bool result = await _userRepository.signOut();
      user = null;
      return result;
    } catch (e) {
      //debugPrint("Viewmodeldeki signOut user hata:$e");
      return false;
    } finally {
      emit(UserViewCubitStateLoaded(null));
    }
  }

  Future<ClientUser?> singInAnonymously() async {
    try {
      emit(UserViewCubitStateInitial());
      user = await _userRepository.signInAnonymously();
      return user;
    } catch (e) {
      //debugPrint("Viewmodeldeki singInAnonymously user hata:$e");
      return null;
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<ClientUser?> signInWithGoogle() async {
    try {
      emit(UserViewCubitStateInitial());
      user = await _userRepository.signInWithGoogle();
      return user;
    } catch (e) {
      //debugPrint("Viewmodeldeki signInWithGoogle user hata:$e");
      return null;
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<ClientUser?> signInWithFacebook() async {
    try {
      emit(UserViewCubitStateInitial());
      user = await _userRepository.signInWithFacebook();
      return user;
    } catch (e) {
      //debugPrint("Viewmodeldeki signInWithFacebook user hata:$e");
      return null;
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<ClientUser?> createUserWithEmailandPassword(String email, String password) async {
    if (_checkEmailPassword(email, password)) {
      try {
        emit(UserViewCubitStateInitial());
        user = await _userRepository.createUserWithEmailandPassword(email, password);

        return user;
      } finally {
        emit(UserViewCubitStateLoaded(user));
      }
    } else {
      return null;
    }
  }

  Future<ClientUser?> signInWithEmailandPassword(String email, String password) async {
    try {
      if (_checkEmailPassword(email, password)) {
        emit(UserViewCubitStateInitial());
        user = await _userRepository.signInWithEmailandPassword(email, password);
        return user;
      } else {
        return null;
      }
    } finally {
      emit(UserViewCubitStateLoaded(user));
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await _userRepository.updateUserName(userID, newUserName);
    if (result) {
      if (user != null) {
        user!.userName = newUserName;
      }
    }
    return result;
  }

  Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
    var indirmeLinki = await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLinki;
  }

  Stream<List<Message>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    return _userRepository.getMessages(currentUserID, sohbetEdilenUserID);
  }

  Future<List<ParentMessage>> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }

  bool _checkEmailPassword(String email, String password) {
    var result = true;
    if (password.length < 6) {
      passwordErrorMessage = "Password must be at least 6 characters";
      result = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains('@')) {
      emailErrorMessage = "Invalid email address";
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }
}

@immutable
abstract class UserViewCubitState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserViewCubitStateInitial extends UserViewCubitState {}

class UserViewCubitStateLoaded extends UserViewCubitState {
  final ClientUser? user;

  UserViewCubitStateLoaded(this.user);
}
