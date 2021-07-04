import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'package:http/http.dart' as http;

import 'timeline.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class AddComm extends StatefulWidget {
  @override
  _AddCommState createState() => _AddCommState();
}

class _AddCommState extends State<AddComm> {
  String writtenBio = '';
  void setCaption(String value) {
    writtenBio = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: "Adding a caption to the image",
        home: new Material(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Adding a caption to the image:',
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
                      /*
                      validator: (value) {
                        if (value.length == 0) {
                          return "Bio cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      */
                      onSaved: (String value) async {},
                      onChanged: setCaption,
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
                        onPressed: () {
                          //print('Boutton Pressed');
                          //print('my new comment: $writtenBio');
                          ajouterCaption(writtenBio);
                          //Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilPage()),
                          );
                          //print("ater navigator");
                        },
                        color: Colors.black,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    )
                  ])),
                ))));
  }

  Future ajouterCaption(String newCaption) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //var myToken = prefs.getString('token');
    var myUsername = prefs.getString('username');
    var myPicture = prefs.getString('picture');

    var url = "http://localhost:5000/add_caption_img";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        //'token': myToken,
        'username': myUsername,
        'picture': myPicture,
        'comment': newCaption,
      }),
    );
  }
}
