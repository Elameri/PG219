import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class AddBio extends StatefulWidget {
  @override
  _AddBioState createState() => _AddBioState();
}

class _AddBioState extends State<AddBio> {
  String writtenBio = '';
  void setBio(String value) {
    writtenBio = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: "Adding Bio Page",
        home: new Material(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Change your profil bio:',
                      style: TextStyle(
                          fontFamily: 'Dancing',
                          fontStyle: FontStyle.normal,
                          //fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 80.0)),
                    new TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        labelText: "",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (value) {
                        if (value.length == 0) {
                          return "Bio cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) async {},
                      onChanged: setBio,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Container(
                      child: new RaisedButton(
                        child: new Text(
                          'Validate',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          print('Boutton Pressed');
                          print('my new bio: $writtenBio');
                          await ajouterBio(writtenBio);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilPage()),
                          );
                        },
                        color: Colors.black,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ])),
                ))));
  }

  Future ajouterBio(String newBio) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myToken = prefs.getString('token');

    var url = "http://localhost:5000/add_bio";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': myToken,
        'bio': newBio,
      }),
    );
  }
}
