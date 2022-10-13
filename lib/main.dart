import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'widgets/Main/FAState.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.done) {
          return FirebaseAuthApp();
        }

         return const CircularProgressIndicator();
      });
  }
}