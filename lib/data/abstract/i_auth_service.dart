import 'package:fchatty/models/client_user.model.dart';

abstract class IAuthService {
  Future<ClientUser?> currentUser();
  Future<ClientUser?> signInAnonymously();
  Future<bool> signOut();
  Future<ClientUser?> signInWithGoogle();
  Future<ClientUser?> signInWithFacebook();
  Future<ClientUser?> signInWithEmailandPassword(String email, String password);
  Future<ClientUser?> createUserWithEmailandPassword(String email, String password);
}
