import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Firebase sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _passwordFocusNode = FocusNode();
    final _form = GlobalKey<FormState>();
    String _email;
    String _password;
    bool _isLogin = false;

    Future<void> trySubmit() async {
      if (!_form.currentState.validate()) {
        return;
      }

      _form.currentState.save();

      const GOOGLE_API_KEY = 'YOUR_KEY_HERE';
      if (_isLogin) {
        final url =
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$GOOGLE_API_KEY';
        final response = await http.post(url,
            body: json.encode({
              'email': _email,
              'password': _password,
              'returnSecureToken': true,
            }));
        print(json.decode(response.body));
      } else {
        final url =
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$GOOGLE_API_KEY';
        final response = await http.post(url,
            body: json.encode({
              'email': _email,
              'password': _password,
              'returnSecureToken': true,
            }));
        print(json.decode(response.body));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'email'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'password'),
              obscureText: true,
              focusNode: _passwordFocusNode,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password.';
                }
                return null;
              },
              onSaved: (value) {
                _password = value;
              },
            ),
            FlatButton(
              child: Text('Save'),
              color: Colors.grey,
              onPressed: trySubmit,
            ),
          ],
        ),
      ),
    );
  }
}
