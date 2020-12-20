import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_me/Part2/chat_detail_page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../variable.dart';

// ignore: must_be_immutable
class ChatUsersList2 extends StatefulWidget {
  var recIds;
  String text;
  String secondaryText;
  String image;
  String time;
  String token;
  String myname;
  bool isMessageRead;
  ChatUsersList2(
      {@required this.recIds,
      @required this.text,
      @required this.token,
      @required this.secondaryText,
      @required this.image,
      @required this.myname,
      @required this.time,
      @required this.isMessageRead});
  @override
  _ChatUsersList2State createState() => _ChatUsersList2State();
}

class _ChatUsersList2State extends State<ChatUsersList2> {
  @override
  void initState() {
    super.initState();
    setState(() {
      print('chat..............................');
    });
  }

  Key read;
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return InkWell(
      onTap: () {
        // await FirebaseFirestore.instance
        //     .collection('mainscreen')
        //     .doc(curuid)
        //     .collection(widget.myname)
        //     .get()
        //     .then((value) {
        //   value.docs.forEach((res) async {
        //     await FirebaseFirestore.instance
        //         .collection('mainscreen')
        //         .doc(curuid)
        //         .collection(widget.myname)
        //         .doc(res.id)
        //         .get()
        //         .then(
        //       (value) {
        //         if (value.data().containsValue(widget.recIds)) {
        //            value.data().;
        //         }
        //       },
        //     );
        //     // .update({"read": "Yes @R"});
        //   });
        // });

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage2(
            token: widget.token,
            dharaname: widget.text,
            img: widget.image,
            reciverid: widget.recIds,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    //................................................Image Set karva ...................
                    // backgroundImage: AssetImage(widget.image),
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Center(child: Lottie.asset('assets/pl.json')),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    backgroundColor: Color(7),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.text,
                            style: TextStyle(
                                fontFamily: 'font2',
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.secondaryText,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  color: widget.isMessageRead
                      ? Colors.pink
                      : Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
