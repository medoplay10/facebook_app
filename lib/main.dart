import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _login() async {

    // to get all information facebook
    // https://developers.facebook.com/tools/explorer?method=GET&path=me%3Ffields%3Did&version=v9.0
    final FacebookLoginResult result =
    await MyHomePage.facebookSignIn.logIn(['email']);

    if(result.status ==  FacebookLoginStatus.loggedIn){
      final FacebookAccessToken accessToken = result.accessToken;
      print("accessToken = " + accessToken.token);

      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,birthday,last_name,email&access_token=${accessToken.token}');
      final profile = json.decode(graphResponse.body);
      print("profile = "+ profile.toString());


      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    }

  }

  Future<Null> _logOut() async {
    await MyHomePage.facebookSignIn.logOut();
    _showMessage('Logged out.');
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_message),
              new RaisedButton(
                onPressed: _login,
                child: new Text('Log in'),
              ),
              new RaisedButton(
                onPressed: _logOut,
                child: new Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

