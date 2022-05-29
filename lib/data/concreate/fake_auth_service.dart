import 'package:fchatty/data/abstract/i_auth_service.dart';
import 'package:fchatty/models/client_user.model.dart';
import 'package:uuid/uuid.dart';

class FakeAuthService implements IAuthService {
  final String userID = const Uuid().v4(); //"12345678911";
  @override
  Future<ClientUser?> signInAnonymously() async {
    return Future.value(ClientUser(userId: userID, email: "coskun@coskuncinar.com"));
  }

  @override
  Future<ClientUser?> currentUser() async {
    return await Future.delayed(
        const Duration(seconds: 1), () => ClientUser(userId: userID, email: "coskun@coskuncinar.com"));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<ClientUser?> createUserWithEmailandPassword(String email, String password) {
    return Future.value(null);
  }

  @override
  Future<ClientUser?> signInWithEmailandPassword(String email, String password) {
    return Future.value(null);
  }

  @override
  Future<ClientUser?> signInWithFacebook() {
    return Future.value(null);
  }

  @override
  Future<ClientUser?> signInWithGoogle() {
    return Future.value(null);
  }
}
