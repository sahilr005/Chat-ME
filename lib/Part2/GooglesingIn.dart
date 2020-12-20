import 'package:chat_me/Part2/Firebase/Datab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homemain.dart';

class GoogleSgin extends StatefulWidget {
  @override
  _GoogleSginState createState() => _GoogleSginState();
}

class _GoogleSginState extends State<GoogleSgin> {
  User user;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Column(
          children: [
            // Lottie.asset('assets/ami.json'),
            Lottie.asset('assets/bird.json'),

            RaisedButton(
                child: Text("Login"),
                onPressed: () async {
                  signInWithGoogle();
                }),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    print("Sign in now");
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async => {
              user = FirebaseAuth.instance.currentUser,
              print(user.uid),
              prefs = await SharedPreferences.getInstance(),
              prefs.setString('email', user.email.toString()),
              prefs.setString('photo', user.photoURL.toString()),
              print(',,,,,,,,,,,,,,get email,,,,,,,,,,,,,'),
              print(prefs.getString('email')),
              print(',,,,,,,,,,,,,,get email,,,,,,,,,,,,,'),
              prefs.setString('cuurentuid', user.uid.toString()),
              print(',,,,,,,,,,,,,,set uid...,,,,,,,,,,,,,${user.uid}'),
              prefs.setString('name', user.displayName.toString()),
              print(prefs.getString('email')),
              sendData(
                  name: user.displayName == null
                      ? 'Set Name'
                      : user.displayName.toString(),
                  about: "Friend",
                  photoUrl: user.photoURL,
                  uid: user.uid),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (s) => MainPage())),
            });
  }
}
