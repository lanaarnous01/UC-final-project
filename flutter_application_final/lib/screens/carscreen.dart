import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_final/models/models.dart';

// void main() {
//   runApp(const MyApp());
// }

class CarScreen extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  CarScreen({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  var parkSpot;
  Widget row({required String text, required String info}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
        ),
        Text(
          info,
          style: TextStyle(color: Colors.blueGrey, fontSize: 20),
        ),
        Container(
          padding: EdgeInsets.only(left: 60),
          alignment: Alignment.center,
        ),
        Text(
          widget.documentSnapshot[text],
          style: TextStyle(color: Colors.blueGrey, fontSize: 18),
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.documentSnapshot['name']),
          backgroundColor: Colors.indigoAccent,
        ),
        body: Column(
          children: [
            Container(
              //  padding: EdgeInsets.all(10),
              child: Image.network(
                widget.documentSnapshot['image'],
                height: 250,
                width: 250,
              ),
            ),
            Container(
              padding: EdgeInsets.all(30),
            ),
            row(text: 'owner', info: 'Owner:'),
            row(text: 'name', info: 'Name:'),
            row(text: 'phone', info: 'Phone:'),
            row(text: 'color', info: 'Color:'),
            row(
              text: 'plateNo',
              info: 'Plate No:',
            ),
            row(text: 'spot', info: 'Spot: '),
          ],
        ),
      ),
    );
  }
}
