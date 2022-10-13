import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../screens/Splash/SplashScreen.dart';

class FirebaseAuthApp extends StatefulWidget {
  @override
  _FirebaseAuthAppState createState() => _FirebaseAuthAppState();
}

class _FirebaseAuthAppState extends State<FirebaseAuthApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: FirebaseAuthAppRoutes().routes,
    );
  }
}
