import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      final auth = FirebaseAuth.instance;
      if (_isLogin) {
        final result = await auth.signInWithEmailAndPassword(email: _email, password: _password);
        print(result.user.uid);
      } else {
        final result = await auth.createUserWithEmailAndPassword(email: _email, password: _password);
        print(result.user.uid);
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
