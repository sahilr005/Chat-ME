import 'package:chat_me/variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
SharedPreferences prefs;
sendData({name, about, photoUrl, uid}) async {
  var status = await OneSignal.shared.getPermissionSubscriptionState();
  var playerId = status.subscriptionStatus.userId;
  curplayerId = status.subscriptionStatus.userId;
  return await firestore.collection('Userinfo').doc(uid).set({
    'id': uid,
    'Name': name,
    'About': about,
    'chattingWith': null,
    'photo': photoUrl,
    'playerID': playerId
  });
}

class Daata {
  var chatid;
  var disname;
  SharedPreferences preferences;

  void setData({snap, reciverid}) async {
    preferences = await SharedPreferences.getInstance();
    final curuid = preferences.getString('cuurentuid').toString();
    final disName = preferences.getString('name').toString();
    final photo = preferences.getString('photo').toString();
    disname = disName;
    if (curuid.hashCode <= reciverid.hashCode) {
      chatid = '$curuid-$reciverid';
    } else {
      chatid = '$reciverid-$curuid';
    }
    var docref = FirebaseFirestore.instance
        .collection('mainscreen')
        .doc(curuid.toString())
        .collection(disName.toString())
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(docref, {
        "idFrom": disName.toString(),
        "idTo": snap.id.toString(),
        "recName": snap.data()['Name'].toString(),
        "about": snap.data()['About'].toString(),
        "photo": snap.data()['photo'].toString(),
        "read": "No",
        'playerID': snap.data()['playerID'].toString(),
        "timestemp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });

    var recobj = FirebaseFirestore.instance
        .collection('mainscreen')
        .doc(snap.id.toString())
        .collection(snap.data()['Name'].toString())
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(recobj, {
        "idTo": curuid.toString(),
        "recName": disName.toString(),
        "about": 'set About..',
        "photo": photo,
        'playerID': curplayerId,
        "timestemp": DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });

    // Message dilog box ma show
    // var recmess = FirebaseFirestore.instance
    //     .collection('dilogmessage')
    //     .doc(snap.id.toString())
    //     .collection(snap.data()['Name'].toString())
    //     .doc(DateTime.now().millisecondsSinceEpoch.toString());

    //   FirebaseFirestore.instance.runTransaction((transaction) async {
    //     transaction.set(recmess, {
    //       "idTo": curuid.toString(),
    //       "recName": disName.toString(),
    //       "about": 'See Message',
    //       "photo": photo,
    //       "timestemp": DateTime.now().day.toString(),
    //     });
    //   });
  }

  // mainstre() {
  //   if (chatid == null) {
  //     chatid = curuid;
  //   }
  //   Stream mainsterm = FirebaseFirestore.instance
  //       .collection('mainscreen')
  //       .doc(curuid.toString())
  //       .collection(disname.toString())
  //       .snapshots();
  //   return mainsterm;
  // }
}
