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

class DiscoverFriends extends StatefulWidget {
  @override
  _DiscoverFriendsState createState() => _DiscoverFriendsState();
}

class _DiscoverFriendsState extends State<DiscoverFriends> {
  List<String> allPeople = [];

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  Future getAllUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myUsername = prefs.getString('username');
    var dataReceived;
    var myPeople;
    var url = "http://localhost:5000/get_all_users";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': myUsername,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      myPeople = dataReceived["people"];
      allPeople = List<String>.from(myPeople);
    });

    print(allPeople);
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
            "Timeline Page",
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
                      'People you may know',
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
                          itemCount: allPeople.length,
                          itemBuilder: (context, index) {
                            /*
                            return RichText(
                              text: TextSpan(
                                //text: 'Hello ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: allPeople[index],
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilOthersPage(
                                                          allPeople[index]
                                                              .toString())),
                                            )),
                                ],
                              ),
                            );
                            */

                            return Center(
                              child: ElevatedButton(
                                child: Text(
                                  allPeople[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                //child: Text('Open route'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilOthersPage(allPeople[index])),
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
