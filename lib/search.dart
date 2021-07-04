import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'profile.dart';
import 'package:http/http.dart' as http;

import 'search_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class SearchUsers extends StatefulWidget {
  @override
  _SearchUsersState createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  String name = '';
  void setName(String value) {
    name = value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: "Search for someone",
        home: new Material(
            child: new Container(
                //padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Type The User Username',
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
                          return "Username cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String value) async {},
                      onChanged: setName,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Container(
                      child: new RaisedButton(
                        child: new Text(
                          'Search',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          print('Boutton Pressed');
                          print('User searched: $name');
                          await searchUser(name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult()),
                          );
                        },
                        color: Colors.black,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 280.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Container(
                          child: new Container(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignedInSection()),
                                );
                              },
                              child: Icon(
                                Icons.home,
                                color: Colors.black,
                                size: 58.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])),
                ))));
  }

  Future searchUser(String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('searched', newName);
    /*
    var dataReceived;
    var searchResult;
    var url = "http://localhost:5000/search_users";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': newName,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      searchResult = dataReceived["searchresult"];
      //timelinePeople = List<String>.from(searchResult);
    });
    print(searchResult);
    */
  }
}
