import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bio_writing.dart';
import 'confirm_cancel.dart';
import 'img_cmnt_writing.dart';
import 'profile.dart';
import 'search.dart';
import 'timeline.dart';
import 'widgets.dart';
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

class ProfilOthersPage extends StatefulWidget {
  final String nom;
  const ProfilOthersPage(this.nom);

  @override
  _ProfilOthersPageState createState() => _ProfilOthersPageState();
}

class _ProfilOthersPageState extends State<ProfilOthersPage> {
  String mainUsername = '';
  String bio = '';
  String myPrflPic = '';
  String myBio = '';
  int follow = 0;
  String followString = '';
  List<String> timelinePics = [];
  String avatarImage =
      "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg";
  String whiteBack =
      "https://mulder-onions.com/wp-content/uploads/2017/02/White-square.jpg";
  List<String> photosTimeline = [
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
    "https://pixnio.com/free-images/2019/07/20/2019-07-20-14-08-40-460x307.jpg",
  ];

  @override
  void initState() {
    getDataFromUsername(widget.nom);
    isFollowed(widget.nom);
    getTimelinePic(widget.nom);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          "Friends' Profile Page",
          //widget.nom,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        //SHOWING PROFIL PIC AND BIO
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 12.0,
            ),
            CircleAvatar(
              radius: 56,
              backgroundImage: myPrflPic == ''
                  ? NetworkImage(avatarImage)
                  : Image.memory(base64Decode(myPrflPic)).image,
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              //"Chaton A",
              //username,
              widget.nom,
              //_imageFile == null ? username : _imageFile.path,
              //myPrflPic == '' ? username : myPrflPic,
              style: TextStyle(
                color: Colors.grey[75],
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                statWidget("Bio",
                    myBio == "" ? "Hello there, I'm using INPGram !" : myBio),
                //statWidget("Posts", "100"),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () async {
                    follow == 0
                        ? followFunction(mainUsername, widget.nom)
                        : unfollowFunction(mainUsername, widget.nom);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ()),
                    );
                    */
                  },
                  color: Colors.black,
                  splashColor: Colors.white24,
                  child: Text(
                    //follow == 0 ? "Follow" : "Unfollow",
                    followString,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 12.0,
                thickness: 0.6,
                color: Colors.black54,
              ),
            ),
            // SHOWING ADDED TIMELINE IMAGES
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  // SHOWING ADDED TIMELINE IMAGES
                  itemCount: timelinePics.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                              image: myPrflPic == ''
                                  ? NetworkImage(whiteBack)
                                  : Image.memory(
                                          base64Decode(timelinePics[index]))
                                      .image),
                          //Image.memory(base64Decode(timelinePics[index])).image),
                          //FileImage(File(timelinePics[index]))),
                          border: Border.all(
                            color: Colors.white,
                            width: 8,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                          MaterialPageRoute(
                              builder: (context) => TimelinePage()),
                        );
                      },
                      child: Icon(
                        Icons.view_day,
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future getDataFromUsername(String nom) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var dataReceived;
    var url = "http://localhost:5000/get_profil_data_from_username";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': nom,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      myPrflPic = dataReceived["profile_picture"];
      myBio = dataReceived["bio"];
      mainUsername = prefs.getString("username");
    });

    getTimelinePic(nom);
    //return profilPic;
  }

  Future getTimelinePic(String nom) async {
    var dataReceived;
    var myPic;

    var url = "http://localhost:5000/get_timeline_pics";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': nom,
      }),
    );

    dataReceived = jsonDecode(response.body);
    setState(() {
      myPic = dataReceived["pics"];
      timelinePics = List<String>.from(myPic);
    });
  }

  Future followFunction(String nomFollower, String nomFollowed) async {
    var url = "http://localhost:5000/follow";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'follower': nomFollower,
        'followed': nomFollowed,
      }),
    );

    isFollowed(widget.nom);
  }

  Future unfollowFunction(String nomFollower, String nomFollowed) async {
    //var dataReceived;
    var url = "http://localhost:5000/unfollow";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'follower': nomFollower,
        'followed': nomFollowed,
      }),
    );

    isFollowed(widget.nom);
  }

  Future isFollowed(String nomFollowed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUsername = prefs.getString("username");
    var dataReceived;
    var url = "http://localhost:5000/isfollowed";

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'follower': mainUsername,
        'followed': nomFollowed,
      }),
    );

    dataReceived = jsonDecode(response.body);

    print("data received");
    print(dataReceived);

    setState(() {
      follow = dataReceived["binaryFollow"];
      follow == 0 ? followString = "Follow" : followString = "Unfollow";
    });

    print("follow is");
    print(follow);
  }
}
