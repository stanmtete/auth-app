import 'package:flutter/material.dart';
import './app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC0eJxMDDqgs9KWPddM6iUbD4ujv8ZdaNw",
      authDomain: "random-app-9e8bc.firebaseapp.com",
      projectId: "random-app-9e8bc",
      storageBucket: "random-app-9e8bc.appspot.com",
      messagingSenderId: "89153194040",
      appId: "1:89153194040:web:8c4604b0b47aabda5ffecd",
    ),
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}
