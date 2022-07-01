### TfAuthFirebase
This is Firebase Implementation Specific Package under Tenfins TfAuth Library.

## Features

Currently support added for:

- Email/Password Login
- Email/Password Signup
- Forgot Password for Email
- Login with Facebook
- Login with Google
- Logout

Support coming soon for:

- Email Link Login
- Apple Login

## Prerequisite Setup
### Add Firebase to your existing Google Cloud project:

   #### a. Log in to the [Firebase console](https://console.firebase.google.com/) , then click Add project.
   #### b. Select your existing Google Cloud project from the dropdown menu, then click Continue.
   #### c. (Optional) Enable Google Analytics for your project, then follow the prompts to select or create a Google Analytics account.
   #### d. Click Add Firebase.


## Getting started

All you need to do is add tf_auth_firebase dependency in your pubspec.yaml

```dart
tf_auth_firebase:
    git:
      url: https://github.com/rahul-badgujar/tf_auth_firebase_flutter_package.git
      ref: main
```

And import in your codebase using:

```dart
import 'package:tf_auth_firebase/tf_auth_firebase.dart';
```

## Usage

### Configure Firebase

Install the plugin by running the following command from the project root:
```yaml
flutter pub add firebase_core
```
To initialize FlutterFire, call the initializeApp method on the Firebase class. The method accepts your Firebase project application configuration, which can be obtained for all supported platforms by using the FlutterFire CLI:

Install FlutterFire CLI if not already installed:
https://firebase.flutter.dev/docs/manual-installation/


```yaml
# Install the CLI if not already done so
dart pub global activate flutterfire_cli

# Run the `configure` command, select a Firebase project and platforms
flutterfire configure
```

Once configured, a firebase_options.dart file will be generated for you containing all the options required for initialization. Additionally, if your Flutter app supports Android then the Android Google Services Gradle plugin will automatically be applied for you.

## Initialization

Initialize Firebase and TfAuthController before you use to get started with the authentification.
```yaml
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
```

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await TfAuthController.instance.init(
    authProvider: TfAuthFirebase(
      firebaseAuthInstance: FirebaseAuth.instance,
    ),
  );
  runApp(MyApp());
}
```
### Email and Password Sign up

Use the following code for Email and Password sign-up which returns a TfAuthUser

```dart
final user = await TfAuthController.instance.authProvider
                      .signupWithEmailPassword( email: email, password: password);
```

### Email and Password Sign in

Use the following code for Email and Password sign-in which returns a TfAuthUser

```dart
 final user = await TfAuthController.instance.authProvider
                      .loginWithEmailPassword(email: ${email}, password: ${password});
```


### Google Sign In

Make sure you enable Google Sign in Firebase Authentication Console.
Add SHA1 and SHA256 keys in your Android app setup and configuration in firebase project settings > General

```dart
final user = await TfAuthController.instance.authProvider.loginWithGoogle();
```

### Facebook Sign In

Before getting started setup your Facebook Developer App and follow the setup process to enable Facebook Login.

#### Create an Facebook App on developers.facebook.com

Setup Android Facebook application through Quickstart, after coming to the 4th step we need to enter the package name and the default activity class name which can be found in AndroidManifestation.xml in your flutter project.

Enter the given command in your terminal/command prompt and enter the output string into the given field.

Follow the given steps to add the codes in your xml and gradel files for facebook sign-in permisions.

With this your facebook app is created.

#### Configure Facebook sign in Firebase Console

Enable facebook sign-in in Firebase Console and paste app id and app secret from the facebook app into your Firebase console. Copy the link given below app secret field in Firebase facebook sign in console and paste it into your Facebook app/settings/Valid OAuth Redirect URIs field without this your redirect url can't be verified.

```yaml
flutter pub add firebase_core
```

```dart
final user = await TfAuthController.instance.authProvider.loginWithFacebook();
```

### Sign Out
To Sign out of the app use the following command

```dart
await TfAuthController.instance.authProvider.logOut();
```


## Additional information

### User Status

Use the following commands to know whether the user is logged in
```yaml
await TfAuthController.instance.authProvider.isUserLoggedIn
```

```yaml
await TfAuthController.instance.authProvider.isUserNotLoggedIn
```
### User Details
```yaml
await TfAuthController.instance.authProvider.currentUser;
```
