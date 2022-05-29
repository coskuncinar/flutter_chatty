import 'package:fchatty/custom_widget/custom_elevated_button.dart';
import 'package:fchatty/locator.dart';
import 'package:fchatty/pages/login_register_page.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fchatty/data/abstract/i_auth_service.dart';

// ignore: must_be_immutable
class SingPage extends StatelessWidget {
  SingPage({Key? key}) : super(key: key);
  final authBase = locator<IAuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chatty"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Sign In",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomElevatedButton(
              buttonText: "Continue with Google",
              onPressed: () => signInWithGoogle(context),
              textColor: Colors.black87,
              buttonColor: Colors.white,
              buttonIcon: Image.asset("assets/button_images/google-logo.png"),
            ),
            CustomElevatedButton(
              buttonText: "Continue with Facebook",
              onPressed: () => signInWithFacebook(context),
              buttonColor: const Color(0xFF334D92),
              buttonIcon: Image.asset("assets/button_images/facebook-logo.png"),
            ),
            CustomElevatedButton(
              buttonText: "Continue with Email",
              onPressed: () => signInWithEmailPage(context),
              buttonIcon: const Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
            ),
            // CustomElevatedButton(
            //   buttonText: "Continue with Guest",
            //   onPressed: () => signInGuest(context),
            //   buttonColor: Colors.teal,
            //   buttonIcon: const Icon(
            //     Icons.supervised_user_circle,
            //     color: Colors.white,
            //     size: 32,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void signInGuest(BuildContext context) async {
    context.read<UserViewCubit>().signInAnonymously();
  }

  void signInWithGoogle(BuildContext context) {
    context.read<UserViewCubit>().signInWithGoogle();
  }

  void signInWithFacebook(BuildContext context) {
    context.read<UserViewCubit>().signInWithFacebook();
  }

  void signInWithEmailPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const LoginRegisterPage(),
      ),
    );
  }
}
