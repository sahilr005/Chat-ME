import 'dart:async';
import 'package:intl/intl.dart';
import 'package:chat_me/Part2/GooglesingIn.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Part2/homemain.dart';
import 'package:flutter/material.dart';
import 'variable.dart';

class Splec extends StatefulWidget {
  @override
  _SplecState createState() => _SplecState();
}

class _SplecState extends State<Splec> {
  SharedPreferences _preferences ;
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (a) => MainPage()));
    } else {
      Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => GoogleSgin()))
          .then((value) => {
                prefs.setBool('seen', true),
              });
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    openBOx();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('kk:mm:ss');
    final String formatted = formatter.format(now);
    print(formatted);
  }

  Future openBOx() async {
    setState(() {});
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('ChatMe');
    return;
  }

  Future<void> initPlatformState() async {
    
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("b7f8c97a-8029-47be-8058-26365eed17e4", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      checkFirstSeen();
      
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/logo9.png"),
          )),
        ),
      ),
    );
  }
}
