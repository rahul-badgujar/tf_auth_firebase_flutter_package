import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tf_auth_firebase/tf_auth_firebase.dart';

class TfAuthFirebase extends TfAuth {
  final FirebaseAuth firebaseAuthInstance;

  TfAuthFirebase({required this.firebaseAuthInstance}) {
    // Subscribing to Firebase User Changes Stream
    firebaseAuthInstance.userChanges().listen((user) {
      if (user == null) {
        currentUser = null;
      } else {
        currentUser = __tfAuthUserFromFirebaseUser(user);
      }
    });
  }

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
      currentUser = __tfAuthUserFromFirebaseUser(firebaseUser);
      return currentUser!;
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
      currentUser = __tfAuthUserFromFirebaseUser(firebaseUser);
      return currentUser!;
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
  Future<TfAuthUser> loginWithFacebook() async {
    if (kIsWeb) {
      try {
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();

        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });
        await firebaseAuthInstance.signInWithPopup(facebookProvider);
      } on FirebaseAuthException catch (e) {
        throw e.message.toString();
      } catch (e) {
        rethrow;
      }
    } else {
      try {
        final LoginResult loginResult = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        final userCredential = await firebaseAuthInstance
            .signInWithCredential(facebookAuthCredential);
        final firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          throw "Something went wrong";
        }
        currentUser = __tfAuthUserFromFirebaseUser(firebaseUser);
        return currentUser!;
      } on FirebaseAuthException catch (e) {
        throw e.message.toString();
      } catch (e) {
        rethrow;
      }
    }
    throw "something went wrong";
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
        currentUser = __tfAuthUserFromFirebaseUser(firebaseUser);
        return currentUser!;
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
          throw 'Google Authentication not configured for this Firebase Project.';
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
  Future<void> logout() async {
    try {
      await firebaseAuthInstance.signOut();
      await super.logout();
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    } catch (e) {
      rethrow;
    }
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
