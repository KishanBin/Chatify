import 'package:chatify/Pages/loginPage.dart';
import 'package:chatify/Pages/chatScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.length == 0) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDPMspLYZ1t0192wbRuxZqQjhRDJj2s6hg",
            appId: "1:138345063557:android:9ba56ce16bb263647bf5ec",
            messagingSenderId: "138345063557",
            projectId: "chatify-11669",
            storageBucket: "chatify-11669.appspot.com"));
  } else {
    print('Firebase already initialized');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, onPrimary: Colors.white),
      ),
      home: const LoginPage(),
    );
  }
}
