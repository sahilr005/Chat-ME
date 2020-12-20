import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchN extends StatefulWidget {
  @override
  _SearchNState createState() => _SearchNState();
}

class _SearchNState extends State<SearchN> {
  search(sname) async {
    return await FirebaseFirestore.instance
        .collection('Userinfo')
        .where('Name', isGreaterThanOrEqualTo: sname)
        .snapshots;
  }

  bool clik = false;
  Stream str;
  String sssn;
  TextEditingController serc = TextEditingController();

  // Stream _stream = FirebaseFirestore.instance
  //     .collection('Userinfo')
  //     .where('Name', isGreaterThanOrEqualTo: serc.text.toString)
  //     .snapshots();
  //.------------------....----------------.........--------------//
  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();
  TextEditingController _searchQuery;
  bool _isSearching = false;
  String searchQuery = "Search query";

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    setState(() {
      _searchQuery.clear();
      clik = false;
      updateSearchQuery("Search query");
    });
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
            const Text('Seach box'),
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
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {

    setState(() {
      searchQuery = newQuery;
    });
    print("search query " + newQuery);

  }

  List<Widget> _buildActions() {

    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }
  //.................................---------------------------//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        // title: Text('search'),
        // actions: [
        //   IconButton(onPressed: () {}, icon: Icon(Icons.search_off_rounded))
        // ],
      ),
      body: ListView(
        children: [
          TextField(
            controller: serc,
          ),
          RaisedButton(
              onPressed: () {
                clik = true;
                print('click');
                setState(() {
                  // sssn = serc.text.toString();
                  sssn =  searchQuery;
                });
              },
              child: Text("go")),
          clik
              ? Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Userinfo')
                        .where('Name', isGreaterThanOrEqualTo: sssn)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: Lottie.asset('assets/load3.json'),
                            )
                          : ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                print('go..........');
                                DocumentSnapshot snap =
                                    snapshot.data.docs[index];
                                return ListTile(
                                  title: Text(
                                    snap.data()['Name'],
                                  ),
                                  subtitle: Text(
                                    snap.data()['About'],
                                  ),
                                );
                              });
                    },
                  ),
                )
              : Container(
                  child: Text("hello"),
                ),
        ],
      ),
    );
  }
}
