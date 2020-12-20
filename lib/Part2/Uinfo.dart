import 'dart:async';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:chat_me/Part2/GooglesingIn.dart';
import 'package:chat_me/variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfomation extends StatefulWidget {
  @override
  _UserInfomationState createState() => _UserInfomationState();
}

class _UserInfomationState extends State<UserInfomation> {
  FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences prefs;
  signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('email', null).then((value) => {
          prefs.setString('photo', null),
          prefs.setString('cuurentuid', null),
          prefs.setString('name', null),
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (a) => GoogleSgin()))
        });
    await auth.signOut();
    print('out......');
    if (this.mounted) {
      setState(() {});
    }
  }

  File _image;
  final picker = ImagePicker();
  var imglink;
  var url;
  var name;
  var about;
  Future<DocumentSnapshot> getimg() async {
    print('---------------img');
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Userinfo')
        .doc(curuid)
        .get();
    url = documentSnapshot.data()['photo'].toString();

    name = await FirebaseFirestore.instance
        .collection('Userinfo')
        .doc(curuid)
        .get()
        .then(
            (DocumentSnapshot snap) => {name = snap.data()['Name'].toString()});

    about = await FirebaseFirestore.instance
        .collection('Userinfo')
        .doc(curuid)
        .get()
        .then((DocumentSnapshot snap) =>
            {about = snap.data()['About'].toString()});
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getimg();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    if (this.mounted) {
      setState(() {
        getimg();
        print('work');
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark
            ? Colors.pinkAccent.withOpacity(0.8)
            : Colors.black.withOpacity(0.8),
        iconTheme: IconThemeData(color:Colors.white),
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Thnak You '),
              decoration: BoxDecoration(
                color: dark ? Colors.pink : Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/logo9.png"),
                ),
              ),
            ),
            SwitchListTile(
              value: themeChange.darkTheme,
              onChanged: (bool value) {
                themeChange.darkTheme = value;
              },
              title: Text('Dark them'),
            ),
            Divider(
              color: dark ? Colors.white : Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Share.share(
                    'Hello Friends Download this and chat with your best Friend https://play.google.com/store/apps/details?id=com.sahil.dkb321.chat_me');
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Rate us'),
              onTap: () async {
                const url =
                    'https://play.google.com/store/apps/details?id=com.sahil.dkb321.chat_me';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent),
              title: Text('Contacts us'),
              onTap: () async {
                const instraurl = "https://www.instagram.com/sahilr05/?hl=en";
                if (await canLaunch(instraurl)) {
                  await launch(instraurl);
                } else {
                  throw 'Could not launch $instraurl';
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage().whenComplete(() => () {
                if (this.mounted) {
                  setState(() {});
                }
              });
        },
        tooltip: 'Change Photo',
        backgroundColor: Colors.teal,
        child: Icon(Icons.add_a_photo),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
                color: dark
                    ? Colors.pinkAccent.withOpacity(0.8)
                    : Colors.black.withOpacity(0.8)),
            clipper: getClipper(),
          ),
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: <Widget>[
                  url == null
                      ? Center(child: Lottie.asset('assets/load2.json'))
                      : Center(
                          child: Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  image: DecorationImage(
                                      image: NetworkImage(url.toString()),
                                      fit: BoxFit.cover),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(75.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 7.0, color: Colors.black)
                                  ])),
                        ),
                  SizedBox(height: 35.0),
                  Text(
                    name == null ? 'name' : '$name',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    about == null ? 'About' : '$about',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 25.0),
                  Container(
                      height: 35.0,
                      width: 140.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            _showMaterialDialog();
                          },
                          child: Center(
                            child: Text(
                              'change Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 25.0),
                  Container(
                      height: 30.0,
                      width: 140.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.redAccent,
                        color: Colors.red,
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () async {
                            signOut();
                          },
                          child: Center(
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ))
                ],
              ))
        ],
      )),
    );
  }

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    FirebaseStorage fs = FirebaseStorage.instance;
    StorageReference rootref = fs.ref();
    StorageReference picther = rootref.child(curuid);
    picther.putFile(_image).onComplete.then((value) async {
      String link = await value.ref.getDownloadURL();
      setState(() {
        imglink = link;
        updateUser();
      });
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Userinfo');
  Future<void> updateUser() {
    print('goo');
    return users
        .doc(curuid)
        .update({'photo': imglink})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> updateName({name}) {
    if (this.mounted) {
      setState(() {});
    }
    return users
        .doc(curuid)
        .update({'Name': name})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    
  }

  Future<void> updateAbou({about}) {
    if (this.mounted) {
      setState(() {});
    }
    return users
        .doc(curuid)
        .update({'About': about.toString()})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Edit Profile"),
              content: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Change Name...", labelText: "Name"),
                    onChanged: (value) {
                      name = value.toString();
                      updateName(name: value.toString());
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Change About...", labelText: "About"),
                    onChanged: (value) {
                      updateAbou(about: value.toString());
                      about = value.toString();
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Save me!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
