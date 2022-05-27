import 'package:mynoteapp/services/auth/auth_provider.dart';
import 'package:mynoteapp/services/auth/auth_user.dart';
import 'package:mynoteapp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthService provider;
  const AuthService(this.provider);
//there is an error
  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerificaiton() => provider.sendEmailVerificaiton();
}
