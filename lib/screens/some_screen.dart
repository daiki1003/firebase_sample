import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticated'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Congrats!!'),
            SizedBox(height: 20),
            FlatButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              label: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
