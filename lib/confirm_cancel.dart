import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class CancelImage extends StatelessWidget {
  final String imgPath;
  CancelImage({Key key, this.imgPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: "Confirmation for Canceling the image",
        home: new Material(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Are you sure you want to cancel this image ?',
                      //imgPath,
                      style: TextStyle(
                          fontFamily: 'Dancing',
                          fontStyle: FontStyle.normal,
                          //fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 80.0)),
                    new Container(
                      child: new RaisedButton(
                        child: new Text(
                          'Yes',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          print('Yes Pressed');
                          supprimerImg(imgPath);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilPage()),
                          );
                        },
                        color: Colors.black,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    ),
                    new Container(
                      child: new RaisedButton(
                        child: new Text(
                          'No',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          print('No Pressed');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilPage()),
                          );
                        },
                        color: Colors.black,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    ),
                  ])),
                ))));
  }

  Future supprimerImg(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myUsername = prefs.getString('username');

    var url = "http://localhost:5000/cancel_img";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': myUsername,
        'picture': path,
      }),
    );
  }
}

/*

class CancelImage extends StatefulWidget {
  final String imgPath;
  CancelImage({Key key, this.imgPath}) : super(key: key);
  @override
  _CancelImageState createState() => _CancelImageState();
}

class _CancelImageState extends State<CancelImage> {
  @override
*/