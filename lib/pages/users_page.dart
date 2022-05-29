import 'dart:async';

import 'package:fchatty/pages/chat_page.dart';
import 'package:fchatty/viewmodel/cubit/all_user_view_cubit.dart';
import 'package:fchatty/viewmodel/cubit/chat_view_cubit.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  late  ScrollController _scrollController ;

  @override
  void initState() {

    _scrollController= ScrollController();
    _scrollController.addListener(_listScrollListener);
    super.initState();
  }
  Completer<void> completer = Completer<void>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: BlocBuilder<AllUserViewCubit, AllUserViewCubitState>(
        builder: (context, state) {
          if (state is AllUserViewCubitStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AllUserViewCubitStateLoaded) {
            final model = context.read<AllUserViewCubit>();
            completer.complete();
            completer = Completer<void>();

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      completer.future;
                      model.refresh();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (model.userList.length == 1) {
                          return _notExistsUsers();
                        } else if (model.hasMoreLoading &&
                            index == model.userList.length) {
                          return _loadingNewObjectIndicator();
                        } else {
                          return _createUserListItem(index);
                        }
                      },
                      itemCount: model.hasMoreLoading
                          ? model.userList.length + 1
                          : model.userList.length,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _notExistsUsers() {
    //final _kullanicilarModel = Provider.of<AllUserViewModel>(context);
    final _allUserViewCubit = context.read<AllUserViewCubit>();
    return RefreshIndicator(
      onRefresh: _allUserViewCubit.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                const Text(
                  "No users yet!",
                  style: TextStyle(fontSize: 32),
                )
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }

  Widget _createUserListItem(int index) {
    //final _userModel = Provider.of<UserModel>(context);
    final _userViewCubit = context.read<UserViewCubit>();
    //final _allUserViewModel = Provider.of<AllUserViewModel>(context);
    final _allUsersViewCubit = context.read<AllUserViewCubit>();

    var _currentUser = _allUsersViewCubit.userList[index];

    if (_currentUser.userId == _userViewCubit.user!.userId) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatViewCubit(
                  currentUser: _userViewCubit.user!, chatUser: _currentUser),
              child: const ChatPage(),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_currentUser.userName!),
          subtitle: Text(_currentUser.email),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_currentUser.profilURL!),
          ),
        ),
      ),
    );
  }

  _loadingNewObjectIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _getMoreUsers() async {
    if (_isLoading == false) {
      _isLoading = true;
      //final _AllUserViewModel = Provider.of<AllUserViewModel>(context);
      final _allUserViewCubit = context.read<AllUserViewCubit>();
      await _allUserViewCubit.getMoreUser();
      _isLoading = false;
    }
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      //debugPrint("at the bottom2");
      _getMoreUsers();
    }
  }
}
