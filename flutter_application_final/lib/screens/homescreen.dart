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

  final imageController = TextEditingController();

  final ownerController = TextEditingController();

  final phoneController = TextEditingController();

  List<String> spot = ['A1', 'A2', 'A3', 'A4', 'B1', 'B2', 'B3', 'B4'];
  String? parkSpot;

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    print('object');
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _colorController.text = documentSnapshot['color'];
      plateNoController.text = documentSnapshot['plateNo'];
      imageController.text = documentSnapshot['image'];
      ownerController.text = documentSnapshot['owner'];
      phoneController.text = documentSnapshot['phone'];
      parkSpot = documentSnapshot['spot'];
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
                    print(value);
                    parkSpot = value;
                    setState(() {});
                  },
                  value: parkSpot,
                  isExpanded: false,
                  hint: Text(
                    'Choose Parking Spot',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                    controller: ownerController,
                    decoration: const InputDecoration(
                      labelText: 'Owner',
                    )),
                TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    )),
                TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image',
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final String color = _colorController.text;
                    final String plateNo = plateNoController.text;

                    final String owner = ownerController.text;
                    final String phone = phoneController.text;
                    final String image = imageController.text;

                    await _cars.doc(documentSnapshot!.id).update({
                      "name": name,
                      "color": color,
                      "plateNo": plateNo,
                      "spot": parkSpot,
                      "owner": owner,
                      "phone": phone,
                      "image": image,
                    });
                    _nameController.text = '';
                    _colorController.text = '';
                    plateNoController.text = '';
                    spotController.text = '';
                    ownerController.text = '';
                    phoneController.text = '';
                    imageController.text = '';

                    Navigator.of(context).pop();
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
                  decoration: InputDecoration(labelText: 'Name'),
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
                    print(value);
                    parkSpot = value;
                    setState(() {});
                  },
                  value: parkSpot,
                  isExpanded: false,
                  hint: Text(
                    'Choose Parking Spot',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextField(
                  controller: ownerController,
                  decoration: InputDecoration(
                    labelText: 'Owner',
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: 'Image',
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

                    final String owner = ownerController.text;
                    final String phone = phoneController.text;
                    final String image = imageController.text;

                    await _cars.add({
                      "name": name,
                      "color": color,
                      "plateNo": plateNo,
                      "spot": parkSpot,
                      "owner": owner,
                      "phone": phone,
                      "image": image,
                    });

                    _nameController.text = '';
                    _colorController.text = '';
                    plateNoController.text = '';
                    spotController.text = '';
                    ownerController.text = '';
                    phoneController.text = '';
                    imageController.text = '';
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
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Valet Parking'),
          backgroundColor: Color.fromARGB(255, 73, 85, 145),
          actions: [
            IconButton(
              onPressed: () => create(),
              icon: Icon(Icons.add),
            )
          ],
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
                            padding: EdgeInsets.only(left: 10),
                            child: Image.network(
                              documentSnapshot['image'],
                              height: 100,
                              width: 80,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(40),
                            child: Text(documentSnapshot['spot']),
                          ),
                          Text(documentSnapshot['name']),
                          Spacer(),
                          Text(documentSnapshot['plateNo']),
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
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          },
        ),
      ),
    );
  }
}
