import 'package:fchatty/pages/home_page.dart';
import 'package:fchatty/pages/sign_page.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserViewCubit, UserViewCubitState>(
      builder: (contexty, state) {
        if (state is UserViewCubitStateInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (state is UserViewCubitStateLoaded) {
            if (state.user != null) {
              return HomePage(user: state.user);
            } else {
              return SingPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        }
      },
    );
  }
}
