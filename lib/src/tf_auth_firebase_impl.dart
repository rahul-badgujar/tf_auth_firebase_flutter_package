import 'package:tf_auth_base/tf_auth_base.dart';

class TfAuthFirebase extends TfAuth {
  @override
  Future<void> loginWithEmailPassword(
      {required String email, required String password}) {
    // Firebase specific implementation here
    return Future<void>.value();
  }

  @override
  Future<void> loginWithEmailLink({required String email}) {
    // Firebase specific implementation here
    return Future<void>.value();
  }

  @override
  Future<void> loginWithApple() {
    // Firebase specific implementation here
    return Future<void>.value();
  }

  @override
  Future<void> loginWithFacebook() {
    // Firebase specific implementation here
    return Future<void>.value();
  }

  @override
  Future<void> loginWithGoogle() {
    // Firebase specific implementation here
    return Future<void>.value();
  }
}
