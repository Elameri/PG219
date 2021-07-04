import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search.dart';
import 'signin.dart';
import 'signup.dart';
import 'colors.dart';
import 'profile.dart';
import 'timeline.dart';
import 'widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INPGram',
      theme: ThemeData(fontFamily: 'Dancing', primarySwatch: primaryBlack),
      home: MyHomePage(title: 'INPGram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  //Fields in a Widget subclass are always marked "final".
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    checkToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");
      if (token != null && token != "") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignedInSection()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotSignedInSection()),
        );
      }
    }

    checkToken();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            new Container(
              height: 200.0,
              width: 200.0,
              decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('img/eirb.png'), fit: BoxFit.fill),
                  shape: BoxShape.circle),
            ),
            new Container(
              child: new Text(
                'Welcome to INPGram',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Nanum',
                    fontStyle: FontStyle.normal,
                    //fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.black),
              ),
            ),
            signInSignUpWidget(context),
          ],
        ),
      ),

      /**/
      floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimelinePage()),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      /**/
    );
  }
}

class NotSignedInSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("INPGram"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 12.0,
            ),
            new Container(
              height: 120.0,
              width: 120.0,
              decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('img/eirb.png'), fit: BoxFit.fill),
                  shape: BoxShape.circle),
            ),
            new Container(
              child: new Text(
                'Welcome to INPGram',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Nanum',
                    fontStyle: FontStyle.normal,
                    //fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.black),
              ),
            ),
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: ElevatedButton(
                      child: Text('Sign Up'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                    width: 12.0,
                  ),
                  new Container(
                    child: ElevatedButton(
                      child: Text('Sign In'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignedInSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("INPGram"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 12.0,
            ),
            new Container(
              height: 120.0,
              width: 120.0,
              decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: new AssetImage('img/eirb.png'), fit: BoxFit.fill),
                  shape: BoxShape.circle),
            ),
            new Container(
              child: new Text(
                'Welcome to INPGram',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Nanum',
                    fontStyle: FontStyle.normal,
                    //fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            new Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: ElevatedButton(
                      child: Text('Go to My Profil Page'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ProfilPage()),
                        );
                        //Navigator.pushReplacementNamed(context, "ProfilPage");
                      },
                    ),
                  ),
                  new Container(
                    child: ElevatedButton(
                      child: Text('Go to My Timeline'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new TimelinePage()),
                        );
                        //Navigator.pushReplacementNamed(context, "ProfilPage");
                      },
                    ),
                  ),
                  new Container(
                    child: ElevatedButton(
                      child: Text('Search for someone'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SearchUsers()),
                        );
                        //Navigator.pushReplacementNamed(context, "ProfilPage");
                      },
                    ),
                  ),
                  new Container(
                    child: ElevatedButton(
                      child: Text('Log Out'),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('token', "");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotSignedInSection()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
