import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fchatty/locator.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/repository/user_repository.dart';
import 'package:flutter/material.dart';

class AllUserViewCubit extends Cubit<AllUserViewCubitState> {
  AllUserViewCubit() : super(AllUserViewCubitStateInitial()) {
    _allUsers = [];
    getUserWithPagination(_lastUser, false);
  }

  List<ClientUser> _allUsers = [];
  ClientUser? _lastUser;
  static var pageCounts = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  final UserRepository _userRepository = locator<UserRepository>();

  List<ClientUser> get userList => _allUsers;

  getUserWithPagination(ClientUser? lastUser, bool requestFromList) async {
    if (_allUsers.isNotEmpty) {
      _lastUser = _allUsers.last;
    }

    if (!requestFromList) {
      emit(AllUserViewCubitStateLoading());
    }

    var newList =
        await _userRepository.getUserwithPagination(_lastUser, pageCounts);
    if (newList.length < pageCounts) {
      _hasMore = false;
    }
    if (_allUsers.isEmpty) {
      emit(AllUserViewCubitStateLoading());
    }

    _allUsers.addAll(newList);

    emit(AllUserViewCubitStateLoaded());
  }

  Future<void> getMoreUser() async {
    if (_hasMore) getUserWithPagination(_lastUser, true);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> refresh() async {
    debugPrint("hellohello");
    _hasMore = true;
    _lastUser = null;
    _allUsers = [];
    getUserWithPagination(_lastUser, true);
  }
}

abstract class AllUserViewCubitState extends Equatable {
  const AllUserViewCubitState();

  @override
  List<Object> get props => [];
}

class AllUserViewCubitStateInitial extends AllUserViewCubitState {}

class AllUserViewCubitStateLoading extends AllUserViewCubitState {}

class AllUserViewCubitStateLoaded extends AllUserViewCubitState {}
