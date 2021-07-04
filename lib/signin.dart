import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:validate/validate.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'timeline.dart';

void main() => runApp(new MaterialApp(
      //title: 'Forms in Flutter',
      home: new SignInPage(),
    ));

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignInPageState();
}

class _SignInData {
  String email = '';
  String password = '';
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _SignInData _data = new _SignInData();

  String _validateEmail(String value) {
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

      await signInFunction(_data.email, _data.password);

      print('The following Sign In data has been sent to the back.');
      print('Email: ${_data.email}');
      print('Password: ${_data.password}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");

      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignedInSection()),
        );
      } else {
        print("Incorrect email or password");
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
        title: new Text('Sign In'),
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
                    validator: this._validateEmail,
                    onSaved: (String value) {
                      this._data.email = value;
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
                      'Sign In',
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

signInFunction(email, password) async {
  var url = "http://localhost:5000/signin";

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  print(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parse = jsonDecode(response.body);
  await prefs.setString('token', parse["token"]);
  //String token = prefs.getString("token");
  //print(token);
}
