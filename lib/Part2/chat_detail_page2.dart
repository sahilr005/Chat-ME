import 'package:intl/intl.dart';
import 'package:chat_me/Part2/components/chat_detail_page_appbar.dart';
import 'package:chat_me/Part2/send_menu_items2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../variable.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage2 extends StatefulWidget {
  final reciverid;
  final dharaname;
  final img;
  final token;
  ChatDetailPage2({this.reciverid, this.dharaname, this.img, this.token});
  @override
  _ChatDetailPage2State createState() =>
      _ChatDetailPage2State(reciverid, dharaname, img, token);
}

class _ChatDetailPage2State extends State<ChatDetailPage2> {
  var reciverid;
  var img;
  var dharaname;
  final token;
  int listoflength = 0;
  ScrollController listScrollController = new ScrollController();

  _ChatDetailPage2State(this.reciverid, this.dharaname, this.img, this.token);
  List<SendMenuItems2> menuItems = [
    SendMenuItems2(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems2(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems2(
        text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems2(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems2(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: ListView(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          color: dark ? Colors.black : Colors.grey.shade200,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        itemCount: menuItems.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
                              Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                title: 'No Supported',
                                flushbarStyle: FlushbarStyle.FLOATING,
                                duration: Duration(seconds: 3),
                                message: 'Sorry For that...',
                                margin: EdgeInsets.all(28),
                                borderRadius: 8,
                              )..show(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: dark
                                        ? Colors.black
                                        : menuItems[index].color.shade50,
                                  ),
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    menuItems[index].icons,
                                    size: 20,
                                    color: menuItems[index].color.shade400,
                                  ),
                                ),
                                title: Text(menuItems[index].text),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

//..........,,,,,,,,,,,,,,,.................,,,,,,,,,,,,,,'''''''''''''''...........'''''''''''''''.................
  TextEditingController mess = TextEditingController();
  var date = DateTime.now().millisecond;
  Key chatingKey = GlobalKey();
  var tempchatid;
  // ignore: unused_field
  var _myName;
  String chatid;
  // ignore: unused_field
  Stream _stream;

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        getid();
        chatid = "";
        readlocal();
      });
    }
  }

  void _handleSendNotification({nmsg, imagw}) async {
    print(dharaname);
    var notification = OSCreateNotification(
      playerIds: [token],
      content: nmsg.toString(),
      heading: dharaname,
      androidLargeIcon: img,
      collapseId: token,
      // androidChannelId: "IMPORTANCE_HIGH",
      mutableContent: false,
    );
    var response = await OneSignal.shared.postNotification(notification);
    if (this.mounted) {
      this.setState(() {
        print(dharaname +
            '------------------------------------------------------------------------------------------------');
        print(response);
        print(
            '------------------------------------------------------------------------------------------------');
      });
    }
  }

  void sterem() async {
    FirebaseFirestore.instance
        .collection('message')
        .doc(chatid)
        .collection(chatid)
        .snapshots();
    if (this.mounted) {
      setState(() {});
    }
  }

  void getid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    curuid = preferences.getString('cuurentuid').toString();
    print('----------------------------');
    print('Get Id');
    print(curuid);
    print('----------------------------');
    _myName = preferences.getString('name').toString();
    if (this.mounted) {
      setState(() {});
    }
  }

  void readlocal() async {
    if (curuid.hashCode <= reciverid.hashCode) {
      chatid = '$curuid-$reciverid';
    } else {
      chatid = '$reciverid-$curuid';
      tempchatid = '$reciverid-$curuid';
    }
    print('----------------------------');
    print('$reciverid' + 'recvier id......   .... .. ... . . .');
    print('cur User Id ' + curuid);
    print('----------------------------');
    FirebaseFirestore.instance
        .collection('Userinfo')
        .doc(curuid)
        .update({'chattingWith': '$reciverid'}).catchError(
            (d) => print('----------------------------'));
  }

  void updatereadMess() async {
    if (chatid.startsWith(reciverid)) {
      await FirebaseFirestore.instance
          .collection('message')
          .doc(chatid)
          .collection(chatid)
          .get()
          .then((value) {
        value.docs.forEach((res) {
          FirebaseFirestore.instance
              .collection('message')
              .doc(chatid)
              .collection(chatid)
              .doc(res.id)
              .update({"read": "Yes @M @R"});
        });
      });
    }
  }
//............,,,,,,,,,,'''''''''''''''..........,,,,,,,,,,''''''''''''''''............,,,,,,,,,,;;;;;;;;''''''''
//                              MESSAGE       SENDING     -----------------
//............,,,,,,,,,,'''''''''''''''..........,,,,,,,,,,''''''''''''''''............,,,,,,,,,,;;;;;;;;''''''''

  void onsendmessage({String msg, imagw}) async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('kk:mm:ss');
    final String formatted = formatter.format(now);
    print(formatted);

    if (mess.text != "") {
      mess.clear();
      var docref = FirebaseFirestore.instance
          .collection('message')
          .doc(chatid)
          .collection(chatid)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docref, {
          "idFrom": curuid.toString(),
          "idTo": reciverid.toString(),
          "read": "No",
          "chatid": chatid,
          // "recName" :recName,
          // "timestemp": DateTime.now().millisecondsSinceEpoch.toString(),
          "timestemp": formatted,
          "contentmesg": msg.toString(),
          'playerID': token
        });
      });
      _handleSendNotification(nmsg: msg.toString(), imagw: imagw);
      if (this.mounted) {
        setState(() {});
      }
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: 'No Text',
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        message: 'Enter Someting',
        margin: EdgeInsets.all(28),
        borderRadius: 8,
      )..show(context);
    }
  }

  void listofMessageLength() async {
    await FirebaseFirestore.instance
        .collection('message')
        .doc(chatid)
        .collection(chatid)
        .get()
        .then((QuerySnapshot value) =>
            {listoflength = value.docs.length, print(value.docs.length)});
    if (this.mounted) {
      setState(() {});
    }
  }

  void nothing() {
    print('nothing calalll................292');
  }

//....,,,,,,,,,,;;;;;;;;;;;;;;;;;'''''''''''''''''''........,,,,;'..........
  @override
  Widget build(BuildContext context) {
    listofMessageLength();
    // print(token);
    print(chatid);
    if (this.mounted) {
      setState(() {});
    }
    return Scaffold(
      appBar: ChatDetailPageAppBar2(
        dharaname: dharaname.toString(),
        img: img,
        listofmessage: listoflength,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            key: chatingKey,
            stream: FirebaseFirestore.instance
                .collection('message')
                .doc(chatid)
                .collection(chatid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                Center(
                  child: Lottie.asset(
                    'assets/Newloading.json',
                  ),
                );
              }
              return !snapshot.hasData
                  ? Center(
                      child:
                          Center(child: Lottie.asset('assets/Newloading.json')),
                    )
                  : SingleChildScrollView(
                      child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          controller: listScrollController,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          reverse: true,
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                snapshot.data.documents[index];

                            snap.data()['idTo'] == curuid
                                ? updatereadMess()
                                : nothing();

                            //...........,,,,,,,,,-------------;;;;;;;;;;'''''''''''''''''
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              child: Align(
                                alignment: (snap.data()['idTo'] == curuid
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: (snap.data()['idTo'] == curuid
                                        ? dark
                                            ? Colors.black
                                            : Colors.white
                                        : dark
                                            ? Colors.black45
                                            : Colors.grey.shade200),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: InkWell(
                                      onTap: () {
                                        Flushbar(
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                          title: "Time",
                                          flushbarStyle: FlushbarStyle.FLOATING,
                                          duration: Duration(seconds: 2),
                                          message: snap
                                              .data()["timestemp"]
                                              .toString(),
                                          margin: EdgeInsets.all(28),
                                          borderRadius: 8,
                                        )..show(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(snap.data()["contentmesg"]),
                                          snap.data()["read"] != null
                                              ? snap.data()['idTo'] == curuid
                                                  ? Offstage()
                                                  // snap.data()['read'] == 'No'
                                                  //     ? Icon(Icons.ac_unit)
                                                  //     : Icon(Icons.check)
                                                  : snap.data()['read'] == 'No'
                                                      ? Icon(
                                                          Icons
                                                              .done_all_rounded,
                                                          color: dark
                                                              ? Colors.yellow
                                                              : Colors.blue,
                                                          size: 15,
                                                        )
                                                      : Icon(
                                                          Icons.done_all,
                                                          color: dark
                                                              ? Colors
                                                                  .pinkAccent
                                                              : Colors.green,
                                                          size: 18,
                                                        )
                                              : Offstage(),

                                          // Icon(Icons.check),
                                          //................................
                                          // snap.data()["read"] != null
                                          //     ? Text(snap.data()["read"])
                                          //     : Text("No Data"),
                                        ],
                                      )),
                                ),
                              ),
                            );
                          }),
                    );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: 80,
              width: double.infinity,
              color: Colors.white12,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: mess,
                      style:
                          TextStyle(color: dark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 50),
              child: FloatingActionButton(
                onPressed: () {
                  onsendmessage(msg: mess.text, imagw: img);
                },
                child: Center(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.pink,
                elevation: 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}
