import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class AuthScreen extends StatelessWidget {
  void logIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        print('success');
        OAuthProvider oauthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oauthProvider.getCredential(
          idToken: String.fromCharCodes(result.credential.identityToken),
          accessToken:
              String.fromCharCodes(result.credential.authorizationCode),
        );
        FirebaseAuth.instance.signInWithCredential(credential);
        break;

      case AuthorizationStatus.error:
        print("error: ${result.error.localizedDescription}");
        break;

      case AuthorizationStatus.cancelled:
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
        child: AppleSignInButton(
          onPressed: logIn,
        ),
      ),
    );
  }
}
