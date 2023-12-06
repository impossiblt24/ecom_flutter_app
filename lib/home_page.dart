// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:cuoiky/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void signOutBut() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );
    FirebaseAuth.instance.signOut();
    if (context.mounted) Navigator.pop(context);
  }

  void goToProfilePage(){
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage(),
      )
    );
  }

  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed in as: " + user.email!),
            MaterialButton(onPressed: () {
              
              FirebaseAuth.instance.signOut();
            },
            color: Colors.blueAccent,
            child: Text("Sign Out"),
            ),
            MaterialButton(onPressed: () {
              goToProfilePage();
              // FirebaseAuth.instance.signOut();
            },
            color: Colors.blueAccent,
            child: Text("Profile"),
            )
          ]
        ),
      )
    );
  }
}