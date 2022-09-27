import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_final/screens/carscreen.dart';

// void main() {
//   runApp(const MyApp());
// }

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference _cars =
      FirebaseFirestore.instance.collection('cars');

  final _nameController = TextEditingController();

  final _colorController = TextEditingController();

  final plateNoController = TextEditingController();

  final spotController = TextEditingController();

  var selectedType;

  List<String> spot = ['A1', 'A2', 'A3'];
  var parkSpot;

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _colorController.text = documentSnapshot['color'];
      plateNoController.text = documentSnapshot['plateNo'];
      spotController.text = documentSnapshot['spot'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                  ),
                ),
                TextField(
                  controller: plateNoController,
                  decoration: const InputDecoration(
                    labelText: 'Plate No',
                  ),
                ),
                TextField(
                    controller: spotController,
                    decoration: const InputDecoration(
                      labelText: 'Spot',
                    )),
                DropdownButtonFormField(
                  items: spot
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.blue),
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      value;
                    });
                  },
                  value: selectedType,
                  isExpanded: false,
                  hint: Text(
                    'Choose Parking Spot',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String color = _colorController.text;
                    final String plateNo = plateNoController.text;
                    final String spot = spotController.text;
                    // final String spot = spotController.selection;

                    //   if (color != null) {
                    await _cars.doc(documentSnapshot!.id).update({
                      "name": name,
                      "color": color,
                      "plateNo": plateNo,
                      "spot": spot
                    });
                    _nameController.text = '';
                    _colorController.text = '';
                    plateNoController.text = '';
                    spotController.text = '';

                    Navigator.of(context).pop();
                    //   }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    labelText: 'Color',
                  ),
                ),
                TextField(
                  controller: plateNoController,
                  decoration: InputDecoration(
                    labelText: 'Plate No',
                  ),
                ),
                TextField(
                  controller: spotController,
                  decoration: InputDecoration(
                    labelText: 'Spot',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Create'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String color = _colorController.text;
                    final String plateNo = plateNoController.text;
                    final String spot = spotController.text;

                    await _cars.add({
                      "name": name,
                      "color": color,
                      "plateNo": plateNo,
                      "spot": spot
                    });

                    _nameController.text = '';
                    _colorController.text = '';
                    plateNoController.text = '';
                    spotController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> delete(String productId) async {
    await _cars.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have successfully deleted a product')));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Valet Parking'),
          backgroundColor: Colors.indigoAccent,
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
                    margin: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CarScreen(
                                      documentSnapshot: documentSnapshot,
                                    )));
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(40),
                            child: Text(documentSnapshot['name']),
                          ),
                          Text(documentSnapshot['plateNo']),
                          Spacer(),
                          Text(documentSnapshot['spot']),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => delete(documentSnapshot.id)),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => update(documentSnapshot),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => create(),
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
