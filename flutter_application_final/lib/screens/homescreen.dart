import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(const MyApp());
// }

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CollectionReference _cars =
      FirebaseFirestore.instance.collection('cars');
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Cars'),
            backgroundColor: Colors.amber,
          ),
          body: StreamBuilder(
            stream: _cars.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.all(10),

                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(40),
                            child: Text(
                              documentSnapshot['name'],
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ],
                      ),

                      // child: ListTile(
                      //   title: Text(documentSnapshot['name']),
                      //   subtitle: Text(documentSnapshot['color']),
                      // ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
