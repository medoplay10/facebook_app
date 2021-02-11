import 'package:flutter/material.dart';

import 'main.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Null> _logOut() async {
    await MyHomePage.facebookSignIn.logOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Container(child: Text("well done"),),
          RaisedButton(
            onPressed: _logOut,
            child: new Text('Logout'),
          ),
        ],
      )),
    );
  }
}
