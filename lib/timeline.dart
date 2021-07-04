import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'profile.dart';

import 'discover.dart';
import 'main.dart';
import 'search.dart';
import 'widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bio_writing.dart';
import 'confirm_cancel.dart';
import 'img_cmnt_writing.dart';
import 'profile_others.dart';
import 'package:image_picker/image_picker.dart';
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

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  String username = '';
  //List<String> timelinePics = [];
  List<String> timelinePeople = [];
  List<String> timelineImages = [];
  List<String> timelineCaptions = [];
  List<String> timelineProfils = [];
  String avatarChaton =
      "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg";
  List<String> photosTimeline = [
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
  ];

  @override
  void initState() {
    getData();
    //getTimelinePic();
    getFollowedPeople();
    super.initState();
  }

  Future getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myToken = prefs.getString('token');
    var dataReceived;

    var url = "http://localhost:5000/get_profil_data";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': myToken,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      username = dataReceived["username"];
    });

    prefs.setString('username', username);

    getFollowedPeople();
    //getTimelinePic();
  }

  Future getFollowedPeople() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myUsername = prefs.getString('username');
    var dataReceived;
    var myPeople;
    var myImages;
    var myCaptions;
    var myProfils;
    var url = "http://localhost:5000/get_followed_people";

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
      myImages = dataReceived["images"];
      myCaptions = dataReceived["captions"];
      myProfils = dataReceived["profils"];
      timelinePeople = List<String>.from(myPeople);
      timelineImages = List<String>.from(myImages);
      timelineCaptions = List<String>.from(myCaptions);
      timelineProfils = List<String>.from(myProfils);
    });

    //print(timelinePeople);
    //print(timelineImages);
    //print(timelineCaptions);
    //print(timelineProfils);
    if (timelinePeople.length == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiscoverFriends()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: timelinePeople.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      new Row(
                        children: [
                          SizedBox(width: 7.0),
                          CircleAvatar(
                            radius: 20,
                            //backgroundImage: NetworkImage(avatarChaton),
                            backgroundImage: timelinePeople.length == 0
                                ? NetworkImage(avatarChaton)
                                : Image.memory(
                                        base64Decode(timelineProfils[index]))
                                    .image,
                          ),
                          SizedBox(width: 10.0),
                          new Text(
                            //'UserName',
                            timelinePeople.length == 0
                                ? "No Username"
                                : timelinePeople[index],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      new Text(
                        '\n',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 4),
                      ),
                      new Row(children: [
                        new Container(
                          width: 392.00,
                          height: 250.00,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter,
                                //image: NetworkImage(timelineImages[index]),
                                image: timelinePeople.length == 0
                                    ? NetworkImage(photosTimeline[1])
                                    : Image.memory(
                                            base64Decode(timelineImages[index]))
                                        .image),
                          ),
                          /*fit: BoxFit.fitHeight*/
                          //)),
                          child: Align(
                              alignment: FractionalOffset(0, 1.2),
                              child: Text(
                                  //timelinePeople.length == 0 ? "No Caption" : timelineCaptions[index],
                                  " " + timelineCaptions[index],
                                  style: TextStyle(fontSize: 20))),
                          //padding: const EdgeInsets.all(40.0),
                        )
                      ])
                    ],
                  ));
                },
              )),
            ),
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
                          MaterialPageRoute(builder: (context) => ProfilPage()),
                        );
                      },
                      child: Icon(
                        Icons.attribution_outlined,
                        color: Colors.black,
                        size: 58.0,
                      ),
                    ),
                  ),
                ),
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
                new Container(
                  child: new Container(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchUsers()),
                        );
                      },
                      child: Icon(
                        Icons.person_search,
                        color: Colors.black,
                        size: 58.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
