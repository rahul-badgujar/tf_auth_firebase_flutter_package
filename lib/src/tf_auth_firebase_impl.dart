import 'package:google_sign_in/google_sign_in.dart';
import 'package:tf_auth_firebase/tf_auth_firebase.dart';

class TfAuthFirebase extends TfAuth {
  final FirebaseAuth firebaseAuthInstance;

  TfAuthFirebase({required this.firebaseAuthInstance});

  @override
  Future<TfAuthUser> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      if (e.code == 'user-disabled') {
        throw 'The user account is disabled.';
      } else if (e.code == 'user-not-found') {
        throw 'No user found for given credentials.';
      } else if (e.code == 'invalid-email') {
        throw 'The email provided is invalid';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password.';
      } else if (e.code == 'operation-not-allowed') {
        throw 'Email Password Authentication not configured for this Firebase Project.';
      } else {
        throw "Something went wrong: $e";
      }
    } catch (e) {
      rethrow;
    }
  }

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
        throw "Something went wrong: $e";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPasswordForEmail({required String email}) async {
    try {
      await firebaseAuthInstance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      rethrow;
    }
    // throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithEmailLink({required String email}) async {
    var acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: "http://localhost:5000",
        // This must be true
        handleCodeInApp: true,
        iOSBundleId: 'com.example.ios',
        androidPackageName: 'com.tfauthexample.android',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '10');

    //send an email to the user for authentication
    firebaseAuthInstance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));

    //recieve the link and verify the email

    try {} catch (e) {}
    // TODO: implement loginWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<TfAuthUser> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await firebaseAuthInstance.signInWithCredential(credential);

        final firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          throw "Something went wrong";
        }
        final tfAuthUser = __tfAuthUserFromFirebaseUser(firebaseUser);
        return tfAuthUser;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-disabled') {
          throw 'The user account is disabled.';
        } else if (e.code == 'user-not-found') {
          throw 'No user found for given credentials.';
        } else if (e.code == 'invalid-email') {
          throw 'The email provided is invalid';
        } else if (e.code == 'wrong-password') {
          throw 'Wrong password.';
        } else if (e.code == 'operation-not-allowed') {
          throw 'Email Password Authentication not configured for this Firebase Project.';
        } else {
          throw "Something went wrong: $e";
        }
      } catch (e) {
        rethrow;
      }
    } else {
      throw "Something went wrong";
    }
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
