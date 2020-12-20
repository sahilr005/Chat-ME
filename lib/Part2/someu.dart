import 'package:chat_me/Part2/Firebase/Datab.dart';
import 'package:chat_me/Part2/components/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../variable.dart';
import 'All.dart';

class SomePerson extends StatefulWidget {
  @override
  _SomePersonState createState() => _SomePersonState();
}

class _SomePersonState extends State<SomePerson> {
  ScrollController listviewcon = new ScrollController();
  var _myName;
  Daata mains = Daata();
  SharedPreferences preferences;
  var _token;
  @override
  void initState() {
    listviewcon;
    getid();
    super.initState();
  }

  void getid() async {
    preferences = await SharedPreferences.getInstance();
    curuid = preferences.getString('cuurentuid').toString();
    _myName = preferences.getString('name').toString();
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }
    print(_token);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 9.0, bottom: 10.0, left: 10.0),
                      child: Text(
                        "Chat Me",
                        style: TextStyle(
                          fontFamily: 'font1',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => All()));
                            },
                            child: Text(
                              "New..",
                              style: TextStyle(
                                  fontFamily: 'font2',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400, fontFamily: 'font2'),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            _myName == null
                ? Center(
                    child: Lottie.asset('assets/STEAM.json'),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('mainscreen')
                        .doc(curuid)
                        .collection(_myName)
                        .snapshots(),
                    builder: (context, snapshot) {
                      print('....');
                      if (snapshot.hasError) {
                        return Center(child: Lottie.asset('assets/STEAM.json'));
                      }

                      if (!snapshot.hasData) {
                        return Center(child: Lottie.asset('assets/STEAM.json'));
                      } else {
                        return SingleChildScrollView(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              shrinkWrap: true,
                              addAutomaticKeepAlives: true,
                              scrollDirection: Axis.vertical,
                              controller: listviewcon,
                              reverse: true,
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    snapshot.data.documents[index];
                                print(snap.data()['idTo'].toString());
                                print(snap.data()["playerID"].toString());
                                print(snap.data()['recName'].toString());
                                if (box == null) {
                                  Center(
                                      child: Lottie.asset('assets/STEAM.json'));
                                }
                                if (box
                                    .toMap()
                                    .containsValue(snap.data()['idTo'])) {
                                  print('@Uuu NOt Addded');
                                } else {
                                  print('@Uuu addded');
                                  box.add(snap.data()['idTo']);
                                }
                                return ChatUsersList2(
                                  myname: _myName,
                                  token: snap.data()['playerID'].toString(),
                                  recIds: snap.data()['idTo'].toString(),
                                  text: snap.data()['recName'].toString(),
                                  secondaryText:
                                      snap.data()['about'].toString(),
                                  image: snap.data()['photo'].toString(),
                                  isMessageRead: true,
                                  // snap.data()['read'] == 'No'
                                  //     ? false
                                  //     : true,
                                  time: "Chat Now..",
                                );
                              }),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
