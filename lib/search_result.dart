import 'dart:convert';
import 'dart:io';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'package:http/http.dart' as http;

import 'profile_others.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<String> searchedPeople = [];

  @override
  void initState() {
    searchUser();
    super.initState();
  }

  Future searchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var searchedFor = prefs.getString('searched');
    var myUsername = prefs.getString('username');
    var dataReceived;
    var searchResult;
    var url = "http://localhost:5000/search_users";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': searchedFor,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      searchResult = dataReceived["searchresult"];
      searchedPeople = List<String>.from(searchResult);
    });
    searchedPeople.remove(myUsername);
    print(searchedPeople);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        //debugShowCheckedModeBanner: false,
        //title: "Discover new Friends",
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text(
            "Search Results",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        //home: new Material(
        body: Center(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Search Results :',
                      style: TextStyle(
                          fontFamily: 'Dancing',
                          fontStyle: FontStyle.normal,
                          //fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          color: Colors.black),
                    ),
                    // SHOWING ADDED TIMELINE IMAGES AND CANCELING THEM
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          // SHOWING SUGGESTED FRIENDS
                          itemCount: searchedPeople.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: ElevatedButton(
                                child: Text(
                                  searchedPeople[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                //child: Text('Open route'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilOthersPage(
                                            searchedPeople[index])),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    //new Padding(padding: EdgeInsets.only(top: 280.0)),
                    // BOTTOM HOMEPAGE BUTTON
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
}
