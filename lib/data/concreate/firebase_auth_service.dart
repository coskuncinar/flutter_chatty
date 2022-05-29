import 'package:fchatty/data/abstract/i_auth_service.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ClientUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      if (user.email != null) {
        return ClientUser.full(userId: user.uid, email: user.email!);
      } else {
        return ClientUser(userId: user.uid, email: user.email ?? "coskuncinar@coskuncinar.com");
      }
    }
  }

  @override
  Future<ClientUser?> signInAnonymously() async {
    // try {
    //   UserCredential result = await _auth.signInAnonymously();
    //   if (result.user != null) {
    //     return _userFromFirebase(result.user);
    //   }
    // } catch (e) {
    //   debugPrint("signInAnonymously+error:$e");
    //   return null;
    // }
    return null;
  }

  @override
  Future<ClientUser?> currentUser() async {
    if (_auth.currentUser != null) {
      return _userFromFirebase(_auth.currentUser);
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      var googleSignIn = GoogleSignIn();
      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();
      }

      try {
        final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
        if (accessToken != null) {
          await FacebookAuth.instance.logOut();
        }
      } catch (e) {
        //debugPrint("facebookSignInsignOut:$e");
      }

      await _auth.signOut();
      return true;
    } catch (e) {
      debugPrint("signOut:$e");
      return false;
    }
  }

  @override
  Future<ClientUser?> createUserWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch(e) {
      throw PlatformException(code: e.code,message: e.message);
    }
  }

  @override
  Future<ClientUser?> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch(e) {
      throw PlatformException(code: e.code,message: e.message);
    }
  }

  @override
  Future<ClientUser?> signInWithFacebook() async {
    final LoginResult loginResult;
    loginResult = await FacebookAuth.instance.login();

    switch (loginResult.status) {
      case LoginStatus.success:
        //debugPrint("loginResult.status.name" + loginResult.status.name);
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
        var userCredential = await _auth.signInWithCredential(facebookAuthCredential);
        return _userFromFirebase(userCredential.user);
      case LoginStatus.cancelled:
        break;
      case LoginStatus.failed:
        break;
      default:
        break;
    }
    return null;
  }

  @override
  Future<ClientUser?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredential = await _auth.signInWithCredential(credential);
      return _userFromFirebase(userCredential.user);
    } else {
      return null;
    }
    // return ClientUser(
    //   userId: userCredential.user!.uid,
    //   email: userCredential.user!.email ?? "",
    // );
  }
}
