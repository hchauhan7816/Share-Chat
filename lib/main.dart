import 'package:flutter/material.dart';
import 'package:sharechat/helper/authenticate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sharechat/helper/helperfunctions.dart';
import 'package:sharechat/views/chatRoomScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  bool isUserLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        isUserLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("${snapshot.error}");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Color(0xff145C9E),
              scaffoldBackgroundColor: Color(0xff1F1F1F),
              primarySwatch: Colors.blue,
            ),
            home: isUserLoggedIn != null
                ? isUserLoggedIn
                    ? ChatRoom()
                    : Authenticate()
                : Authenticate(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class NothingToShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
