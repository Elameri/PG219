import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bio_writing.dart';
import 'confirm_cancel.dart';
import 'img_cmnt_writing.dart';
import 'profile_others.dart';
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

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String username = '';
  String bio = '';
  String myPrflPic = '';
  String myBio = '';
  List<String> timelinePics = [];
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ImagePicker _pickera = ImagePicker();
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
    getData();
    getTimelinePic();
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
      myPrflPic = dataReceived["profile_picture"];
      myBio = dataReceived["bio"];
      username = dataReceived["username"];
    });

    prefs.setString('username', username);

    getTimelinePic();

    //return profilPic;
  }

  Future getTimelinePic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myToken = prefs.getString('token');
    var myUsername = prefs.getString('username');
    var dataReceived;
    var myPic;

    var url = "http://localhost:5000/get_timeline_pics";

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
      myPic = dataReceived["pics"];
      timelinePics = List<String>.from(myPic);
    });

    //print("blaaablaa3");
    //print(myPic);

    /*
    final bytes = File(
            '/data/user/0/com.example.myapp/cache/image_picker2540302517556514026.jpg')
        .readAsBytesSync();
    String pictureString = base64Encode(bytes);
    */
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
          "Profile Page",
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
              //: FileImage(File(myPrflPic)),
              child: new Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    prendrePhoto(ImageSource.gallery);
                    //addingImageFunction(_imageFile.path);
                  },
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 28.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              //"Chaton A",
              username,
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
            // CHANGING BIO AND ADDING IMAGES
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () async {
                    //getTimelinePic();
                    prendrePhotoTimeline(ImageSource.gallery);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddComm()),
                    );
                  },
                  color: Colors.black,
                  splashColor: Colors.white24,
                  child: Text(
                    "Add an image",
                    style: TextStyle(color: Colors.white),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
                ),
                SizedBox(width: 12.0),
                OutlineButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBio()),
                    );
                  },
                  child: Text("Change Bio"),
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
            // SHOWING ADDED TIMELINE IMAGES AND CANCELING THEM
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
                              image: timelinePics.length == 0
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
                        // CANCELING AN IMAGE
                        child: new Container(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CancelImage(
                                        imgPath: timelinePics[index])),
                              );
                              //prendrePhoto(ImageSource.gallery);
                              //addingImageFunction(_imageFile.path);
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                              size: 28.0,
                            ),
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

  void prendrePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });

    var url = "http://localhost:5000/add_profile_pic";

    final bytes = File(_imageFile.path).readAsBytesSync();
    String pictureString = base64Encode(bytes);

    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'profile_picture': pictureString, //_imageFile.path,
        //'bio': "Hello there",
      }),
    );

    print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parse = jsonDecode(response.body);
    await prefs.setString('token', parse["token"]);
    //String token = prefs.getString("token");
    //print(token);
    getData();
  }

  void prendrePhotoTimeline(ImageSource source) async {
    final pickedFile = await _pickera.getImage(
      source: source,
    );

    setState(() {
      _imageFile = pickedFile;
    });

    final bytes = File(_imageFile.path).readAsBytesSync();
    String pictureString = base64Encode(bytes);

    //print(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var parse = jsonDecode(response.body);
    //await prefs.setString('token', parse["token"]);
    await prefs.setString('picture', pictureString); //_imageFile.path);

    //getData();
  }
}
