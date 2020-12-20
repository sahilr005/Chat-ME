import 'package:chat_me/splec.dart';
import 'package:chat_me/variable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var emailgloble;
Future<void> main() async {
  SharedPreferences prefs;
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  prefs = await SharedPreferences.getInstance();
  emailgloble = prefs.getString('email').toString();
  
  print(emailgloble);
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              home: Splec(),
            );
          },
        ),);
  }
}
//   runApp(MaterialApp(
    
//     // Dark mode............
//       // theme: ThemeData(
//       //   brightness: Brightness.dark,
//       // ),
//       // darkTheme: ThemeData(
//       //   brightness: Brightness.dark,
//       // ), themeMode: ThemeMode.dark, 
//       title: 'Chat Me',
//       debugShowCheckedModeBanner: false,
//       home: Splec()));
// }

// void checkInternaet() async {
//   try {
//     final result = await InternetAddress.lookup('google.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       print('connected');
//     }
//   } on SocketException catch (_) {
//     print('not connected');
//   }
//   setState(() {});
// }

//------------------------Splesc screen ----------------------------
//------------------------Face book Ads screen ----------------------------
