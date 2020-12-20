import 'dart:io';
import 'package:advertising_id/advertising_id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_me/Part2/Firebase/Datab.dart';
import 'package:chat_me/Part2/chat_detail_page2.dart';
import 'package:chat_me/variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class All extends StatefulWidget {
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  //.------------------....----------------.........--------------//
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String searchQuery = null;
  bool goo = true;

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
    if (this.mounted) {
      setState(() {
        _isSearching = true;
        goo = true;
      });
    }
  }

  void _stopSearching() {
    _clearSearchQuery();
    if (this.mounted) {
      setState(() {
        _isSearching = false;
        searchQuery = null;
      });
    }
  }

  void _clearSearchQuery() {
    print("close search box");
    if (this.mounted) {
      setState(() {
        _searchQuery.clear();
        searchQuery = null;
        // clik = false;
        updateSearchQuery("Search query");
      });
    }
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            const Text(
              'All Friends',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Find Your best friend...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    if (this.mounted) {
      setState(() {
        searchQuery = newQuery;
      });
    }

    print("search query " + newQuery);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              searchQuery = null;
              if (this.mounted) {
                setState(() {});
              }
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.search,
          size: 26.6,
          color: Colors.white,
        ),
        onPressed: _startSearch,
      ),
    ];
  }
  //.................................---------------------------//

  String fb_intlice_id = "392131335486178_392140375485274";
  List hivef;
  bool _isInterstitialAdLoaded = false;
  DocumentSnapshot snap;
  var advertisingId;
  Stream _stream =
      FirebaseFirestore.instance.collection('Userinfo').snapshots();
  SharedPreferences preferences;
  @override
  void initState() {
    FacebookAudienceNetwork.init(
        // testingId: "15724176-d525-4876-b0a5-92b3b6c29dde"
        );
    super.initState();
    // _searchQuery = new TextEditingController();
    if (this.mounted) {
      setState(() {
        _loadInterstitialAd();
      });
    }

    openBOx();
  }

  void _loadInterstitialAd() async {
    advertisingId = await AdvertisingId.id;

    await FacebookInterstitialAd.loadInterstitialAd(
      placementId: fb_intlice_id,
      // "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617", //YOUR_PLACEMENT_ID
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.ERROR) {
          print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd({snap}) async {
    if (_isInterstitialAdLoaded == true) {
      await FacebookInterstitialAd.showInterstitialAd().whenComplete(() => {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) => ChatDetailPage2(
                    dharaname: snap.data()['Name'].toString(),
                    img: snap.data()['photo'].toString(),
                    reciverid: snap.id.toString(),
                    token: snap.data()['playerID'],
                  ),
                ))
                .then((value) => {print(snap.data()['playerID'])}),
          });
    } else {
      print("Interstial Ad not yet loaded!");
      // FacebookInterstitialAd.showInterstitialAd();
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => ChatDetailPage2(
              dharaname: snap.data()['Name'].toString(),
              img: snap.data()['photo'].toString(),
              reciverid: snap.id.toString(),
              token: snap.data()['playerID'],
              
            ),
          ))
          .then((value) => {print(snap.data()['playerID'])});
    }
    // FacebookInterstitialAd.showInterstitialAd();
  }

  Future openBOx() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('ChatMe');
    return;
  }

  @override
  Widget build(BuildContext context) {
    print(advertisingId);
    return Scaffold(
      backgroundColor:dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        // title: Text(
        //   'ALL Users',
        //   style: TextStyle(
        //     fontFamily: 'font2',
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        centerTitle: true,
      ),
      body: searchQuery == null
          ? Container(
              child: StreamBuilder(
                stream: _stream,
                builder: (BuildContext context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: Lottie.asset('assets/Newloading.json'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            snap = snapshot.data.docs[index];
                            return cardd(snap: snap);
                          });
                },
              ),
            )
          : Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Userinfo')
                    .where('Name', isGreaterThanOrEqualTo: searchQuery)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: Lottie.asset('assets/Newloading.json'),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print('go..........');
                            DocumentSnapshot snap = snapshot.data.docs[index];
                            return cardd(snap: snap);
                          });
                },
              ),
            ),
    );
  }

  Widget cardd({snap}) {
    return Card(
      color: dark ? Colors.white10 : Colors.white,
      elevation: 3.0,
      borderOnForeground: true,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: InkWell(
          onTap: () => _showDialog(snap.data()["photo"], context),
          child: CircleAvatar(
            child: Container(
              child: CachedNetworkImage(
                imageUrl: snap.data()['photo'],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: Lottie.asset('assets/pl.json')),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              // decoration: new BoxDecoration(
              // shape: BoxShape.circle,
              // image: new DecorationImage(
              //     fit: BoxFit.cover,
              //     image: new NetworkImage(snap.data()["photo"])
              //     )
              // )
            ),
          ),
        ),
        title: Text(
          snap.data()['Name'],
          style: TextStyle(fontFamily: 'font2'),
        ),
        subtitle: Text(
          snap.data()['About'],
          style: TextStyle(fontFamily: 'font2'),
        ),
        onTap: () => ontapCard(snap: snap),
      ),
    );
  }

  ontapCard({snap}) async {
    print('--------------------------------------------------------');
    var advertisingId = await AdvertisingId.id;
    print(advertisingId);
    print('--------------------------------------------------------');

    _showInterstitialAd(snap: snap);
    // Navigator.of(context)x
    //     .push(MaterialPageRoute(
    //       builder: (context) => ChatDetailPage2(
    //         dharaname: snap.data()['Name'].toString(),
    //         img: snap.data()['photo'].toString(),
    //         reciverid: snap.id.toString(),
    //         token: snap.data()['playerID'],
    //       ),
    //     ))
    //     .then((value) => {print(snap.data()['playerID'])});

    //  ---------  HIve Data base    ---------------------------
    print(box.toMap());
    if (box.toMap().containsValue(snap.id)) {
      print('@Uuu not  addded');
    } else {
      Daata().setData(snap: snap, reciverid: snap.id.toString());
      print('@Uuu addded');
      box.add(snap.id);
    }
  }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(StringProperty('fb_intlice_id', fb_intlice_id));
  // }
}

void _showDialog(imgurl, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          child: CachedNetworkImage(
            imageUrl: imgurl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    },
  );
}
