import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String email, nickname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .whenComplete(() => Navigator.of(context).pop());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String? name = snapshot.data!['name'];
              return Text(
                'Welcome $name',
                style: const TextStyle(fontSize: 30),
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
