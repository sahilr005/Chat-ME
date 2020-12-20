import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../variable.dart';

// ignore: must_be_immutable
class ChatDetailPageAppBar2 extends StatelessWidget
    implements PreferredSizeWidget {
  var dharaname;
  var img;
  var listofmessage;
  ChatDetailPageAppBar2({this.dharaname, this.img, this.listofmessage});
  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Image.network(img),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: dark ? Colors.black : Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              InkWell(
                onTap: () {
                  print('.');
                  _showDialog();
                },
                child: CircleAvatar(
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                  ),
                  backgroundColor: Colors.black12,
                  maxRadius: 23,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      dharaname.toString(),
                      // recName3,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontFamily: 'font2'),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    // Text(
                    //   "Online",
                    //   style: TextStyle(color: Colors.green, fontSize: 12),
                    // ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  print(',,,,,,,,,,,,,,,,,,,,,,,,,,,list of length');
                  Flushbar(
                    flushbarPosition: FlushbarPosition.TOP,
                    title: 'Number of Message',
                    flushbarStyle: FlushbarStyle.FLOATING,
                    duration: Duration(seconds: 2),
                    // message: listoflength.toString(),
                    message: listofmessage.toString(),
                    margin: EdgeInsets.all(28),
                    borderRadius: 8,
                  )..show(context);
                },
                child: Icon(
                  Icons.more_vert,
                  color: dark ? Colors.white : Colors.grey.shade700 ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
