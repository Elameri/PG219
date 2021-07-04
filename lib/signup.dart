import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'signin.dart';

void main() => runApp(new MaterialApp(
      //title: 'Forms in Flutter',
      home: new SignUpPage(),
    ));

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpData {
  String email = '';
  String username = '';
  String password = '';
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _SignUpData _data = new _SignUpData();

  String _validerEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'Please enter a valid e-mail adress';
    }
    return null;
  }

  void submit() async {
    // Validate then save the form
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      await signUpFunction(_data.email, _data.username, _data.password);

      print('The following Sign Up data has been sent to the back.');
      print('Email: ${_data.email}');
      print('Username: ${_data.username}');
      print('Password: ${_data.password}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _data.username);
      String token = prefs.getString("token");

      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      if (token != null && token != "") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilPage()),
        );
      }
    }

    //checkToken();

    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign Up'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType:
                        TextInputType.emailAddress, // email input type
                    decoration: new InputDecoration(
                        hintText: 'zlatan@ibrahimovic.com',
                        labelText: 'Enter your e-mail Address'),
                    validator: this._validerEmail,
                    onSaved: (String value) {
                      this._data.email = value;
                    }),
                new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: '@zlatan', labelText: 'Enter your username'),
                    onSaved: (String value) {
                      this._data.username = value;
                    }),
                new TextFormField(
                    obscureText: true, // secure text for psswds
                    decoration: new InputDecoration(
                        hintText: 'Password', labelText: 'Enter your password'),
                    onSaved: (String value) {
                      this._data.password = value;
                    }),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Sign Up',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submit,
                    color: Colors.black,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }
}

signUpFunction(email, username, password) async {
  var url = "http://localhost:5000/signup";

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'email': email,
      'password': password,
      'profile_picture': "",
      'bio': "Hello there",
    }),
  );

  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  await prefs.setString('token', parse["token"]);
  //String token = prefs.getString("token");
  //print(token);
}
