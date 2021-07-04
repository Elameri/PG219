import 'package:flutter/material.dart';
import 'profile.dart';
import 'signin.dart';
import 'signup.dart';

Widget statWidget(String title, String stat) {
  return Expanded(
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        Text(
          stat,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    ),
  );
}

Widget signInSignUpWidget(BuildContext context) {
  return Expanded(
    child: Column(
      children: [
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
  );
}
