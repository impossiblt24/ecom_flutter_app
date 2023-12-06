// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuoiky/home_page.dart';
import 'package:cuoiky/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser;
  final usersColletion = FirebaseFirestore.instance.collection('users');
  //edit field
  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit " + field),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async{
              if (newValue.trim().length > 0 ){
                await usersColletion.doc(currentUser!.email).update({field: newValue});
                Navigator.pop(context);
              } 
            },
          )
        ],
      ),
    );

    //update in firestore
    // void updateProfile() async {
    //   if (newValue.trim().length > 0 ){
    //     await usersColletion.doc(currentUser!.email).update({field: newValue});
    //     Navigator.pop(context);
    //   } 
    // }
    
  }
  
  void goToHomePage(){
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(),
      )
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            goToHomePage();
          },
          icon: Icon(Icons.home),
        ),
  // actions: [
  //   IconButton(
  //     onPressed: () {},
  //     icon: Icon(Icons.call),
  //   ),


        title: Text("Profile Page",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
         centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users")
        .doc(currentUser!.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                SizedBox(height: 50,),
                //profile image
                Icon(
                  Icons.person,
                  size: 72,
                ),
                SizedBox(height: 10,),
                //user email
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 50,),
                
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "My Details",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                //user firstname
                MyTextBox(
                  text: userData['first name'],
                  sectionName: "First Name",
                  onPressed: () => editField('first name'),
                ),
                //user lastname
                MyTextBox(
                  text: userData['last name'],
                  sectionName: "Last Name",
                  onPressed: () => editField('last name'),
                ),
                //user address
                MyTextBox(
                  text: userData['address'],
                  sectionName: "Address",
                  onPressed: () => editField('address'),
                ),
                
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }
}