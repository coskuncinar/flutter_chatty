import 'package:fchatty/constants/auth_exception.dart';
import 'package:fchatty/custom_widget/custom_alert_dialog.dart';
import 'package:fchatty/custom_widget/custom_elevated_button.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:fchatty/viewmodel/cubit/user_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FormType { register, logIn }

class MyCustomClass {
  const MyCustomClass();

  Future<void> myAsyncMethod(BuildContext context, VoidCallback onSuccess) async {
    await Future.delayed(const Duration(microseconds: 1));
    onSuccess.call();
  }
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String _email = "";
  String _password = "";
  String _butonText = "";
  String _linkText = "";
  var _formType = FormType.logIn;

  final _formKey = GlobalKey<FormState>();

  void onButtonTapped() {
    //Navigator.of(context).popUntil(ModalRoute.withName("/"));
    const MyCustomClass().myAsyncMethod(context, () {
      if (!mounted) return;
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    });
  }

  void _formSubmit() async {
    _formKey.currentState!.save();
    //final _userModel = Provider.of<UserModel>(context);
    final userModel = context.read<UserViewCubit>();
    if (_formType == FormType.logIn) {
      try {
        ClientUser? girisYapanUser = await userModel.signInWithEmailandPassword(_email, _password);
        if (girisYapanUser != null) {
          //Future.delayed(const Duration(milliseconds: 1), () {
          //Navigator.of(context).popUntil(ModalRoute.withName("/"));
          onButtonTapped();

          //  });
        }
      } on PlatformException catch (e) {
        //debugPrint("error type : ${e.runtimeType}");
        CustomAlertDialog(
          title: "Login Error",
          content: AuthException.getMessageFromErrorCode(e.code),
          okButtonCaption: "Ok",
          cancelButtonCaption: "Cancel",
        ).showAlertDialog(context);
      }
    } else {
      try {
        ClientUser? olusturulanUser = await userModel.createUserWithEmailandPassword(_email, _password);

        if (olusturulanUser != null) {
          // Future.delayed(const Duration(milliseconds: 1), () {
          //Navigator.of(context).popUntil(ModalRoute.withName("/"));
          onButtonTapped();
          // });
        }
      } on PlatformException catch (e) {
        CustomAlertDialog(
          title: "User errpr",
          content: AuthException.getMessageFromErrorCode(e.code),
          okButtonCaption: "Ok",
          cancelButtonCaption: "Cancel",
        ).showAlertDialog(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType = _formType == FormType.logIn ? FormType.register : FormType.logIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.logIn ? "Sing in" : "Sing up";
    _linkText = _formType == FormType.logIn ? "Not registered yet? Create an account" : "Already registered? Sing in";

    final userModel = context.read<UserViewCubit>();

    return BlocBuilder<UserViewCubit, UserViewCubitState>(
      builder: (contexty, state) {
        if (state is UserViewCubitStateLoaded) {
          return Scaffold(
              appBar: AppBar(
                title: Text(_butonText),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            //initialValue: "ebullientcinar@gmail.com",
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              errorText: userModel.emailErrorMessage,
                              prefixIcon: const Icon(Icons.mail),
                              hintText: 'Email',
                              labelText: 'Email',
                              border: const OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            //initialValue: "123456",
                            obscureText: true,
                            decoration: InputDecoration(
                              errorText: userModel.passwordErrorMessage,
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Password',
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomElevatedButton(
                            buttonText: _butonText,
                            buttonColor: Theme.of(context).primaryColor,
                            buttonRadius: 10,
                            onPressed: () => _formSubmit(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () => _degistir(),
                            child: Text(_linkText),
                          ),
                        ],
                      )),
                ),
              ));
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
