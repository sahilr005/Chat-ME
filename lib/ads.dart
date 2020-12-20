import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class AdsF extends StatefulWidget {
  @override
  _AdsFState createState() => _AdsFState();
}

class _AdsFState extends State<AdsF> {
  String fb_intlice_id = "370965424264155_378769796817051";
  bool _isInterstitialAdLoaded = false;
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );
  @override
  void initState() {
    FacebookAudienceNetwork.init(
        // testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6"
        testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41"
        );
    super.initState();
    setState(() {
      _loadInterstitialAd();
    });
  }

  void _loadInterstitialAd() async {
    await FacebookInterstitialAd.loadInterstitialAd(
      placementId:
          "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617", //YOUR_PLACEMENT_ID
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  _showInterstitialAd() async {
    if (_isInterstitialAdLoaded == true)
      await FacebookInterstitialAd.showInterstitialAd()
          .then((value) => print(value));
    else
      print("Interstial Ad not yet loaded!");
    // FacebookInterstitialAd.showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: Center(
          child: RaisedButton(
        onPressed: () => _showInterstitialAd(),
        child: Text('click'),
      )),
    );
  }
}
