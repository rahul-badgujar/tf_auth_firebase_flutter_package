import 'package:tf_auth_firebase/tf_auth_firebase.dart';

class TfAuthFirebase extends TfAuth {
  final FirebaseAuth firebaseAuthInstance;

  TfAuthFirebase({required this.firebaseAuthInstance});

  @override
  Future<TfAuthUser> signupWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw "Something went wrong";
      }
      final tfAuthUser = __tfAuthUserFromFirebaseUser(firebaseUser);
      return tfAuthUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email provided is invalid';
      } else if (e.code == 'operation-not-allowed') {
        throw 'Email Password Authentication not configured for this Firebase Project.';
      } else {
        throw "Something went wrong";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TfAuthUser> forgotPasswordForEmail({required String email}) {
    // TODO: implement forgotPasswordForEmail
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithEmailLink({required String email}) {
    // TODO: implement loginWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  static TfAuthUser __tfAuthUserFromFirebaseUser(User firebaseUser) {
    final tfAuthUser = TfAuthUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      username: firebaseUser.email,
      isEmailVerified: true,
      photoUrl: firebaseUser.photoURL,
    );
    return tfAuthUser;
  }
}
