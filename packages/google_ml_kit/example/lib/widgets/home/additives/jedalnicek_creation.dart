import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/aditives_model.dart';
import '../../../models/jedalnicek_model.dart';
import '../../../models/settings_model.dart';

class JedalnicekCreation extends StatefulWidget {
  @override
  _JedalniceCreationState createState() => _JedalniceCreationState();
}

class _JedalniceCreationState extends State<JedalnicekCreation> {
  final User? user = FirebaseAuth.instance.currentUser;
  final settings = SettingsModel.instance;
  bool challengesVisible = false;
  final List<String> bannedAditives = [];
  final List<String> allAditives = [];
  final List<String> filteredAditives = [];
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // asing all aditives to a list
    for (var i = 0; i < AditivesModel.instance.aditivs.length; i++) {
      allAditives.add(AditivesModel.instance.aditivs.keys.elementAt(i));
    }
    filteredAditives.addAll(allAditives);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // inputfield for name of the diet
                    Container(
                      width: width,
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: Container(),
                          ),
                          SizedBox(
                            width: width - 160,
                            height: 50,
                            child: TextField(
                              controller: nameController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Názov diéty',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // searchbar
                    Container(
                      width: width,
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: null,
                            ),
                          ),
                          SizedBox(
                            width: width - 160,
                            height: 50,
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  updateFilteredAditives(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // list of added aditives in listview
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        width: width,
                        height: 200,
                        color: Colors.white,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            for (var i = 0; i < filteredAditives.length; i++)
                              aditivWidget('aditívum ${filteredAditives[i]}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // show banned aditives and minus icon in a list view
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        width: width,
                        height: 200,
                        color: Colors.white,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            for (var i = 0; i < bannedAditives.length; i++)
                              SizedBox(
                                width: 160,
                                height: 50,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            bannedAditives.removeAt(i);
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'aditiv ${bannedAditives[i]}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // confirm button
                    Container(
                      width: width,
                      height: 50,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width - 160,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () async {
                                // create new document in firebase with banned aditives and name and user id
                                await FirebaseFirestore.instance
                                    .collection('jedalnicek')
                                    .doc(nameController.text)
                                    .set({
                                  'bannedAditives': bannedAditives,
                                  'user': user!.displayName
                                });
                                await JedalnicekModel.instance
                                    .loadFromFirebase();
                              },
                              child: const Text('Vytvoriť'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateFilteredAditives(String hasToContain) {
    filteredAditives.clear();
    for (var i = 0; i < allAditives.length; i++) {
      if (allAditives[i].contains(hasToContain)) {
        filteredAditives.add(allAditives[i]);
      }
    }
  }

  // method that will create aditiv Widget with name and plus icon
  Widget aditivWidget(String name) {
    return SizedBox(
      width: 160,
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  // check if aditiv is already in banned aditives
                  if (bannedAditives.contains(name)) {
                    return;
                  }
                  bannedAditives.add(name);
                });
              },
            ),
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: Center(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
