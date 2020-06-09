import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatelessWidget {
  static final facebookLogin = FacebookLogin();
  void logIn() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        final authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print(authResult.user.uid);
        break;
      case FacebookLoginStatus.error:
        print('error, ${result.errorMessage}');
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: logIn,
          child: Text('login'),
        ),
      ),
    );
  }
}
